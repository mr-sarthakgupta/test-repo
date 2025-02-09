#!/bin/bash

# Step 1: Run batch_eval.py with the baseline config
echo "Running baseline batch evaluation..."
python batch_eval.py --model-config configs/models_$MODEL_NUM.json --quant-config configs/baseline-config.json --num-samples 10000 --batch-size $BATCH_SIZE

# Step 2: Merge all JSON files into merged.json
echo "Merging all JSON files into merged.json..."
# find . -name "summary.json" -type f -exec cat {} + | jq -s '.' > ./logs/merged.json

echo "[" > ./logs/merged.json
first=true
find . -name "summary.json" -type f -print0 | while IFS= read -r -d '' file; do
    if [ "$first" = true ]; then
        first=false
    else
        echo "," >> ./logs/merged.json
    fi
    cat "$file" >> ./logs/merged.json
done
echo "]" >> ./logs/merged.json

echo "Merged JSON files successfully."

# Step 3: Define swap-every values
swap_values=(
    "1/4"
    "1/4 2/4"
    "1/4 2/4 3/4"
    "4/4"
    "4/4 3/4"
    "4/4 3/4 2/4"
)

# Step 4: Run batch_eval.py for each swap-every value
for swap in "${swap_values[@]}"; do
    echo "Running batch evaluation with swap-every: $swap"
    python batch_eval.py --model-config configs/models_$MODEL_NUM.json \
                         --quant-config configs/quant-config.json \
                         --quant-config-swap configs/quant-config.json \
                         --num-samples 10000 \
                         --batch-size $BATCH_SIZE \
                         --baseline-memorized logs/merged.json \
                         --swap-every "$swap"
done

echo "All evaluations completed."

git remote -v
git add logs
git commit -m "Auto update results added" || echo "commit failed"
git push -u origin main || echo "git push failed"
