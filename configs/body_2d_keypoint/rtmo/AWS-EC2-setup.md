# AWS EC2 SSH 接続 & Remote - SSH 設定手順

## **1. AWS EC2 インスタンスの確認**
### **1.1. インスタンスの状態を確認**
1. [AWS マネジメントコンソール](https://ap-southeast-2.signin.aws.amazon.com/oauth?client_id=arn%3Aaws%3Asignin%3A%3A%3Aconsole%2Fcanvas&code_challenge=twWo2HgjQq8mRJxRzTKI9lEJ71hBupxs6wVovT4q0eM&code_challenge_method=SHA-256&response_type=code&redirect_uri=https%3A%2F%2Fconsole.aws.amazon.com%2Fconsole%2Fhome%3FhashArgs%3D%2523%26isauthcode%3Dtrue%26state%3DhashArgsFromTB_ap-southeast-2_0dd4dbfc6ccc52f3)にログイン
2. EC2 ダッシュボードでインスタンスの状態を確認
3. **インスタンス(mmpose-ex)が "Running" になっていることを確認**

### **1.2. Elastic IP の確認**
- Elastic IP を使用しているか確認
- AWS EC2 の **パブリック IP アドレス** をメモする

---

## **2. セキュリティグループの設定**
### **2.1. SSH 接続許可の確認**
1. AWS コンソール → **EC2** → インスタンスを選択
2. **「セキュリティ」タブ → 「セキュリティグループ」**
3. **「インバウンドルール」に以下の設定があるか確認**
   - **タイプ**: SSH
   - **プロトコル**: TCP
   - **ポート範囲**: 22
   - **送信元**: `自分のIPアドレス /32`
   - 例: `157.82.128.20/32`

### **2.2. 現在のIPアドレスを確認**
ローカル端末で以下のコマンドを実行し、現在のグローバルIPを確認：
```sh
curl https://checkip.amazonaws.com
```
- 確認した IP が **セキュリティグループの許可リストにあるか確認**
- **異なる場合は、AWS コンソールでセキュリティグループを編集して更新**

---

## **3. SSH 秘密鍵（.pem）の準備**
### **3.1. 秘密鍵 (`.pem`) の配置**
- `.pem` ファイルを以下のディレクトリに保存：
  - **Windows**: `C:\Users\YOURUSERNAME\.ssh\`

### **3.2. 秘密鍵の権限を変更**
```sh
chmod 400 ~/.ssh/my-key.pem
```

---

## **4. SSH 接続**
### **4.1. 適切なユーザー名で接続**
AWS の OS に応じてユーザー名を変更：
```sh
ssh -i ~/.ssh/my-key.pem ec2-user@YOUR_EC2_IP    # Amazon Linux, RHEL
```

### **4.2. SSH 接続テスト**
- **接続成功すればOK**
- **接続できない場合、エラーメッセージを確認**
  - `Connection timed out` → **セキュリティグループをチェック**
  - `Permission denied` → **秘密鍵の権限（`chmod 400`）をチェック**
  - `Could not establish connection to ...` → **VPN/ネットワークの影響をチェック**

---

## **5. Remote - SSH の設定**
### **5.1. Cursor に Remote - SSH をインストール**
1. **Cursor を開く**
2. **拡張機能 (`Ctrl + Shift + X`) を開く**
3. **「Remote - SSH」を検索 → インストール**
4. **`Ctrl + Shift + P` を押して、「Remote-SSH: Connect to Host」を選択**
5. **`user@YOUR_EC2_IP` を入力して接続**

### **5.2. OS の選択**
SSH 接続後に **Linux, Windows, Mac** の選択画面が出た場合：
- **Amazon Linux / Ubuntu / CentOS / Debian** → `Linux`

---

## **6. トラブルシューティング**
### **6.1. SSH 接続エラーの原因と対策**
| **エラー** | **原因** | **解決策** |
|-----------|--------|----------|
| `Connection timed out` | セキュリティグループが SSH を許可していない | セキュリティグループのポート 22 設定を確認 |
| `Permission denied` | `.pem` の権限が適切でない | `chmod 400 ~/.ssh/my-key.pem` を実行 |
| `Could not establish connection to ...` | ネットワークや VPN の影響 | VPN を無効化し、別のネットワークで試す |

### **6.2. Remote - SSH の不具合**
- **拡張機能のログを確認**
  ```sh
  Ctrl + Shift + P → "Remote-SSH: Show Log"
  ```
- **Remote - SSH の設定を削除して再インストール**
  ```sh
  rm -rf ~/.vscode-server
  ```

---

## **7. まとめ**
✅ **AWS EC2 の状態を確認（`Running` であること）**  
✅ **Elastic IP の確認とパブリック IP の最新化**  
✅ **SSH のセキュリティグループ設定を修正**  
✅ **現在のIPアドレスをセキュリティグループに追加**  
✅ **秘密鍵の権限を適切に設定 (`chmod 400`)**  
✅ **正しいユーザー名 (`ec2-user`) を使用**  
✅ **Remote - SSH の設定を確認し、再インストールやログ解析を行う**  

