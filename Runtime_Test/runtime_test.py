import numpy as np
import pandas as pd
import time
import os


sequence_lengths = [1000, 10000, 100000, 1000000] #sequence lengths to test out
amount_of_vcfs = 1000

for i in sequence_lengths:
    total_time = 0

    with open(f'time_per_vcf_{str(i)}.txt', 'w') as f: #write to file for each vcf

        for j in range(1, amount_of_vcfs+1):

            seedprompt = str(j)
            

            prompt = f'vcfsim --chromosome 1 --replicates 1 --seed {seedprompt} --sequence_length {i} --ploidy 2 --Ne 1700000 --mu 1e-9 --percent_missing_sites 20 --percent_missing_genotypes 20 --output_file myvcf --sample_size 10'
            start_time = time.time()

            os.system(prompt)

            end_time = time.time()
            execution_time = end_time - start_time
            total_time += execution_time
            f.write(str(execution_time) + "\n")
            
            os.remove(f'myvcf{j}.vcf') #remove the vcfs when they are generated


    with open(f"total_output_time_{str(i)}.txt", "w") as file:
        file.write(str(total_time/amount_of_vcfs)) #file for total vcfs average times
