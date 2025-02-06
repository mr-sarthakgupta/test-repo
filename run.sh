#!/bin/bash

# so we have 8 GPUs available and so need to assign one to each model that we will be running.
batch_size=(2 500 250 20)

# for i in {0}; do
CUDA_VISIBLE_DEVICES=0 BATCH_SIZE=${batch_size[0]} MODEL_NUM="0" ./evaluate_memorization.sh
# done
# wait

echo "All evaluations completed."
