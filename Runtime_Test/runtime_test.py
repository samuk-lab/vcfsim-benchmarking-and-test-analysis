import numpy as np
import pandas as pd
import time
import os

start_time = time.time()


for i in range(1, 1001):

    seedprompt = str(i)
    
    prompt = 'vcfsim --chromosome 1 --replicates 1 --seed ' + seedprompt + ' --sequence_length 100000 --ploidy 2 --Ne 1700000 --mu 1e-9 --percent_missing_sites 20 --percent_missing_genotypes 20 --output_file myvcf --sample_size 10'
    
    os.system(prompt)

end_time = time.time()

execution_time = end_time - start_time

with open("output_time.txt", "w") as file:
    file.write(str(execution_time))
