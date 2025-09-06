import os
import pandas as pd
import numpy as np

def run_simulations(starting_seed, ending_seed):
    final_output_file = 'final_pixy_pi.txt'
    
    with open(final_output_file, 'w') as f:
        f.write('pop\tchromosome\twindow_pos_1\twindow_pos_2\tavg_pi\tno_sites\tcount_diffs\tcount_comparisons\tcount_missing\n')

    for i in range(starting_seed, ending_seed):
        vcfsim_prompt = f'vcfsim --seed {i} --percent_missing_sites 0 --percent_missing_genotypes 0 --output_file mychrom.vcf --sample_size 10 --param_file chrom.txt'
        bgzip_prompt = 'bgzip -f mychrom.vcf'
        tabix_prompt = 'tabix -f mychrom.vcf.gz'
        pixy_prompt = 'pixy --stats pi --vcf mychrom.vcf.gz --populations populations.txt --window_size 10000 --n_cores 2 --output_folder . --output_prefix pixy'

        os.system(vcfsim_prompt)
        os.system(bgzip_prompt)
        os.system(tabix_prompt)
        os.system(pixy_prompt)

        with open('pixy_pi.txt', 'r') as pixy_file:
            lines = pixy_file.readlines()
            with open(final_output_file, 'a') as f:
                for line in lines[1:]:  
                    f.write(line)

        os.remove('mychrom.vcf.gz')
        os.remove('mychrom.vcf.gz.tbi')
        os.remove('pixy_pi.txt')

run_simulations(1000, 6000)