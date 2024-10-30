#!/bin/bash

# Loop through numbers 1 to 100
for i in {1..100}
do
    # Print the task with the current number and redirect to the file
    echo "tsk_$i" >> populations-vcftools.txt
done
