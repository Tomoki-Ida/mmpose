#!/bin/bash

# ================================
# Run inference for multiple settings
# Results saved to CSV with AP/AR.
# ================================

CONFIG="configs/my_rtmo_coco_valid.py"
CHECKPOINT_URL="https://download.openmmlab.com/mmpose/v1/projects/rtmo/rtmo-s_8xb32-600e_coco-640x640-8db55a59_20231211.pth"

WORK_DIR_BASE="work_dirs/rtmo_coco_valid"
RESULT_CSV="work_dirs/inference_results.csv"

# Initialize CSV file
echo "setting,score_thr,nms_thr,AP,AR" > $RESULT_CSV

# Parameter sets
declare -A PARAM_SETS=(
    ["default"]="0.3 0.6"
    ["strict"]="0.5 0.4"
    ["loose"]="0.2 0.7"
)

# Function to extract AP/AR from output.log (already pasted in the canvas)
extract_ap_ar() {
    local log_file=$1
    local ap="N/A"
    local ar="N/A"

    # Main AP/AR only (IoU=0.50:0.95, area=all, maxDets=20)
    ap=$(grep "Average Precision  (AP) @\[ IoU=0.50:0.95 | area=   all | maxDets= 20" "$log_file" | awk '{print $NF}')
    ar=$(grep "Average Recall     (AR) @\[ IoU=0.50:0.95 | area=   all | maxDets= 20" "$log_file" | awk '{print $NF}')

    echo "$ap,$ar"
}

# Loop over each parameter set and run inference
for setting in "${!PARAM_SETS[@]}"; do
    read score_thr nms_thr <<< "${PARAM_SETS[$setting]}"

    # Work directory for each setting
    WORK_DIR="${WORK_DIR_BASE}_${setting}"
    SHOW_DIR="${WORK_DIR}/vis_results"
    mkdir -p "$WORK_DIR"

    # Create temporary config with adjusted score_thr and nms_thr
    CONFIG_TMP="configs/my_rtmo_coco_valid_tmp.py"
    sed "s/score_thr=[0-9.]\+/score_thr=$score_thr/" $CONFIG > $CONFIG_TMP
    sed -i "s/nms_thr=[0-9.]\+/nms_thr=$nms_thr/" $CONFIG_TMP

    # Run inference
    python tools/test.py \
        $CONFIG_TMP \
        $CHECKPOINT_URL \
        --work-dir $WORK_DIR \
        --show-dir $SHOW_DIR | tee "$WORK_DIR/output.log"

    # Extract AP/AR from log file
    LOG_FILE="$WORK_DIR/output.log"
    ap_ar=$(extract_ap_ar "$LOG_FILE")
    echo "$setting,$score_thr,$nms_thr,$ap_ar" >> $RESULT_CSV

    echo "Completed inference for $setting"
done

# Clean up temporary config
rm -f $CONFIG_TMP

echo "All inference completed. Results saved to $RESULT_CSV"