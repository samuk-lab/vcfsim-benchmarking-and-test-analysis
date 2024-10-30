#!/bin/bash

VCF_FILE="VCFsim1234.vcf"

echo "Calculating proportion of missing data per individual..."
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ${VCF_FILE} | \
    awk '{
        miss=0; 
        total=0;
        for(i=3; i<=NF; i++) {
            total++;
            if($i=="./." || $i==".|.") miss++;
        } 
        print miss/total
    }' > missing_data_per_individual.txt

echo "Calculating proportion of missing data per site..."
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ${VCF_FILE} | \
    awk '{
        miss=0; 
        total=0;
        for(i=3; i<=NF; i++) {
            total++;
            if($i=="./." || $i==".|.") miss++;
        }
        print miss
    }' | awk '{sum+=$1} END {print sum/NR}' > missing_data_per_site.txt

echo "Missing data calculation completed."
