#!/bin/bash

conda activate vcfsim

vcfsim --chromosome 1 --replicates 1 --seed 1234 --sequence_length 10000 --ploidy 2 --Ne 100000 --mu .000001 --percent_missing_sites 50 --percent_missing_genotypes 50 --output_file myvcf --sample_size 10

vcfsim --chromosome 1 --replicates 1 --seed 1234 --sequence_length 10000 --ploidy 4 --Ne 100000 --mu .000001 --percent_missing_sites 0 --percent_missing_genotypes 0 --output_file myvcf_tetra --sample_size 10
