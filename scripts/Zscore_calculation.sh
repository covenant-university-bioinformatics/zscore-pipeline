#!/usr/bin/env bash

##### Parameters
bin_dir="."
gwas_summary=$1;
outputdir=$2

gwas_basename=$(basename ${gwas_summary})
#check if the input file contains zscore
########## Get column indexes and check minimum fields number
read -r line < "$gwas_summary"     ## read first line from file into 'line'
IFS=$' '                ## set IFS to word-split on '\t'
fieldarray=($line);     ## fill 'fldarray' with fields in line
## Get column indexes
z=$(echo $line |tr " " "\n"|grep -inx 'z\|zscore\|z_score\|z.score\|stat'| cut -d: -f1);

###### estimate z score if it is not exist
if [[ $z -eq "" ]];
then
  Rscript --vanilla ${bin_dir}/Zscore_calculation.R ${gwas_summary} ${outputdir} ${gwas_basename}
else
  cp ${gwas_summary} ${outputdir}/
fi


#  ./Zscore_calculation.sh UKB_bv_height_SMR_0.05.txt ouput
# important columns
#beta and (se or pvalue)