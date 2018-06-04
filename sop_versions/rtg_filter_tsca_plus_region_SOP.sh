#!/bin/bash

vcf_dir=$1
output_dir=$2
target_bed=$3

if [ $# -ne 3 ];then
    printf "Usage: $0 vcf_dir output_dir target_bed\n" 
    exit 1
fi

for vcf in $vcf_dir/*.vcf
do
	sample_base=${vcf##*/}
	sample_base_no_ext=${sample_base%%.*}
	#vcf_comp_out=${vcf_dir}/${sample_base_no_ext}.gz
	
	bgzip -i -c $vcf > ${vcf}.gz
	tabix -f -p vcf ${vcf}.gz
	
	newFileName=${output_dir}/${sample_base_no_ext}.TSCAfilters.vcf
	rtg vcffilter \
	-i ${vcf}.gz -o - --include-bed $target_bed --fail="OUTSIDE_ROI" | \
	rtg vcffilter \
	-i - -o - --javascript /media/sf_BigShare/SCID/scripts/TSCA_filter_SOP.js | \
	awk '/^#CHROM/ { printf("##FILTER=<ID=FAIL_VF_LOW,Description=\"VF Less Than 0.156\">\n" \
	"##FILTER=<ID=FAIL_GQ_LOW,Description=\"GQ Less Than 3.01\">\n" \
	"##FILTER=<ID=FAIL_GQX_LOW,Description=\"GQX Less Than 6\">\n" \
	"##FILTER=<ID=FAIL_QD_LOW,Description=\"QD Less Than 2.87\">\n" \
	"##FILTER=<ID=FAIL_QUAL_LOW,Description=\"QUAL Less Than 72.9\">\n" \
	"##FILTER=<ID=FAIL_DP_LOW,Description=\"DP Less Than 3\">\n" \
	"##FILTER=<ID=PASS_DEFAULT,Description=\"Does Not Fail Other Filters\">\n");} {print;}' - > $newFileName
	bgzip -i -c $newFileName > ${newFileName}.gz
	tabix -f -p vcf ${newFileName}.gz
done