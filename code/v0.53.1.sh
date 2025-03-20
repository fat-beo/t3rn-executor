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
    # Cài đặt thư viện phụ trợ
    apt update
    apt install curl -y

    # Tạo thư mục
    echo "Đang tạo thư mục t3rn..."
    mkdir -p /root/t3rn
    cd /root/t3rn

    # Tải dữ liệu từ GitHub
    # Download latest release
    curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
    grep -Po '"tag_name": "\K.*?(?=")' | \
    xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz

    if [ $? -ne 0 ]; then
        echo "Tải dữ liệu thất bại!"
        exit 1
    fi
    echo "Tải dữ liệu thành công."

    # Giải nén tệp tải về
    echo "Giải nén file executor-linux..."
    tar -xzf executor-linux-*.tar.gz
    if [ $? -ne 0 ]; then
        echo "Giải nén thất bại!"
        exit 1
    fi
    echo "Giải nén thành công."

    # Nhập thông tin từ người dùng
    read -p "Nhập RPC TESTNET ARBT: " RPC_ENDPOINTS_ARBT
    read -p "Nhập RPC TESTNET BSSP: " RPC_ENDPOINTS_BSSP
    read -p "Nhập RPC TESTNET OPSP: " RPC_ENDPOINTS_OPSP
    read -p "Nhập RPC TESTNET UNIT: " RPC_ENDPOINTS_UNIT
    read -p "Nhập EXECUTOR_MAX_L3_GAS_PRICE: " EXECUTOR_MAX_L3_GAS_PRICE
    read -p "Nhập PRIVATE_KEY_LOCAL (Không chứa '0x'): " PRIVATE_KEY_LOCAL

    # Tạo file env.sh
    echo "Tạo file biến môi trường env.sh..."
    cat <<EOF > /root/t3rn/executor/env.sh
#!/bin/bash

export NODE_ENV="testnet"
export LOG_LEVEL="debug"
export LOG_PRETTY="false"
export ENABLED_NETWORKS="arbitrum-sepolia,base-sepolia,optimism-sepolia,l2rn"
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API="false"
export EXECUTOR_PROCESS_BIDS_ENABLED="true"
export EXECUTOR_PROCESS_ORDERS_ENABLED="true"
export EXECUTOR_PROCESS_CLAIMS_ENABLED="true"
export EXECUTOR_MAX_L3_GAS_PRICE="$EXECUTOR_MAX_L3_GAS_PRICE"
export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
export RPC_ENDPOINTS='{
    "l2rn": ["https://b2n.rpc.caldera.xyz/http"],
    "arbt": ["https://arbitrum-sepolia.drpc.org", "$RPC_ENDPOINTS_ARBT"],
    "bast": ["https://base-sepolia-rpc.publicnode.com", "$RPC_ENDPOINTS_BSSP"],
    "opst": ["https://sepolia.optimism.io", "$RPC_ENDPOINTS_OPSP"],
    "unit": ["https://unichain-sepolia.drpc.org", "$RPC_ENDPOINTS_UNIT"]
}'
EOF

    # Đặt quyền cho file env.sh
    chmod 600 /root/t3rn/executor/env.sh

    # Cấu hình service systemd
    echo "Cấu hình dịch vụ t3rn-executor..."
    sudo tee /etc/systemd/system/t3rn-executor.service > /dev/null <<EOF
[Unit]
Description=t3rn Executor Service
After=network.target

[Service]
EnvironmentFile=/root/t3rn/executor/env.sh
ExecStart=/root/t3rn/executor/executor/bin/executor
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

    # Khởi động dịch vụ
    echo "Khởi động dịch vụ t3rn-executor..."
    sudo systemctl daemon-reload
    sudo systemctl enable t3rn-executor.service
    sudo systemctl start t3rn-executor.service

    if [ $? -eq 0 ]; then
        echo "Dịch vụ đã khởi động thành công!"
    else
        echo "Khởi động dịch vụ thất bại, kiểm tra log bằng 'journalctl -u t3rn-executor.service'."
    fi

    read -n 1 -s -r -p "Nhấn phím bất kỳ để quay lại menu..."
}

function logs() {
    journalctl -u t3rn-executor.service -f
    read -n 1 -s -r -p "Nhấn phím bất kỳ để quay lại menu..."
}

function delete() {
    echo "Đang xóa node..."
    sudo systemctl stop t3rn-executor.service
    sudo systemctl disable t3rn-executor.service
    sudo rm -f /etc/systemd/system/t3rn-executor.service
    sudo rm -rf /root/t3rn
    sudo systemctl daemon-reload
    echo "Node đã được xóa thành công."

    read -n 1 -s -r -p "Nhấn phím bất kỳ để quay lại menu..."
}

main
