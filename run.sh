#!/bin/bash

# so we have 8 GPUs available and so need to assign one to each model that we will be running.
batch_size=(1000 500 250 20)

for i in {0..3}; do
    (CUDA_VISIBLE_DEVICES=$i BATCH_SIZE=${batch_size[$i]} MODEL_NUM=$i ./evaluate_memorization.sh) &
done
wait

echo "All evaluations completed."
