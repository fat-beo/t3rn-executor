# T3rn Executor
# Hướng dẫn cài đặt T3rn Executor tự động.
``` 
=======================================================
 _____ _  _____   __  __ _   _ ____  ____  _   ___   __ 
|  ___/ \|_   _| |  \/  | | | |  _ \|  _ \| | | \ \ / / 
| |_ / _ \ | |   | |\/| | | | | |_) | |_) | |_| |\ V /  
|  _/ ___ \| |   | |  | | |_| |  _ <|  __/|  _  | | |   
|_|/_/   \_|_|   |_|  |_|\___/|_| \_|_|   |_| |_| |_|   

=======================================================
```
---

Nếu bạn cần hỗ trợ hoặc báo cáo lỗi, hãy liên hệ chúng tôi qua:

- [Telegram](https://t.me/MurphyNodeRunner) 
- [Twitter](https://x.com/murphy_node) 
- [Linktr.ee](https://linktr.ee/murphynodeteam)
## Yêu cầu tài nguyên
**Cấu hình:**
<table border="1">
  <tr>
    <th>Tên phần cứng</th>
    <th>Tối thiểu</th>
    <th>Ổn định</th>
  </tr>
  <tr>
    <td>CPU</td>
    <td>Không yêu cầu</td>
    <td>Không yêu cầu</td>
  </tr>
  <tr>
    <td>Ram</td>
    <td>Không yêu cầu</td>
    <td>Không yêu cầu</td>
  </tr>
  <tr>
    <td>GPU</td>
    <td>Không yêu cầu</td>
    <td>Không yêu cầu</td>
  </tr>
  <tr>
    <td>Disk</td>
    <td>Không yêu cầu</td>
    <td>Không yêu cầu</td>
  </tr>
  <tr>
    <td>Bandwidth</td>
    <td>Không yêu cầu</td>
    <td>Không yêu cầu</td>
  </tr>
</table>

**Token:**
<table border="1">
  <tr>
    <th>Mạng</th>
    <th>Số lượng </th>
  </tr>
  <tr>
    <td>arbitrum-sepolia</td>
    <td>>= 2 ETH testnet</td>
  </tr>
    <tr>
    <td>blast-sepolia</td>
    <td>>= 2 ETH testnet</td>
  </tr>
  <tr>
    <td>base-sepolia</td>
    <td>>= 10 ETH testnet</td>
  </tr>
  <tr>
    <td>optimism-sepolia</td>
    <td>>= 10 ETH testnet</td>
  </tr>
  <tr>
    <td>l1rn (<a  href="https://faucet.brn.t3rn.io/" target="_blank"> faucet here</a> )</td>
    <td>> 0.1 BRN</td>
  </tr>
</table>



## 1. Phiên bản
[LINUX - T3rn Executor v0.32.0](https://github.com/fat-murphy/t3rn-executor/archive/refs/tags/v0.32.0.tar.gz)

## 2. Đăng ký

**RPC Sepolia: [Alchemy Signup Here](https://dashboard.alchemy.com/usage)**

- Truy cập `Alchemy` -> đăng ký tài khoản.
- Truy cập `Dashbroad` -> `Apps` -> `Create new app`
  
![Ảnh](img/t3rn-alchemy.png)

- Điền thông tin app
  
![Ảnh](img/t3rn-createapp.png)

- Chọn mạng (ARB, OP, BASE, BLAST)

![Ảnh](img/t3rn-select.png)

- Chọn tất cả các dịch vụ

![Ảnh](img/t3rn-service.png)

- Chuyển tab `Networks` -> đổi mạng sang Sepolia cho các mạng vừa chọn

![Ảnh](img/t3rn-finish.png)

**RPC sẽ tương tự như này:**
  - ARBT: https://arb-sepolia.g.alchemy.com/v2/xxxx
  - BSSP: https://base-sepolia.g.alchemy.com/v2/xxxx
  - OPPS: https://opt-sepolia.g.alchemy.com/v2/xxxx
  - BLSS: https://blast-sepolia.g.alchemy.com/v2/xxxx

## 3. Thiết lập và cài đặt
**Tải file cấu hình và giải nén**
```
# Truy cập quyền root

sudo -i
```
```
# Cập nhật hệ thống và cài đặt curl

apt-get update && apt-get upgrade -y
apt install curl -y
```
```
# Cài đặt node

curl -L -o t3rnSetup.zip https://github.com/user-attachments/files/18298261/t3rnSetup.zip && \
unzip t3rnSetup.zip && \
chmod +x ./t3rnSetup.sh && \
rm -rf t3rnSetup.zip && \
bash ./t3rnSetup.sh
```

**Cấu hình node**
  - Chọn tác vụ `1` -> Điền các `RPC`, `Gas` , `PrivateKey` như sau (Gas khuyến nghị >= 100).
 
 ![Ảnh](img/t3rn-config.png)
  - Chọn tác vụ `2` -> xem trạng thái node.
  
 ![Ảnh](img/t3rn-logs.png)
  > Khi thấy logs được sync là bạn đã cài đặt thành công
  > BRN nhận được phụ thuộc vào số lượng bid thành công của bạn (tăng gas sẽ dễ dàng nhận được bid hơn)

## 4. Kiểm tra số lượng BRN
**Truy cập đường link sau, thay thế `address` bằng địa chỉ của bạn:**
https://bridge.t1rn.io/executor/address/total
