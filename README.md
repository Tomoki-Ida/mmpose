# MMPose Docker 環境

このリポジトリは、[MMPose](https://github.com/open-mmlab/mmpose)をDocker環境で簡単に実行するための設定を提供します。

## 概要

MMPoseは、PyTorchベースのオープンソースの姿勢推定ツールボックスです。このDockerセットアップにより、環境構築の手間を省き、すぐにMMPoseを使い始めることができます。

## 主な機能

- 事前構築されたDocker環境
- GPUサポート（CUDA対応）
- 必要なライブラリとツールの自動インストール
- 最新のMMPoseフレームワーク対応

## 必要条件

- Docker
- NVIDIA GPU（推奨）
- NVIDIA Dockerのインストール（GPUを使用する場合）

## 使用方法

### 1. Dockerイメージのビルド

```bash
docker build -t mmpose-docker .
```

### 2. コンテナの実行

GPUを使用する場合：
```bash
docker run --gpus all -it mmpose-docker
```


注意：コンテナを停止後も保持したい場合は上記のコマンドを使用してください。
一時的な実行で停止後にコンテナを削除する場合は、`--rm`オプションを追加できます。

### 3. データセットのマウント

ホストマシンのデータセットをコンテナにマウントする場合：
```bash
docker run --gpus all -it -v /path/to/dataset:/mmpose/data mmpose-docker
```

### 4. コンテナの管理

コンテナの一覧表示：
```bash
docker ps -a
```

停止したコンテナの再開：
```bash
docker start <container_id>
docker attach <container_id>
```

## ディレクトリ構造

```
mmpose-docker/
├── docker/         # Dockerファイルと関連設定
├── configs/        # MMPose設定ファイル
├── checkpoints/    # 事前学習済みモデル
├── results/        # 推論結果の出力先
└── tools/         # 実行スクリプトとユーティリティ
```

## トラブルシューティング

- GPUが認識されない場合は、NVIDIA Dockerが正しくインストールされているか確認してください
- メモリ不足の場合は、Dockerコンテナのメモリ制限を調整してください
- データセットのパーミッションエラーが発生した場合は、マウントしたボリュームの権限を確認してください

## 参考リンク

- [MMPose 公式ドキュメント](https://mmpose.readthedocs.io/)
- [OpenMMLab](https://openmmlab.com/)
- [Docker ドキュメント](https://docs.docker.com/)

## ライセンス

このプロジェクトは[Apache 2.0ライセンス](LICENSE)の下で公開されています。
