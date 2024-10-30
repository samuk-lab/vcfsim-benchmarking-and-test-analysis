import msprime 
import numpy as np
import os
import pandas as pd

def RunVCFSim(seed, rownum, missing_rows):
    #Classic prompt ive been using lmao, except this time we have argument specifying the amount of missing genotypes we want
    seedprompt = str(seed)

    #prompt = f'python3 __main__.py --chromosome 1 --replicates 1 --seed {seedprompt} --sequence_length {rownum} --ploidy 2 --Ne 1700000 --mu 1e-9 --percent_missing_sites {missing_rows} --percent_missing_genotypes 0 --output_file VCFsim  --sample_size 10'
    prompt = f'vcfsim --chromosome 1 --replicates 1 --seed {seedprompt} --sequence_length {rownum} --ploidy 2 --Ne 1700000 --mu 1e-9 --percent_missing_sites {missing_rows} --percent_missing_genotypes 0 --output_file VCFsim  --sample_size 10'
    #Update package and run this test again once change is merged

    os.system(prompt)

def RunTest(seed, rownum, max_missing, filename):
    percent = []
    missing_data_list = []
    
    for i in range(max_missing + 1):
        RunVCFSim(seed=seed, rownum=rownum, missing_rows=i)
        
        with open('VCFsim1234.vcf', 'r') as file:
            row_count = sum(1 for line in file)
        
        actual_missing = max_missing - (row_count - 6)
        print(f'The file has {actual_missing} amount of missing rows')
        percent_missing = i 
        
        percent.append(percent_missing)
        missing_data_list.append(actual_missing)
        
        os.remove('VCFsim1234.vcf')
    
    df = pd.DataFrame({
        'Percent Missing': percent,
        'Missing Data': missing_data_list
    })
    
    df.to_csv(filename, index=False)
    print(f"Results saved to {filename}")

seed = 1234
rownum = 100
max_missing = 100
filename = 'missing_output.csv'

RunTest(seed = seed, rownum = rownum, max_missing = max_missing, filename = filename)

