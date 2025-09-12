import msprime 
import numpy as np
import os
import pandas as pd

def RunVCFSim(seed):
    seedprompt = str(seed)
    prompt = 'vcfsim --chromosome 1 --replicates 1 --seed ' + seedprompt + ' --sequence_length 10000 --ploidy 2 --Ne 1700000 --mu 1e-9 --percent_missing_sites 0 --percent_missing_genotypes 0 --output_file VCFsim  --sample_size 10'
    os.system(prompt)

def RunVCFSimPixy(seed):
    vcfsim = 'VCFsim' + str(seed) + '.vcf'
    vcfsimprompt1 = 'bgzip -f ' + vcfsim
    vcfsimprompt2 = 'tabix -f ' + vcfsim + '.gz' 
    vcfsimprompt3 = 'pixy --stats pi --populations populations.txt --vcf ' + vcfsim + '.gz --window_size 10000 --n_cores 2 --output_folder . --output_prefix pixy'
    os.system(vcfsimprompt1)
    os.system(vcfsimprompt2)
    os.system(vcfsimprompt3)
    vcf_df = pd.read_csv('pixy_pi.txt', comment='#', sep='\t', header=None)
    temp_vcfsim_pi = vcf_df[4][1]
    new_row = pd.DataFrame({'seed': [seed], 'vcfsim_pi': [temp_vcfsim_pi]})
    return new_row

def RunVCFSimVCFTools(seed):
    vcfsim = 'VCFsim' + str(seed) + '.vcf'
    vcfsimprompt3 = 'vcftools --vcf '+ vcfsim +' --window-pi 10000 --chr 1 --out output_vcfsim.file.txt'
    os.system(vcfsimprompt3)
    vcf_df = pd.read_csv('output_vcfsim.file.txt.windowed.pi', comment='#', sep='\t', header=None)
    temp_vcfsim_pi = vcf_df[4][1]
    new_row = pd.DataFrame({'seed': [seed], 'vcfsim_pi': [temp_vcfsim_pi]})
    return new_row
    
def ConversionPixy(seed):
    vcfsim = 'VCFsim' + str(seed) + '.vcf'
    vcfsimprompt1 = 'bgzip -f ' + vcfsim
    vcfsimprompt2 = 'tabix -f ' + vcfsim + '.gz' 
    vcfsimprompt3 = 'pixy --stats pi --populations populations.txt --vcf ' + vcfsim + '.gz --window_size 10000 --n_cores 2 --output_folder . --output_prefix pixy'
    os.system('bgzip -f modified_msprime.vcf')
    os.system('tabix -f modified_msprime.vcf.gz')
    os.system('pixy --stats pi --populations populations.txt --vcf modified_msprime.vcf.gz  --window_size 10000 --n_cores 2 --bypass_invariant_check yes --output_folder . --output_prefix pixy')
    vcf_df = pd.read_csv('pixy_pi.txt', comment='#', sep='\t', header=None)
    temp_msprime_pi = vcf_df[4][1]
    os.system(vcfsimprompt1)
    os.system(vcfsimprompt2)
    os.system(vcfsimprompt3)
    vcf_df = pd.read_csv('pixy_pi.txt', comment='#', sep='\t', header=None)
    temp_vcfsim_pi = vcf_df[4][1]
    new_row = pd.DataFrame({'seed': [seed], 'msprime_pi': [temp_msprime_pi], 'vcfsim_pi': [temp_vcfsim_pi]})
    return new_row

def ConversionVCFTools(seed):
    vcfsim = 'VCFsim' + str(seed) + '.vcf'
    vcfsimprompt = 'vcftools --vcf '+ vcfsim +' --window-pi 10000 --chr 1 --out output_vcfsim.file.txt'
    os.system('vcftools --vcf modified_msprime.vcf --window-pi 10000 --chr 1 --out output_msprime.file.txt')
    vcf_df = pd.read_csv('output_msprime.file.txt.windowed.pi', comment='#', sep='\t', header=None)
    temp_msprime_pi = vcf_df[4][1]
    os.system(vcfsimprompt)
    vcf_df = pd.read_csv('output_vcfsim.file.txt.windowed.pi', comment='#', sep='\t', header=None)
    temp_vcfsim_pi = vcf_df[4][1]
    new_row = pd.DataFrame({'seed': [seed], 'msprime_pi': [temp_msprime_pi], 'vcfsim_pi': [temp_vcfsim_pi]})
    return new_row

def runMultiplePixyVCFSim(startingseed, end):
    columns = ['seed', 'vcfsim_pi']
    test_df = pd.DataFrame(columns=columns)
    for i in range(end - startingseed):
        RunVCFSim(startingseed + i)
        new_data = RunVCFSimPixy(startingseed + i)
        test_df = pd.concat([test_df, new_data], ignore_index=True)
        vcfsim1 = 'VCFsim' + str(startingseed + i) + '.vcf.gz'
        vcfsim2 = 'VCFsim' + str(startingseed + i) + '.vcf.gz.tbi'
        os.remove('pixy_pi.txt')
        os.remove(vcfsim1)
        os.remove(vcfsim2)
    test_df.to_csv('PixyVCFSim', sep='\t', index=False, encoding='utf-8')

def runMultipleVCFToolsVCFSim(startingseed, end):
    columns = ['seed', 'vcfsim_pi']
    test_df = pd.DataFrame(columns=columns)
    for i in range(end - startingseed):
        RunVCFSim(startingseed + i)
        new_data = RunVCFSimVCFTools(startingseed + i)
        test_df = pd.concat([test_df, new_data], ignore_index=True)
        vcfsim1 = 'VCFsim' + str(startingseed + i) + '.vcf'
        os.remove(vcfsim1)
    test_df.to_csv('NewResultsVCFTools', sep='\t', index=False, encoding='utf-8')

def runMultiplePixyTests(startingseed, end):
    columns = ['seed', 'msprime_pi', 'vcfsim_pi']
    test_df = pd.DataFrame(columns=columns)
    for i in range(end - startingseed):
        RunVCFSim(startingseed + i)
        new_data = ConversionPixy(startingseed + i)
        test_df = pd.concat([test_df, new_data], ignore_index=True)
        vcfsim1 = 'VCFsim' + str(startingseed + i) + '.vcf.gz'
        vcfsim2 = 'VCFsim' + str(startingseed + i) + '.vcf.gz.tbi'
        os.remove('modified_msprime.vcf.gz')
        os.remove('modified_msprime.vcf.gz.tbi')
        os.remove('pixy_pi.txt')
        os.remove(vcfsim1)
        os.remove(vcfsim2)
        print(test_df)
    test_df.to_csv('NewResultsPixy', sep='\t', index=False, encoding='utf-8')
    
def runMultipleVCFToolsTests(startingseed, end):
    columns = ['seed', 'msprime_pi', 'vcfsim_pi']
    test_df = pd.DataFrame(columns=columns)
    for i in range(end - startingseed):
        RunVCFSim(startingseed + i)
        new_data = ConversionVCFTools(startingseed + i)
        test_df = pd.concat([test_df, new_data], ignore_index=True)
        vcfsim1 = 'VCFsim' + str(startingseed + i) + '.vcf'
        os.remove('modified_msprime.vcf')
        os.remove(vcfsim1)
    test_df.to_csv('NewResultsVCFTools', sep='\t', index=False, encoding='utf-8')

#runMultipleVCFToolsVCFSim(17001, 22000)
runMultiplePixyVCFSim(1000, 11001)
#runMultiplePixyTests(1000, 2000)
#runMultipleVCFToolsTests(1000, 11000)
#RunVCFSim(1234)