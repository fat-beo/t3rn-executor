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
Github: https://github.com/fat-beo
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
            1) install ;;
            2) logs ;;
            3) delete ;;
            4) echo "Thoát!" ; exit 0 ;;
            *) echo "Lỗi. Nhập lại lựa chọn hợp lệ 1 - 4." ;;
        esac
    done
}

function install() {
    apt install curl -y

    echo "Đang tạo thư mục t3rn..."
    mkdir -p /root/t3rn
    cd /root/t3rn

    echo "Đang tải executor-linux-v0.53.1.tar.gz..."
    curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
    grep -Po '"tag_name": "\K.*?(?=")' | \
    xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz

    if [ $? -ne 0 ]; then
        echo "Tải dữ liệu thất bại!!"
        exit 1
    fi

    echo "Giải nén executor-linux-v0.53.1.tar.gz..."
    tar -xzf executor-linux-*.tar.gz || { echo "Giải nén thất bại."; exit 1; }

    read -p "Nhập RPC TESTNET ARBT: " RPC_ENDPOINTS_ARBT
    read -p "Nhập RPC TESTNET BSSP: " RPC_ENDPOINTS_BSSP
    read -p "Nhập RPC TESTNET OPSP: " RPC_ENDPOINTS_OPSP
    read -p "Nhập RPC TESTNET UNIT: " RPC_ENDPOINTS_UNIT
    read -p "Nhập EXECUTOR_MAX_L3_GAS_PRICE: " EXECUTOR_MAX_L3_GAS_PRICE
    read -p "Nhập PRIVATE_KEY_LOCAL (Không chứa '0x'): " PRIVATE_KEY_LOCAL

    # Xuất biến môi trường
    echo "Xuất biến môi trường..."
    export NODE_ENV="testnet"
    export LOG_LEVEL="debug"
    export LOG_PRETTY="false"
    export ENABLED_NETWORKS="arbitrum-sepolia,base-sepolia,optimism-sepolia,l2rn"
    export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API="false"
    export EXECUTOR_MAX_L3_GAS_PRICE="$EXECUTOR_MAX_L3_GAS_PRICE"
    export EXECUTOR_PROCESS_BIDS_ENABLED="true"
    export EXECUTOR_PROCESS_ORDERS_ENABLED="true"
    export EXECUTOR_PROCESS_CLAIMS_ENABLED="true"
    export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
    export RPC_ENDPOINTS="{\"l2rn\": [\"https://b2n.rpc.caldera.xyz/http\"],\
        \"arbt\": [\"https://arbitrum-sepolia.drpc.org\", \"$RPC_ENDPOINTS_ARBT\"],\
        \"bast\": [\"https://base-sepolia-rpc.publicnode.com\", \"$RPC_ENDPOINTS_BSSP\"],\
        \"opst\": [\"https://sepolia.optimism.io\", \"$RPC_ENDPOINTS_OPSP\"],\
        \"unit\": [\"https://unichain-sepolia.drpc.org\", \"$RPC_ENDPOINTS_UNIT\"]}"

    # Tạo systemd service mà không chứa biến môi trường
    sudo tee /etc/systemd/system/t3rn-executor.service > /dev/null <<EOF
[Unit]
Description=t3rn Executor Service
After=network.target

[Service]
ExecStart=/root/t3rn/executor/executor/bin/executor
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

    # Khởi động dịch vụ
    sudo systemctl daemon-reload
    sudo systemctl enable t3rn-executor.service
    sudo systemctl start t3rn-executor.service

    echo "Cài đặt hoàn tất!"
    read -n 1 -s -r -p "Nhập phím bất kỳ để quay lại menu..."
    main
}

function logs() {
    journalctl -u t3rn-executor.service -f
    read -n 1 -s -r -p "Nhập phím bất kỳ để quay lại menu..."
    main
}

function delete() {
    sudo systemctl stop t3rn-executor.service
    sudo systemctl disable t3rn-executor.service
    sudo rm /etc/systemd/system/t3rn-executor.service

    echo "Xóa executor..."
    sudo rm -rf /root/t3rn

    sudo systemctl daemon-reload
    echo "Xóa node thành công."
    
    read -n 1 -s -r -p "Nhập phím bất kỳ để quay lại menu..."
    main
}

main
