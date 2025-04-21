# AWS EC2 での MMPose 環境構築手順

## 1. EC2 インスタンスのセットアップ

### 1.1 インスタンスの作成
リージョンがアジアパシフィック(東京)であることを確認
- AWS マネジメントコンソールから EC2 インスタンスを起動
- GPU を使用するため，インスタンスタイプは `g4dn.xlarge`を選択

### 1.2 セキュリティグループの設定
- SSH 接続（ポート `22`）を許可

### 1.3 SSH 接続
```bash
ssh -i "your-key.pem" ubuntu@your-ec2-instance-ip
```

---
## 2. 必要なソフトウェアのインストール

### 2.1 システムパッケージの更新
```bash
sudo apt update -y && sudo apt upgrade -y
```

### 2.2 Python のインストール
```bash
sudo apt install -y python3 python3-venv python3-pip
```

### 2.3 Git のインストール
```bash
sudo apt install -y git
```

---
## 3. Python 仮想環境の作成と有効化
```bash
python3 -m venv venv
source venv/bin/activate
```

### 3.1 pip のアップグレード
```bash
pip install --upgrade pip
```

---
## 4. CUDA と cuDNN のインストール（GPU 使用時）

### 4.1 NVIDIA ドライバのインストール
```bash
sudo apt install -y nvidia-driver-525
```

### 4.2 CUDA Toolkit のインストール
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update
sudo apt install -y cuda-toolkit-11-8
```

### 4.3 cuDNN のインストール
```bash
sudo apt install -y libcudnn8
```

### 4.4 GPU の確認
```bash
nvidia-smi
```

---
## 5. PyTorch のインストール

```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

---
## 6. MMPose のインストール

### 6.1 OpenMIM のインストール
```bash
pip install openmim
```

### 6.2 MMCV のインストール
```bash
mim install mmcv-full
```

### 6.3 リポジトリのクローン
```bas
git clone https://github.com/open-mmlab/mmpose.git
cd mmpose
```

### 6.4 必要なライブラリのインストール
```bash
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
pip install openmim
mim install mmcv==2.1.0
mim install mmdet
mim install mmengine
```

---
## 7. MMPose デモの実行

### 7.1 必要なファイルのダウンロード
```bash
mkdir -p checkpoints
wget https://download.openmmlab.com/mmpose/top_down/hrnet/hrnet_w48_coco_256x192-0e67c616_20220913.pth -P checkpoints/
```

### 7.2 デモの実行
```bash
python demo/image_demo.py \
    tests/data/coco/000000000785.jpg \
    configs/body_2d_keypoint/topdown_heatmap/coco/td-hm_hrnet-w48_8xb32-210e_coco-256x192.py \
    checkpoints/hrnet_w48_coco_256x192-0e67c616_20220913.pth \
    --out-file vis_results.jpg \
    --draw-heatmap
```
発生したエラーと対処方法

_`pickle.UnpicklingError: Weights only load failed` → `mmpose/apis/inference.py` の `load_checkpoint` を `weights_only=False` に修正。

```bash
nano ~/mmpose/venv/lib/python3.10/site-packages/mmengine/runner/checkpoint.py
```

```python
#修正前
checkpoint = torch.load(filename, map_location=map_location) #347行目付近
#修正後（weights_only=Falseを追加）
checkpoint = torch.load(filename, map_location=map_location, weights_only=False)
```

変更を保存 (Ctrl + X → Y → Enter) して、仮想環境を再起動
```bash
deactivate  # 仮想環境を抜ける
source venv/bin/activate  # 仮想環境を再度アクティベート
```

---
## 8. 追加の確認

### 8.1 Python 仮想環境の有効化（再ログイン後）
```bash
source venv/bin/activate
```

### 8.2 MMPose の環境確認
```bash
python -c "import mmpose; print(mmpose.__version__)"
```

