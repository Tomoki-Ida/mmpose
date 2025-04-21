# MMPose RTMO 推論実行記録

このドキュメントは，EC2上でMMPoseのRTMOモデルを用いてCOCOのvalidデータに対する推論を実行し，結果を取得・分析するまでの作業手順を記録したものである．

---

## **1. 環境準備**
### 1.1 仮想環境の起動
```bash
source venv/bin/activate
```

### 1.2 EC2上にデータをダウンロード
```bash
# COCOのvalid画像データ
download http://images.cocodataset.org/zips/val2017.zip
unzip val2017.zip -d ~/mmpose/dataset/coco/

# COCOのアノテーションデータ
download http://images.cocodataset.org/annotations/annotations_trainval2017.zip
unzip annotations_trainval2017.zip -d ~/mmpose/dataset/coco/
```

---
## **2. 推論用の設定ファイル作成**
configファイル(my_rtmo_coco_valid.py)のdatasetの指定をアップロードしたファイルのパスに書き換える．


---

## **3. 推論実行**
### 3.1 テスト用スクリプトの実行
APやARなどの性能評価指標の値を得ると同時に、いくつかの画像に対して予測されたキーポイントを重ね合わせて可視化する．
```bash
python tools/test.py     configs/my_rtmo_coco_valid.py
https://download.openmmlab.com/mmpose/v1/projects/rtmo/rtmo-s_8xb32-600e_coco-640x640-8db55a59_20231211.pth
--work-dir work_dirs/rtmo_coco_valid
--show-dir work_dirs/rtmo_coco_valid/vis_results
```

### 3.2 パラメータ比較用推論スクリプトの実行
test_cfgのscore_thrやnms_thrなどのパラメータを変更して得られる結果の違いを記録する．
```bash
bash run_inference_and_eval.sh
```

---

##  **4. CSV結果の取得**
### 4.1 EC2からローカルにダウンロード
```bash
scp -i /path/to/your-key.pem ubuntu@<YOUR_EC2_IP>:~/mmpose/work_dirs/inference_results.csv .
```

Cursorを使ってEC2にSSH接続している場合は，Cursor上でファイルを右クリックして「ダウンロード」も可能．
#### 手順
1. VSCodeのエクスプローラでwork_dirs/inference_results.csvを表示
2. 右クリック → 「Download」を選択
3. 保存場所を指定してローカルに保存

### 4.2 CSVの内容（出力イメージ）

|setting|score_thr|nms_thr|AP|AR|
|:----:|:----:|:----:|:----:|:----:|
|strict|0.5|0.4|0.651|0.680|
|default|0.3|0.6|0.670|0.703|
|loose|0.2|0.7|0.675|0.711|

---