import msprime 
import numpy as np
import os
import pandas as pd

def RunVCFSim(seed, missing_genotypes):
    #Classic prompt ive been using lmao, except this time we have argument specifying the amount of missing genotypes we want
    seedprompt = str(seed)
    #prompt = f'python3 __main__.py --chromosome 1 --replicates 1 --seed {seedprompt} --sequence_length 10000 --ploidy 2 --Ne 1700000 --mu 1e-9 --percent_missing_sites 0 --percent_missing_genotypes {missing_genotypes} --output_file VCFsim  --sample_size 100'
    prompt2 = f'vcfsim --chromosome 1 --replicates 1 --seed {seedprompt} --sequence_length 10000 --ploidy 2 --Ne 1700000 --mu 1e-9 --percent_missing_sites 0 --percent_missing_genotypes {missing_genotypes} --output_file VCFsim  --sample_size 100'

    os.system(prompt2)


def runMissingGeneTest(start_missing, max_missing, iterate_missing, seed):
    run_bash_script = f'./calculate_missing_data.sh'
    missing_data_list = []
    percent = []

    
    #Run from 0 to whatever tf we want
    for i in range (start_missing, max_missing, iterate_missing):
        RunVCFSim(seed, i)
        os.system(run_bash_script)

        with open('missing_data_per_site.txt', 'r') as file:
            #Read value for this file which contains the average missing data from every site
            value = file.read().strip()  
        
        missing = float(value)  

        print(i, missing)
        missing_data_list.append(missing)
        percent.append(i)
        #We round up or down depending on the amount of individuals, like 10 individuals and 12 percent, we would just round down to 10
        #Same for if it were 15 we round up to 20
        
        #Then we remove all the generated files
        os.remove('VCFsim1234.vcf')
        #os.remove('modified_msprime.vcf') #depending on prompt used
        os.remove('missing_data_per_individual.txt')
        os.remove('missing_data_per_site.txt')

    return percent, missing_data_list
    
def save_test_results_to_csv(filename):
    percent, missing_data_list = runMissingGeneTest(start_missing = 0, max_missing = 101, iterate_missing = 1, seed = 1234)


    # Create a DataFrame from missing data
    df = pd.DataFrame({
        'Percent Missing': percent,
        'Missing Data': missing_data_list
    })

    # Output the DataFrame to a CSV file
    df.to_csv(filename, index=False)
    print(f"Results saved to {filename}")

save_test_results_to_csv('missing_gene_test_results.csv')
        
    