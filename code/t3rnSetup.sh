#!/bin/bash

# Check if the script is run as root user
if [ "$(id -u)" != "0" ]; then
    echo "Sử dụng người dùng ROOT để chạy!"
    echo "Nhập câu lệnh 'sudo -i' để đăng nhập với quyền ROOT."
    exit 1
fi

function main() {
    while true; do
        clear
        echo "
=======================================================
 _____ _  _____   __  __ _   _ ____  ____  _   ___   __ 
|  ___/ \|_   _| |  \/  | | | |  _ \|  _ \| | | \ \ / / 
| |_ / _ \ | |   | |\/| | | | | |_) | |_) | |_| |\ V /  
|  _/ ___ \| |   | |  | | |_| |  _ <|  __/|  _  | | |   
|_|/_/   \_|_|   |_|  |_|\___/|_| \_|_|   |_| |_| |_|   

=======================================================
Github: https://github.com/fat-murphy
Telegram: https://t.me/MurphyNodeRunner
Twitter: https://x.com/Murphy_Node
=======================================================
        "
        echo "Truy cập Telegram của Murphynode nếu bạn cần hỗ trợ."
        echo "======================================================="
        echo "Lựa chọn tác vụ:"
        echo "1) Cài đặt node"
        echo "2) Xem trạng thái node"
        echo "3) Xóa node"
        echo "4) Thoát"
        
        read -p "Nhập lựa chọn (1/2/3/4): " select
        
        case $select in
            1)
                install
                ;;
            2)
                logs
                ;;
            3)
                delete
                ;;
            4)
                echo "Thoát!"
                exit 0
                ;;
            *)
                echo "Lỗi. Nhập lại lựa chọn hợp lệ 1 - 4."
                ;;
        esac
    done
}

function install() {
    # Tải thư viện phụ
    apt install curl -y


    # Tạo thư mục
    echo "Đang tạo thư mục t3rn..."
    mkdir t3rn
    cd t3rn

    # Tải dữ liệu
    echo "Đang tải executor-linux-v0.33.0.tar.gz..."
    curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
    grep -Po '"tag_name": "\K.*?(?=")' | \
    xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz


    # Kiểm tra trạng thái
    if [ $? -eq 0 ]; then
        echo "Tải dữ liệu thành công."
    else
        echo "Tải dữ liệu thất bại!!"
        exit 1
    fi

    # Giải nén
    echo "Giải nén executor-linux-v0.33.0.tar.gz..."
    tar -xzf executor-linux-*.tar.gz

    # Kiểm tra cài đặt thành công
    if [ $? -eq 0 ]; then
        echo "Giải nén thành công."
    else
        echo "Giải nén thất bại. Thực hiện câu lệnh 'ls -a' để kiểm tra tập tin."
        rm executor-linux-v0.33.0.tar.gz
        exit 1
    fi

    # Kiểm tra thư mục
    # ls | grep -q 'folder'

    # Cấu hình node
    read -p "Nhập RPC_ENDPOINTS_ARBT: " RPC_ENDPOINTS_ARBT
    read -p "Nhập RPC_ENDPOINTS_BSSP: " RPC_ENDPOINTS_BSSP
    read -p "Nhập RPC_ENDPOINTS_OPSP: " RPC_ENDPOINTS_OPSP
    read -p "Nhập RPC_ENDPOINTS_BLSS: " RPC_ENDPOINTS_BLSS
    read -p "Nhập EXECUTOR_MAX_L3_GAS_PRICE: " EXECUTOR_MAX_L3_GAS_PRICE
    read -p "Nhập PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL

    # Cấu hình dịch vụ
    sudo tee /etc/systemd/system/t3rn-executor.service > /dev/null <<EOF
    [Unit]
    Description=t3rn Executor Service
    After=network.target

    [Service]
    ExecStart=/root/executor/executor/bin/executor
    Environment="NODE_ENV=testnet"
    Environment="LOG_LEVEL=debug"
    Environment="LOG_PRETTY=false"
    Environment="ENABLED_NETWORKS=arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l1rn"
    Environment="RPC_ENDPOINTS_L1RN=https://brn.rpc.caldera.xyz/"
    Environment="RPC_ENDPOINTS_ARBT=$RPC_ENDPOINTS_ARBT"
    Environment="RPC_ENDPOINTS_BSSP=$RPC_ENDPOINTS_BSSP"
    Environment="RPC_ENDPOINTS_BLSS=$RPC_ENDPOINTS_BLSS"
    Environment="RPC_ENDPOINTS_OPSP=$RPC_ENDPOINTS_OPSP"
    Environment="EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false"
    Environment="EXECUTOR_MAX_L3_GAS_PRICE=$EXECUTOR_MAX_L3_GAS_PRICE"
    Environment="EXECUTOR_PROCESS_ORDERS=true"
    Environment="EXECUTOR_PROCESS_CLAIMS=true"
    Environment="PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL"
    Restart=always
    RestartSec=5
    User=$USER

    [Install]
    WantedBy=multi-user.target
EOF

    # Khởi động dịch vụ
    sudo systemctl daemon-reload
    sudo systemctl enable t3rn-executor.service
    sudo systemctl start t3rn-executor.service

    read -n 1 -s -r -p "Nhập phím bất kỳ để thoát..."
    main
}

# xem trạng thái của node
function logs() {
    journalctl -u t3rn-executor.service -f

    read -n 1 -s -r -p "Nhập phím bất kỳ để thoát..."
    main
}

# Delete node function
function delete() {
    sudo systemctl stop t3rn-executor.service
    sudo systemctl disable t3rn-executor.service
    sudo rm /etc/systemd/system/t3rn-executor.service

    echo "Xóa executor..."
    sudo rm -rf /root/executor

    sudo systemctl daemon-reload
    echo "Xóa nốt thành công."

    # Prompt the user to press any key to return to the main menu
    read -n 1 -s -r -p "Nhập phím bất kỳ để thoát..."
    main
}

main