# T3rn Executor
# Hướng dẫn cài đặt T3rn Executor tự động.
![Ảnh](./images/fatbeo_murphy.png)

Nếu bạn cần hỗ trợ hoặc báo cáo lỗi, hãy liên hệ chúng tôi qua:

- [Telegram](https://t.me/urifallon) 
- [Twitter](https://x.com/gnoud_ur1) 
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
    <td>Unichain</td>
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
    <td>BRN (<a  href="https://b2n.hub.caldera.xyz" target="_blank"> faucet here</a> )</td>
    <td>> 0.01 BRN</td>
  </tr>
</table>



## 1. Phiên bản
| Đã được tự động

## 2. Đăng ký

**RPC Sepolia: [Alchemy Signup Here](https://dashboard.alchemy.com/usage)**

- Truy cập `Alchemy` -> đăng ký tài khoản.
- Truy cập `Dashbroad` -> `Apps` -> `Create new app`
  
![Ảnh](./images/t3rn-alchemy.jpg)

- Điền thông tin app
  
![Ảnh](./images/t3rn-createapp.jpg)

- Chọn mạng (ARB, OP, BASE)

![Ảnh](./images/t3rn-select.jpg)

- Chọn tất cả các dịch vụ

![Ảnh](./images/t3rn-service.jpg)

- Chuyển tab `Networks` -> đổi mạng sang Sepolia cho các mạng vừa chọn

![Ảnh](./images/t3rn-finish.jpg)

**RPC sẽ tương tự như này:**
  - ARBT: https://arb-sepolia.g.alchemy.com/v2/xxxx
  - BSSP: https://base-sepolia.g.alchemy.com/v2/xxxx
  - OPPS: https://opt-sepolia.g.alchemy.com/v2/xxxx

## 3. Thiết lập và cài đặt
**Tải file cấu hình và giải nén**
```
# Truy cập quyền root
sudo -i
```
```
# Cài đặt executor
wget -O v2executor.sh https://raw.githubusercontent.com/fat-beo/t3rn-executor/refs/heads/main/v2executor.sh && sed -i 's/\r$//' v2executor.sh && chmod +x v2executor.sh
```
```
# Chạy executor
./v2executor.sh
```

**Cấu hình node**
  - Chọn tác vụ `1` -> Điền các `RPC`, `Gas` , `PrivateKey` như sau (Gas khuyến nghị >= 100).
 
 ![Ảnh](./images/t3rn-config.jpg
)
  - Chọn tác vụ `2` -> xem trạng thái node.
  
 ![Ảnh](./images/t3rn-logs.jpg
)
  > Khi thấy logs được sync là bạn đã cài đặt thành công
  > BRN nhận được phụ thuộc vào số lượng bid thành công của bạn (tăng gas sẽ dễ dàng nhận được bid hơn)

## 4. Kiểm tra số lượng BRN
**Truy cập đường link sau:**
[Exeplorer](https://b2n.explorer.caldera.xyz/)
