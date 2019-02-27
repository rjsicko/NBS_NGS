#!/bin/bash

####Author: Bob Sicko robert.sicko@health.ny.gov
####
####
####polyTG_table_v1.0.sh
####This script genotypes CFTR TG(m)T(n) alleles from fastq files. Our specific use case is ArcherDX VariantPlex CFTR fastqs.
####Disclaimer: We have validated the results generated by this script for our use case, your results may vary. User assumes all risk with the use of this script.
####The idea for this script came from: Pagin A, Devos A, Figeac M, Truant M, Willoquaux C, Broly F, et al. (2016) Applicability and Efficiency of NGS in Routine Diagnosis: In-Depth Performance Analysis of a Complete Workflow for CFTR Mutation Analysis. PLoS ONE 11(2): e0149426. doi:10.1371/journal.pone.0149426 


input_dir=$1
out_dir=$2

if [ $# -ne 2 ];then
    printf "polyTG_table_v1.0.sh Usage: $0 input_dir output_dir\n" 
    exit 1
fi

mkdir -p $out_dir

#polyTGT_counts.txt
printf "sample	total_reads_at_locus	(TG)4(T)2_count	(TG)4(T)3_count	(TG)4(T)4_count	(TG)4(T)5_count	(TG)4(T)6_count	(TG)4(T)7_count	(TG)4(T)8_count	(TG)4(T)9_count	(TG)4(T)10_count	(TG)5(T)2_count	(TG)5(T)3_count	(TG)5(T)4_count	(TG)5(T)5_count	(TG)5(T)6_count	(TG)5(T)7_count	(TG)5(T)8_count	(TG)5(T)9_count	(TG)5(T)10_count	(TG)6(T)2_count	(TG)6(T)3_count	(TG)6(T)4_count	(TG)6(T)5_count	(TG)6(T)6_count	(TG)6(T)7_count	(TG)6(T)8_count	(TG)6(T)9_count	(TG)6(T)10_count	(TG)7(T)2_count	(TG)7(T)3_count	(TG)7(T)4_count	(TG)7(T)5_count	(TG)7(T)6_count	(TG)7(T)7_count	(TG)7(T)8_count	(TG)7(T)9_count	(TG)7(T)10_count	(TG)8(T)2_count	(TG)8(T)3_count	(TG)8(T)4_count	(TG)8(T)5_count	(TG)8(T)6_count	(TG)8(T)7_count	(TG)8(T)8_count	(TG)8(T)9_count	(TG)8(T)10_count	(TG)9(T)2_count	(TG)9(T)3_count	(TG)9(T)4_count	(TG)9(T)5_count	(TG)9(T)6_count	(TG)9(T)7_count	(TG)9(T)8_count	(TG)9(T)9_count	(TG)9(T)10_count	(TG)10(T)2_count	(TG)10(T)3_count	(TG)10(T)4_count	(TG)10(T)5_count	(TG)10(T)6_count	(TG)10(T)7_count	(TG)10(T)8_count	(TG)10(T)9_count	(TG)10(T)10_count	(TG)11(T)2_count	(TG)11(T)3_count	(TG)11(T)4_count	(TG)11(T)5_count	(TG)11(T)6_count	(TG)11(T)7_count	(TG)11(T)8_count	(TG)11(T)9_count	(TG)11(T)10_count	(TG)12(T)2_count	(TG)12(T)3_count	(TG)12(T)4_count	(TG)12(T)5_count	(TG)12(T)6_count	(TG)12(T)7_count	(TG)12(T)8_count	(TG)12(T)9_count	(TG)12(T)10_count	(TG)13(T)2_count	(TG)13(T)3_count	(TG)13(T)4_count	(TG)13(T)5_count	(TG)13(T)6_count	(TG)13(T)7_count	(TG)13(T)8_count	(TG)13(T)9_count	(TG)13(T)10_count	(TG)14(T)2_count	(TG)14(T)3_count	(TG)14(T)4_count	(TG)14(T)5_count	(TG)14(T)6_count	(TG)14(T)7_count	(TG)14(T)8_count	(TG)14(T)9_count	(TG)14(T)10_count\n" > $out_dir/polyTGT_counts.txt

#polyTGT_percents.txt
printf "sample	total_reads_at_locus	sum_our_geno	percent_our_geno_vs_total_at_locus	(TG)4(T)2_percent	(TG)4(T)3_percent	(TG)4(T)4_percent	(TG)4(T)5_percent	(TG)4(T)6_percent	(TG)4(T)7_percent	(TG)4(T)8_percent	(TG)4(T)9_percent	(TG)4(T)10_percent	(TG)5(T)2_percent	(TG)5(T)3_percent	(TG)5(T)4_percent	(TG)5(T)5_percent	(TG)5(T)6_percent	(TG)5(T)7_percent	(TG)5(T)8_percent	(TG)5(T)9_percent	(TG)5(T)10_percent	(TG)6(T)2_percent	(TG)6(T)3_percent	(TG)6(T)4_percent	(TG)6(T)5_percent	(TG)6(T)6_percent	(TG)6(T)7_percent	(TG)6(T)8_percent	(TG)6(T)9_percent	(TG)6(T)10_percent	(TG)7(T)2_percent	(TG)7(T)3_percent	(TG)7(T)4_percent	(TG)7(T)5_percent	(TG)7(T)6_percent	(TG)7(T)7_percent	(TG)7(T)8_percent	(TG)7(T)9_percent	(TG)7(T)10_percent	(TG)8(T)2_percent	(TG)8(T)3_percent	(TG)8(T)4_percent	(TG)8(T)5_percent	(TG)8(T)6_percent	(TG)8(T)7_percent	(TG)8(T)8_percent	(TG)8(T)9_percent	(TG)8(T)10_percent	(TG)9(T)2_percent	(TG)9(T)3_percent	(TG)9(T)4_percent	(TG)9(T)5_percent	(TG)9(T)6_percent	(TG)9(T)7_percent	(TG)9(T)8_percent	(TG)9(T)9_percent	(TG)9(T)10_percent	(TG)10(T)2_percent	(TG)10(T)3_percent	(TG)10(T)4_percent	(TG)10(T)5_percent	(TG)10(T)6_percent	(TG)10(T)7_percent	(TG)10(T)8_percent	(TG)10(T)9_percent	(TG)10(T)10_percent	(TG)11(T)2_percent	(TG)11(T)3_percent	(TG)11(T)4_percent	(TG)11(T)5_percent	(TG)11(T)6_percent	(TG)11(T)7_percent	(TG)11(T)8_percent	(TG)11(T)9_percent	(TG)11(T)10_percent	(TG)12(T)2_percent	(TG)12(T)3_percent	(TG)12(T)4_percent	(TG)12(T)5_percent	(TG)12(T)6_percent	(TG)12(T)7_percent	(TG)12(T)8_percent	(TG)12(T)9_percent	(TG)12(T)10_percent	(TG)13(T)2_percent	(TG)13(T)3_percent	(TG)13(T)4_percent	(TG)13(T)5_percent	(TG)13(T)6_percent	(TG)13(T)7_percent	(TG)13(T)8_percent	(TG)13(T)9_percent	(TG)13(T)10_percent	(TG)14(T)2_percent	(TG)14(T)3_percent	(TG)14(T)4_percent	(TG)14(T)5_percent	(TG)14(T)6_percent	(TG)14(T)7_percent	(TG)14(T)8_percent	(TG)14(T)9_percent	(TG)14(T)10_percent\n" > $out_dir/polyTGT_percents.txt

#polyTGT_calls.txt
printf "sample	total_reads_at_locus	sum_our_geno	percent_our_geno_vs_total_at_locus	top_geno_1_name	top_geno_1_count	top_geno_1_percent	top_geno_2_name	top_geno_2_count	top_geno_2_percent	ratio_top_2	zygosity\n" > $out_dir/polyTGT_calls.txt

for R1 in $input_dir/*R1*
do
	R2=${R1//R1_001.fastq.gz/R2_001.fastq.gz}
	prefix=$(echo ${R1} | sed "s/_L001_R1_\001\.fastq.gz//") 
	#echo ${prefix}_L001_R1_001.fastq ${prefix}_L001_R2_001.fastq
	#echo $prefix
	#R1=${prefix}_L001_R1_001.fastq.gz
	#R2=${prefix}_L001_R2_001.fastq.gz
	#echo $R1
	#echo $R2
	out_base=${prefix##*/}

	#echo "R1:" $R1 '	' "R2:" $R2 '	' "prefix" $prefix '	' "out_base" $out_base
	fiveP30=ATATCTGACAAACTCATCTTTTATTTTTGA
	threeP30=AACAGGGATTTGGGGAATTATTTGAGAAAG
	
	fiveP20=AACTCATCTTTTATTTTTGA
	threeP20=AACAGGGATTTGGGGAATTA
	temp_file=$(mktemp)
	trap "rm -f $temp_file" 0 2 3 15
	#note: this will double count some reads. if a read contains the 5' and 3' 30bp leader, it'll match both of these greps. This might be fine, we'll see.
	
	#speed up grep: https://stackoverflow.com/questions/13913014/grepping-a-huge-file-80gb-any-way-to-speed-it-up
	zcat $R1 $R2 | LC_ALL=C fgrep $fiveP20 > $temp_file
	zcat $R1 $R2 | LC_ALL=C fgrep $threeP20 >> $temp_file
	
	#total reads that cover entire TG(x)T(y) region
	#use regexp grep to count reads that have at least 4 TGs, two Ts and at least 1 base on each side 
	
	total_reads=$(egrep 'A(TG){4,}(T){2,}A' $temp_file | wc -l)
	
	#TG4 block
	TG4T2=ATGTGTGTGTTA
	TG4T3=ATGTGTGTGTTTA
	TG4T4=ATGTGTGTGTTTTA
	TG4T5=ATGTGTGTGTTTTTA
	TG4T6=ATGTGTGTGTTTTTTA
	TG4T7=ATGTGTGTGTTTTTTTA
	TG4T8=ATGTGTGTGTTTTTTTTA
	TG4T9=ATGTGTGTGTTTTTTTTTA
	TG4T10=ATGTGTGTGTTTTTTTTTTA
	
	#TG5 block
	TG5T2=ATGTGTGTGTGTTA
	TG5T3=ATGTGTGTGTGTTTA
	TG5T4=ATGTGTGTGTGTTTTA
	TG5T5=ATGTGTGTGTGTTTTTA
	TG5T6=ATGTGTGTGTGTTTTTTA
	TG5T7=ATGTGTGTGTGTTTTTTTA
	TG5T8=ATGTGTGTGTGTTTTTTTTA
	TG5T9=ATGTGTGTGTGTTTTTTTTTA
	TG5T10=ATGTGTGTGTGTTTTTTTTTTA
	
	#TG6 block
	TG6T2=ATGTGTGTGTGTGTTA
	TG6T3=ATGTGTGTGTGTGTTTA
	TG6T4=ATGTGTGTGTGTGTTTTA
	TG6T5=ATGTGTGTGTGTGTTTTTA
	TG6T6=ATGTGTGTGTGTGTTTTTTA
	TG6T7=ATGTGTGTGTGTGTTTTTTTA
	TG6T8=ATGTGTGTGTGTGTTTTTTTTA
	TG6T9=ATGTGTGTGTGTGTTTTTTTTTA
	TG6T10=ATGTGTGTGTGTGTTTTTTTTTTA
	
	#TG7 block
	TG7T2=ATGTGTGTGTGTGTGTTA
	TG7T3=ATGTGTGTGTGTGTGTTTA
	TG7T4=ATGTGTGTGTGTGTGTTTTA
	TG7T5=ATGTGTGTGTGTGTGTTTTTA
	TG7T6=ATGTGTGTGTGTGTGTTTTTTA
	TG7T7=ATGTGTGTGTGTGTGTTTTTTTA
	TG7T8=ATGTGTGTGTGTGTGTTTTTTTTA
	TG7T9=ATGTGTGTGTGTGTGTTTTTTTTTA
	TG7T10=ATGTGTGTGTGTGTGTTTTTTTTTTA
	
	#TG8 block
	TG8T2=ATGTGTGTGTGTGTGTGTTA
	TG8T3=ATGTGTGTGTGTGTGTGTTTA
	TG8T4=ATGTGTGTGTGTGTGTGTTTTA
	TG8T5=ATGTGTGTGTGTGTGTGTTTTTA
	TG8T6=ATGTGTGTGTGTGTGTGTTTTTTA
	TG8T7=ATGTGTGTGTGTGTGTGTTTTTTTA
	TG8T8=ATGTGTGTGTGTGTGTGTTTTTTTTA
	TG8T9=ATGTGTGTGTGTGTGTGTTTTTTTTTA
	TG8T10=ATGTGTGTGTGTGTGTGTTTTTTTTTTA
	
	#TG9 block
	TG9T2=ATGTGTGTGTGTGTGTGTGTTA
	TG9T3=ATGTGTGTGTGTGTGTGTGTTTA
	TG9T4=ATGTGTGTGTGTGTGTGTGTTTTA
	TG9T5=ATGTGTGTGTGTGTGTGTGTTTTTA
	TG9T6=ATGTGTGTGTGTGTGTGTGTTTTTTA
	TG9T7=ATGTGTGTGTGTGTGTGTGTTTTTTTA
	TG9T8=ATGTGTGTGTGTGTGTGTGTTTTTTTTA
	TG9T9=ATGTGTGTGTGTGTGTGTGTTTTTTTTTA
	TG9T10=ATGTGTGTGTGTGTGTGTGTTTTTTTTTTA
	
	#TG10 block
	TG10T2=ATGTGTGTGTGTGTGTGTGTGTTA
	TG10T3=ATGTGTGTGTGTGTGTGTGTGTTTA
	TG10T4=ATGTGTGTGTGTGTGTGTGTGTTTTA
	TG10T5=ATGTGTGTGTGTGTGTGTGTGTTTTTA
	TG10T6=ATGTGTGTGTGTGTGTGTGTGTTTTTTA
	TG10T7=ATGTGTGTGTGTGTGTGTGTGTTTTTTTA
	TG10T8=ATGTGTGTGTGTGTGTGTGTGTTTTTTTTA
	TG10T9=ATGTGTGTGTGTGTGTGTGTGTTTTTTTTTA
	TG10T10=ATGTGTGTGTGTGTGTGTGTGTTTTTTTTTTA
	
	#TG11 block
	TG11T2=ATGTGTGTGTGTGTGTGTGTGTGTTA
	TG11T3=ATGTGTGTGTGTGTGTGTGTGTGTTTA
	TG11T4=ATGTGTGTGTGTGTGTGTGTGTGTTTTA
	TG11T5=ATGTGTGTGTGTGTGTGTGTGTGTTTTTA
	TG11T6=ATGTGTGTGTGTGTGTGTGTGTGTTTTTTA
	TG11T7=ATGTGTGTGTGTGTGTGTGTGTGTTTTTTTA
	TG11T8=ATGTGTGTGTGTGTGTGTGTGTGTTTTTTTTA
	TG11T9=ATGTGTGTGTGTGTGTGTGTGTGTTTTTTTTTA
	TG11T10=ATGTGTGTGTGTGTGTGTGTGTGTTTTTTTTTTA
	
	#TG12 block
	TG12T2=ATGTGTGTGTGTGTGTGTGTGTGTGTTA
	TG12T3=ATGTGTGTGTGTGTGTGTGTGTGTGTTTA
	TG12T4=ATGTGTGTGTGTGTGTGTGTGTGTGTTTTA
	TG12T5=ATGTGTGTGTGTGTGTGTGTGTGTGTTTTTA
	TG12T6=ATGTGTGTGTGTGTGTGTGTGTGTGTTTTTTA
	TG12T7=ATGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTA
	TG12T8=ATGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTA
	TG12T9=ATGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTTA
	TG12T10=ATGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTTTA
	
	#TG13 block
	TG13T2=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTA
	TG13T3=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTTA
	TG13T4=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTTTA
	TG13T5=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTA
	TG13T6=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTA
	TG13T7=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTA
	TG13T8=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTA
	TG13T9=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTTA
	TG13T10=ATGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTTTA
	
	#TG14 block
	TG14T2=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTA
	TG14T3=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTA
	TG14T4=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTTA
	TG14T5=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTA
	TG14T6=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTA
	TG14T7=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTA
	TG14T8=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTA
	TG14T9=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTTA
	TG14T10=ATGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTTTTTTTTA
	
	#counts
	count4_2=$(LC_ALL=C fgrep $TG4T2 $temp_file | wc -l)
	count4_3=$(LC_ALL=C fgrep $TG4T3 $temp_file | wc -l)
	count4_4=$(LC_ALL=C fgrep $TG4T4 $temp_file | wc -l)
	count4_5=$(LC_ALL=C fgrep $TG4T5 $temp_file | wc -l)
	count4_6=$(LC_ALL=C fgrep $TG4T6 $temp_file | wc -l)
	count4_7=$(LC_ALL=C fgrep $TG4T7 $temp_file | wc -l)
	count4_8=$(LC_ALL=C fgrep $TG4T8 $temp_file | wc -l)
	count4_9=$(LC_ALL=C fgrep $TG4T9 $temp_file | wc -l)
	count4_10=$(LC_ALL=C fgrep $TG4T10 $temp_file | wc -l)
	
	count5_2=$(LC_ALL=C fgrep $TG5T2 $temp_file | wc -l)
	count5_3=$(LC_ALL=C fgrep $TG5T3 $temp_file | wc -l)
	count5_4=$(LC_ALL=C fgrep $TG5T4 $temp_file | wc -l)
	count5_5=$(LC_ALL=C fgrep $TG5T5 $temp_file | wc -l)
	count5_6=$(LC_ALL=C fgrep $TG5T6 $temp_file | wc -l)
	count5_7=$(LC_ALL=C fgrep $TG5T7 $temp_file | wc -l)
	count5_8=$(LC_ALL=C fgrep $TG5T8 $temp_file | wc -l)
	count5_9=$(LC_ALL=C fgrep $TG5T9 $temp_file | wc -l)
	count5_10=$(LC_ALL=C fgrep $TG5T10 $temp_file | wc -l)
	
	count6_2=$(LC_ALL=C fgrep $TG6T2 $temp_file | wc -l)
	count6_3=$(LC_ALL=C fgrep $TG6T3 $temp_file | wc -l)
	count6_4=$(LC_ALL=C fgrep $TG6T4 $temp_file | wc -l)
	count6_5=$(LC_ALL=C fgrep $TG6T5 $temp_file | wc -l)
	count6_6=$(LC_ALL=C fgrep $TG6T6 $temp_file | wc -l)
	count6_7=$(LC_ALL=C fgrep $TG6T7 $temp_file | wc -l)
	count6_8=$(LC_ALL=C fgrep $TG6T8 $temp_file | wc -l)
	count6_9=$(LC_ALL=C fgrep $TG6T9 $temp_file | wc -l)
	count6_10=$(LC_ALL=C fgrep $TG6T10 $temp_file | wc -l)
	
	count7_2=$(LC_ALL=C fgrep $TG7T2 $temp_file | wc -l)
	count7_3=$(LC_ALL=C fgrep $TG7T3 $temp_file | wc -l)
	count7_4=$(LC_ALL=C fgrep $TG7T4 $temp_file | wc -l)
	count7_5=$(LC_ALL=C fgrep $TG7T5 $temp_file | wc -l)
	count7_6=$(LC_ALL=C fgrep $TG7T6 $temp_file | wc -l)
	count7_7=$(LC_ALL=C fgrep $TG7T7 $temp_file | wc -l)
	count7_8=$(LC_ALL=C fgrep $TG7T8 $temp_file | wc -l)
	count7_9=$(LC_ALL=C fgrep $TG7T9 $temp_file | wc -l)
	count7_10=$(LC_ALL=C fgrep $TG7T10 $temp_file | wc -l)
	
	count8_2=$(LC_ALL=C fgrep $TG8T2 $temp_file | wc -l)
	count8_3=$(LC_ALL=C fgrep $TG8T3 $temp_file | wc -l)
	count8_4=$(LC_ALL=C fgrep $TG8T4 $temp_file | wc -l)
	count8_5=$(LC_ALL=C fgrep $TG8T5 $temp_file | wc -l)
	count8_6=$(LC_ALL=C fgrep $TG8T6 $temp_file | wc -l)
	count8_7=$(LC_ALL=C fgrep $TG8T7 $temp_file | wc -l)
	count8_8=$(LC_ALL=C fgrep $TG8T8 $temp_file | wc -l)
	count8_9=$(LC_ALL=C fgrep $TG8T9 $temp_file | wc -l)
	count8_10=$(LC_ALL=C fgrep $TG8T10 $temp_file | wc -l)
	
	count9_2=$(LC_ALL=C fgrep $TG9T2 $temp_file | wc -l)
	count9_3=$(LC_ALL=C fgrep $TG9T3 $temp_file | wc -l)
	count9_4=$(LC_ALL=C fgrep $TG9T4 $temp_file | wc -l)
	count9_5=$(LC_ALL=C fgrep $TG9T5 $temp_file | wc -l)
	count9_6=$(LC_ALL=C fgrep $TG9T6 $temp_file | wc -l)
	count9_7=$(LC_ALL=C fgrep $TG9T7 $temp_file | wc -l)
	count9_8=$(LC_ALL=C fgrep $TG9T8 $temp_file | wc -l)
	count9_9=$(LC_ALL=C fgrep $TG9T9 $temp_file | wc -l)
	count9_10=$(LC_ALL=C fgrep $TG9T10 $temp_file | wc -l)
	
	count10_2=$(LC_ALL=C fgrep $TG10T2 $temp_file | wc -l)
	count10_3=$(LC_ALL=C fgrep $TG10T3 $temp_file | wc -l)
	count10_4=$(LC_ALL=C fgrep $TG10T4 $temp_file | wc -l)
	count10_5=$(LC_ALL=C fgrep $TG10T5 $temp_file | wc -l)
	count10_6=$(LC_ALL=C fgrep $TG10T6 $temp_file | wc -l)
	count10_7=$(LC_ALL=C fgrep $TG10T7 $temp_file | wc -l)
	count10_8=$(LC_ALL=C fgrep $TG10T8 $temp_file | wc -l)
	count10_9=$(LC_ALL=C fgrep $TG10T9 $temp_file | wc -l)
	count10_10=$(LC_ALL=C fgrep $TG10T10 $temp_file | wc -l)
	
	count11_2=$(LC_ALL=C fgrep $TG11T2 $temp_file | wc -l)
	count11_3=$(LC_ALL=C fgrep $TG11T3 $temp_file | wc -l)
	count11_4=$(LC_ALL=C fgrep $TG11T4 $temp_file | wc -l)
	count11_5=$(LC_ALL=C fgrep $TG11T5 $temp_file | wc -l)
	count11_6=$(LC_ALL=C fgrep $TG11T6 $temp_file | wc -l)
	count11_7=$(LC_ALL=C fgrep $TG11T7 $temp_file | wc -l)
	count11_8=$(LC_ALL=C fgrep $TG11T8 $temp_file | wc -l)
	count11_9=$(LC_ALL=C fgrep $TG11T9 $temp_file | wc -l)
	count11_10=$(LC_ALL=C fgrep $TG11T10 $temp_file | wc -l)
	
	count12_2=$(LC_ALL=C fgrep $TG12T2 $temp_file | wc -l)
	count12_3=$(LC_ALL=C fgrep $TG12T3 $temp_file | wc -l)
	count12_4=$(LC_ALL=C fgrep $TG12T4 $temp_file | wc -l)
	count12_5=$(LC_ALL=C fgrep $TG12T5 $temp_file | wc -l)
	count12_6=$(LC_ALL=C fgrep $TG12T6 $temp_file | wc -l)
	count12_7=$(LC_ALL=C fgrep $TG12T7 $temp_file | wc -l)
	count12_8=$(LC_ALL=C fgrep $TG12T8 $temp_file | wc -l)
	count12_9=$(LC_ALL=C fgrep $TG12T9 $temp_file | wc -l)
	count12_10=$(LC_ALL=C fgrep $TG12T10 $temp_file | wc -l)
	
	count13_2=$(LC_ALL=C fgrep $TG13T2 $temp_file | wc -l)
	count13_3=$(LC_ALL=C fgrep $TG13T3 $temp_file | wc -l)
	count13_4=$(LC_ALL=C fgrep $TG13T4 $temp_file | wc -l)
	count13_5=$(LC_ALL=C fgrep $TG13T5 $temp_file | wc -l)
	count13_6=$(LC_ALL=C fgrep $TG13T6 $temp_file | wc -l)
	count13_7=$(LC_ALL=C fgrep $TG13T7 $temp_file | wc -l)
	count13_8=$(LC_ALL=C fgrep $TG13T8 $temp_file | wc -l)
	count13_9=$(LC_ALL=C fgrep $TG13T9 $temp_file | wc -l)
	count13_10=$(LC_ALL=C fgrep $TG13T10 $temp_file | wc -l)
	
	count14_2=$(LC_ALL=C fgrep $TG14T2 $temp_file | wc -l)
	count14_3=$(LC_ALL=C fgrep $TG14T3 $temp_file | wc -l)
	count14_4=$(LC_ALL=C fgrep $TG14T4 $temp_file | wc -l)
	count14_5=$(LC_ALL=C fgrep $TG14T5 $temp_file | wc -l)
	count14_6=$(LC_ALL=C fgrep $TG14T6 $temp_file | wc -l)
	count14_7=$(LC_ALL=C fgrep $TG14T7 $temp_file | wc -l)
	count14_8=$(LC_ALL=C fgrep $TG14T8 $temp_file | wc -l)
	count14_9=$(LC_ALL=C fgrep $TG14T9 $temp_file | wc -l)
	count14_10=$(LC_ALL=C fgrep $TG14T10 $temp_file | wc -l)
	
	top_geno_1_name=""
	top_geno_2_name=""
	#total
	sum_our_geno=$((count4_2+count4_3+count4_4+count4_5+count4_6+count4_7+count4_8+count4_9+count4_10+count5_2+count5_3+count5_4+count5_5+count5_6+count5_7+count5_8+count5_9+count5_10+count6_2+count6_3+count6_4+count6_5+count6_6+count6_7+count6_8+count6_9+count6_10+count7_2+count7_3+count7_4+count7_5+count7_6+count7_7+count7_8+count7_9+count7_10+count8_2+count8_3+count8_4+count8_5+count8_6+count8_7+count8_8+count8_9+count8_10+count9_2+count9_3+count9_4+count9_5+count9_6+count9_7+count9_8+count9_9+count9_10+count10_2+count10_3+count10_4+count10_5+count10_6+count10_7+count10_8+count10_9+count10_10+count11_2+count11_3+count11_4+count11_5+count11_6+count11_7+count11_8+count11_9+count11_10+count12_2+count12_3+count12_4+count12_5+count12_6+count12_7+count12_8+count12_9+count12_10+count13_2+count13_3+count13_4+count13_5+count13_6+count13_7+count13_8+count13_9+count13_10+count14_2+count14_3+count14_4+count14_5+count14_6+count14_7+count14_8+count14_9+count14_10))
	#need to check if sum_out_geno=0
	if [ "$sum_our_geno" -eq "0" ]; then
		echo "Warning: $out_base contains no reads in PolyTGT region.";
		top_geno_1_name="FAIL"
		top_geno_2_name="FAIL"
		top_geno_1_count=0
		top_geno_2_count=0
		#percents
		perc4_2=0
		perc4_3=0
		perc4_4=0
		perc4_5=0
		perc4_6=0
		perc4_7=0
		perc4_8=0
		perc4_9=0
		perc4_10=0
		
		perc5_2=0
		perc5_3=0
		perc5_4=0
		perc5_5=0
		perc5_6=0
		perc5_7=0
		perc5_8=0
		perc5_9=0
		perc5_10=0
		
		perc6_2=0
		perc6_3=0
		perc6_4=0
		perc6_5=0
		perc6_6=0
		perc6_7=0
		perc6_8=0
		perc6_9=0
		perc6_10=0
		
		perc7_2=0
		perc7_3=0
		perc7_4=0
		perc7_5=0
		perc7_6=0
		perc7_7=0
		perc7_8=0
		perc7_9=0
		perc7_10=0
		
		perc8_2=0
		perc8_3=0
		perc8_4=0
		perc8_5=0
		perc8_6=0
		perc8_7=0
		perc8_8=0
		perc8_9=0
		perc8_10=0
		
		perc9_2=0
		perc9_3=0
		perc9_4=0
		perc9_5=0
		perc9_6=0
		perc9_7=0
		perc9_8=0
		perc9_9=0
		perc9_10=0
		
		perc10_2=0
		perc10_3=0
		perc10_4=0
		perc10_5=0
		perc10_6=0
		perc10_7=0
		perc10_8=0
		perc10_9=0
		perc10_10=0
		
		perc11_2=0
		perc11_3=0
		perc11_4=0
		perc11_5=0
		perc11_6=0
		perc11_7=0
		perc11_8=0
		perc11_9=0
		perc11_10=0
		
		perc12_2=0
		perc12_3=0
		perc12_4=0
		perc12_5=0
		perc12_6=0
		perc12_7=0
		perc12_8=0
		perc12_9=0
		perc12_10=0
		
		perc13_2=0
		perc13_3=0
		perc13_4=0
		perc13_5=0
		perc13_6=0
		perc13_7=0
		perc13_8=0
		perc13_9=0
		perc13_10=0
		
		perc14_2=0
		perc14_3=0
		perc14_4=0
		perc14_5=0
		perc14_6=0
		perc14_7=0
		perc14_8=0
		perc14_9=0
		perc14_10=0

		percent_our_geno_vs_total_at_locus=0
		top_geno_1_percent=0
		top_geno_2_percent=0
		ratio_top_2=0
		homozygous_flag="NA"
		
	else
		#percents
		printf -v perc4_2 "%0.2f" $(bc -l <<< "($count4_2/$sum_our_geno) * 100")
		printf -v perc4_3 "%0.2f" $(bc -l <<< "($count4_3/$sum_our_geno) * 100")
		printf -v perc4_4 "%0.2f" $(bc -l <<< "($count4_4/$sum_our_geno) * 100")
		printf -v perc4_5 "%0.2f" $(bc -l <<< "($count4_5/$sum_our_geno) * 100")
		printf -v perc4_6 "%0.2f" $(bc -l <<< "($count4_6/$sum_our_geno) * 100")
		printf -v perc4_7 "%0.2f" $(bc -l <<< "($count4_7/$sum_our_geno) * 100")
		printf -v perc4_8 "%0.2f" $(bc -l <<< "($count4_8/$sum_our_geno) * 100")
		printf -v perc4_9 "%0.2f" $(bc -l <<< "($count4_9/$sum_our_geno) * 100")
		printf -v perc4_10 "%0.2f" $(bc -l <<< "($count4_10/$sum_our_geno) * 100")
		
		printf -v perc5_2 "%0.2f" $(bc -l <<< "($count5_2/$sum_our_geno) * 100")
		printf -v perc5_3 "%0.2f" $(bc -l <<< "($count5_3/$sum_our_geno) * 100")
		printf -v perc5_4 "%0.2f" $(bc -l <<< "($count5_4/$sum_our_geno) * 100")
		printf -v perc5_5 "%0.2f" $(bc -l <<< "($count5_5/$sum_our_geno) * 100")
		printf -v perc5_6 "%0.2f" $(bc -l <<< "($count5_6/$sum_our_geno) * 100")
		printf -v perc5_7 "%0.2f" $(bc -l <<< "($count5_7/$sum_our_geno) * 100")
		printf -v perc5_8 "%0.2f" $(bc -l <<< "($count5_8/$sum_our_geno) * 100")
		printf -v perc5_9 "%0.2f" $(bc -l <<< "($count5_9/$sum_our_geno) * 100")
		printf -v perc5_10 "%0.2f" $(bc -l <<< "($count5_10/$sum_our_geno) * 100")
		
		printf -v perc6_2 "%0.2f" $(bc -l <<< "($count6_2/$sum_our_geno) * 100")
		printf -v perc6_3 "%0.2f" $(bc -l <<< "($count6_3/$sum_our_geno) * 100")
		printf -v perc6_4 "%0.2f" $(bc -l <<< "($count6_4/$sum_our_geno) * 100")
		printf -v perc6_5 "%0.2f" $(bc -l <<< "($count6_5/$sum_our_geno) * 100")
		printf -v perc6_6 "%0.2f" $(bc -l <<< "($count6_6/$sum_our_geno) * 100")
		printf -v perc6_7 "%0.2f" $(bc -l <<< "($count6_7/$sum_our_geno) * 100")
		printf -v perc6_8 "%0.2f" $(bc -l <<< "($count6_8/$sum_our_geno) * 100")
		printf -v perc6_9 "%0.2f" $(bc -l <<< "($count6_9/$sum_our_geno) * 100")
		printf -v perc6_10 "%0.2f" $(bc -l <<< "($count6_10/$sum_our_geno) * 100")
		
		printf -v perc7_2 "%0.2f" $(bc -l <<< "($count7_2/$sum_our_geno) * 100")
		printf -v perc7_3 "%0.2f" $(bc -l <<< "($count7_3/$sum_our_geno) * 100")
		printf -v perc7_4 "%0.2f" $(bc -l <<< "($count7_4/$sum_our_geno) * 100")
		printf -v perc7_5 "%0.2f" $(bc -l <<< "($count7_5/$sum_our_geno) * 100")
		printf -v perc7_6 "%0.2f" $(bc -l <<< "($count7_6/$sum_our_geno) * 100")
		printf -v perc7_7 "%0.2f" $(bc -l <<< "($count7_7/$sum_our_geno) * 100")
		printf -v perc7_8 "%0.2f" $(bc -l <<< "($count7_8/$sum_our_geno) * 100")
		printf -v perc7_9 "%0.2f" $(bc -l <<< "($count7_9/$sum_our_geno) * 100")
		printf -v perc7_10 "%0.2f" $(bc -l <<< "($count7_10/$sum_our_geno) * 100")
		
		printf -v perc8_2 "%0.2f" $(bc -l <<< "($count8_2/$sum_our_geno) * 100")
		printf -v perc8_3 "%0.2f" $(bc -l <<< "($count8_3/$sum_our_geno) * 100")
		printf -v perc8_4 "%0.2f" $(bc -l <<< "($count8_4/$sum_our_geno) * 100")
		printf -v perc8_5 "%0.2f" $(bc -l <<< "($count8_5/$sum_our_geno) * 100")
		printf -v perc8_6 "%0.2f" $(bc -l <<< "($count8_6/$sum_our_geno) * 100")
		printf -v perc8_7 "%0.2f" $(bc -l <<< "($count8_7/$sum_our_geno) * 100")
		printf -v perc8_8 "%0.2f" $(bc -l <<< "($count8_8/$sum_our_geno) * 100")
		printf -v perc8_9 "%0.2f" $(bc -l <<< "($count8_9/$sum_our_geno) * 100")
		printf -v perc8_10 "%0.2f" $(bc -l <<< "($count8_10/$sum_our_geno) * 100")
		
		printf -v perc9_2 "%0.2f" $(bc -l <<< "($count9_2/$sum_our_geno) * 100")
		printf -v perc9_3 "%0.2f" $(bc -l <<< "($count9_3/$sum_our_geno) * 100")
		printf -v perc9_4 "%0.2f" $(bc -l <<< "($count9_4/$sum_our_geno) * 100")
		printf -v perc9_5 "%0.2f" $(bc -l <<< "($count9_5/$sum_our_geno) * 100")
		printf -v perc9_6 "%0.2f" $(bc -l <<< "($count9_6/$sum_our_geno) * 100")
		printf -v perc9_7 "%0.2f" $(bc -l <<< "($count9_7/$sum_our_geno) * 100")
		printf -v perc9_8 "%0.2f" $(bc -l <<< "($count9_8/$sum_our_geno) * 100")
		printf -v perc9_9 "%0.2f" $(bc -l <<< "($count9_9/$sum_our_geno) * 100")
		printf -v perc9_10 "%0.2f" $(bc -l <<< "($count9_10/$sum_our_geno) * 100")
		
		printf -v perc10_2 "%0.2f" $(bc -l <<< "($count10_2/$sum_our_geno) * 100")
		printf -v perc10_3 "%0.2f" $(bc -l <<< "($count10_3/$sum_our_geno) * 100")
		printf -v perc10_4 "%0.2f" $(bc -l <<< "($count10_4/$sum_our_geno) * 100")
		printf -v perc10_5 "%0.2f" $(bc -l <<< "($count10_5/$sum_our_geno) * 100")
		printf -v perc10_6 "%0.2f" $(bc -l <<< "($count10_6/$sum_our_geno) * 100")
		printf -v perc10_7 "%0.2f" $(bc -l <<< "($count10_7/$sum_our_geno) * 100")
		printf -v perc10_8 "%0.2f" $(bc -l <<< "($count10_8/$sum_our_geno) * 100")
		printf -v perc10_9 "%0.2f" $(bc -l <<< "($count10_9/$sum_our_geno) * 100")
		printf -v perc10_10 "%0.2f" $(bc -l <<< "($count10_10/$sum_our_geno) * 100")
		
		printf -v perc11_2 "%0.2f" $(bc -l <<< "($count11_2/$sum_our_geno) * 100")
		printf -v perc11_3 "%0.2f" $(bc -l <<< "($count11_3/$sum_our_geno) * 100")
		printf -v perc11_4 "%0.2f" $(bc -l <<< "($count11_4/$sum_our_geno) * 100")
		printf -v perc11_5 "%0.2f" $(bc -l <<< "($count11_5/$sum_our_geno) * 100")
		printf -v perc11_6 "%0.2f" $(bc -l <<< "($count11_6/$sum_our_geno) * 100")
		printf -v perc11_7 "%0.2f" $(bc -l <<< "($count11_7/$sum_our_geno) * 100")
		printf -v perc11_8 "%0.2f" $(bc -l <<< "($count11_8/$sum_our_geno) * 100")
		printf -v perc11_9 "%0.2f" $(bc -l <<< "($count11_9/$sum_our_geno) * 100")
		printf -v perc11_10 "%0.2f" $(bc -l <<< "($count11_10/$sum_our_geno) * 100")
		
		printf -v perc12_2 "%0.2f" $(bc -l <<< "($count12_2/$sum_our_geno) * 100")
		printf -v perc12_3 "%0.2f" $(bc -l <<< "($count12_3/$sum_our_geno) * 100")
		printf -v perc12_4 "%0.2f" $(bc -l <<< "($count12_4/$sum_our_geno) * 100")
		printf -v perc12_5 "%0.2f" $(bc -l <<< "($count12_5/$sum_our_geno) * 100")
		printf -v perc12_6 "%0.2f" $(bc -l <<< "($count12_6/$sum_our_geno) * 100")
		printf -v perc12_7 "%0.2f" $(bc -l <<< "($count12_7/$sum_our_geno) * 100")
		printf -v perc12_8 "%0.2f" $(bc -l <<< "($count12_8/$sum_our_geno) * 100")
		printf -v perc12_9 "%0.2f" $(bc -l <<< "($count12_9/$sum_our_geno) * 100")
		printf -v perc12_10 "%0.2f" $(bc -l <<< "($count12_10/$sum_our_geno) * 100")
		
		printf -v perc13_2 "%0.2f" $(bc -l <<< "($count13_2/$sum_our_geno) * 100")
		printf -v perc13_3 "%0.2f" $(bc -l <<< "($count13_3/$sum_our_geno) * 100")
		printf -v perc13_4 "%0.2f" $(bc -l <<< "($count13_4/$sum_our_geno) * 100")
		printf -v perc13_5 "%0.2f" $(bc -l <<< "($count13_5/$sum_our_geno) * 100")
		printf -v perc13_6 "%0.2f" $(bc -l <<< "($count13_6/$sum_our_geno) * 100")
		printf -v perc13_7 "%0.2f" $(bc -l <<< "($count13_7/$sum_our_geno) * 100")
		printf -v perc13_8 "%0.2f" $(bc -l <<< "($count13_8/$sum_our_geno) * 100")
		printf -v perc13_9 "%0.2f" $(bc -l <<< "($count13_9/$sum_our_geno) * 100")
		printf -v perc13_10 "%0.2f" $(bc -l <<< "($count13_10/$sum_our_geno) * 100")
		
		printf -v perc14_2 "%0.2f" $(bc -l <<< "($count14_2/$sum_our_geno) * 100")
		printf -v perc14_3 "%0.2f" $(bc -l <<< "($count14_3/$sum_our_geno) * 100")
		printf -v perc14_4 "%0.2f" $(bc -l <<< "($count14_4/$sum_our_geno) * 100")
		printf -v perc14_5 "%0.2f" $(bc -l <<< "($count14_5/$sum_our_geno) * 100")
		printf -v perc14_6 "%0.2f" $(bc -l <<< "($count14_6/$sum_our_geno) * 100")
		printf -v perc14_7 "%0.2f" $(bc -l <<< "($count14_7/$sum_our_geno) * 100")
		printf -v perc14_8 "%0.2f" $(bc -l <<< "($count14_8/$sum_our_geno) * 100")
		printf -v perc14_9 "%0.2f" $(bc -l <<< "($count14_9/$sum_our_geno) * 100")
		printf -v perc14_10 "%0.2f" $(bc -l <<< "($count14_10/$sum_our_geno) * 100")
		
		temp_file2=$(mktemp)
		trap "rm -f $temp_file2" 0 2 3 15
		printf "%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n%d	%s\n" $count4_2 "(TG)4(T)2" $count4_3 "(TG)4(T)3" $count4_4 "(TG)4(T)4" $count4_5 "(TG)4(T)5" $count4_6 "(TG)4(T)6" $count4_7 "(TG)4(T)7" $count4_8 "(TG)4(T)8" $count4_9 "(TG)4(T)9" $count4_10 "(TG)4(T)10" $count5_2 "(TG)5(T)2" $count5_3 "(TG)5(T)3" $count5_4 "(TG)5(T)4" $count5_5 "(TG)5(T)5" $count5_6 "(TG)5(T)6" $count5_7 "(TG)5(T)7" $count5_8 "(TG)5(T)8" $count5_9 "(TG)5(T)9" $count5_10 "(TG)5(T)10" $count6_2 "(TG)6(T)2" $count6_3 "(TG)6(T)3" $count6_4 "(TG)6(T)4" $count6_5 "(TG)6(T)5" $count6_6 "(TG)6(T)6" $count6_7 "(TG)6(T)7" $count6_8 "(TG)6(T)8" $count6_9 "(TG)6(T)9" $count6_10 "(TG)6(T)10" $count7_2 "(TG)7(T)2" $count7_3 "(TG)7(T)3" $count7_4 "(TG)7(T)4" $count7_5 "(TG)7(T)5" $count7_6 "(TG)7(T)6" $count7_7 "(TG)7(T)7" $count7_8 "(TG)7(T)8" $count7_9 "(TG)7(T)9" $count7_10 "(TG)7(T)10" $count8_2 "(TG)8(T)2" $count8_3 "(TG)8(T)3" $count8_4 "(TG)8(T)4" $count8_5 "(TG)8(T)5" $count8_6 "(TG)8(T)6" $count8_7 "(TG)8(T)7" $count8_8 "(TG)8(T)8" $count8_9 "(TG)8(T)9" $count8_10 "(TG)8(T)10" $count9_2 "(TG)9(T)2" $count9_3 "(TG)9(T)3" $count9_4 "(TG)9(T)4" $count9_5 "(TG)9(T)5" $count9_6 "(TG)9(T)6" $count9_7 "(TG)9(T)7" $count9_8 "(TG)9(T)8" $count9_9 "(TG)9(T)9" $count9_10 "(TG)9(T)10" $count10_2 "(TG)10(T)2" $count10_3 "(TG)10(T)3" $count10_4 "(TG)10(T)4" $count10_5 "(TG)10(T)5" $count10_6 "(TG)10(T)6" $count10_7 "(TG)10(T)7" $count10_8 "(TG)10(T)8" $count10_9 "(TG)10(T)9" $count10_10 "(TG)10(T)10" $count11_2 "(TG)11(T)2" $count11_3 "(TG)11(T)3" $count11_4 "(TG)11(T)4" $count11_5 "(TG)11(T)5" $count11_6 "(TG)11(T)6" $count11_7 "(TG)11(T)7" $count11_8 "(TG)11(T)8" $count11_9 "(TG)11(T)9" $count11_10 "(TG)11(T)10" $count12_2 "(TG)12(T)2" $count12_3 "(TG)12(T)3" $count12_4 "(TG)12(T)4" $count12_5 "(TG)12(T)5" $count12_6 "(TG)12(T)6" $count12_7 "(TG)12(T)7" $count12_8 "(TG)12(T)8" $count12_9 "(TG)12(T)9" $count12_10 "(TG)12(T)10" $count13_2 "(TG)13(T)2" $count13_3 "(TG)13(T)3" $count13_4 "(TG)13(T)4" $count13_5 "(TG)13(T)5" $count13_6 "(TG)13(T)6" $count13_7 "(TG)13(T)7" $count13_8 "(TG)13(T)8" $count13_9 "(TG)13(T)9" $count13_10 "(TG)13(T)10" $count14_2 "(TG)14(T)2" $count14_3 "(TG)14(T)3" $count14_4 "(TG)14(T)4" $count14_5 "(TG)14(T)5" $count14_6 "(TG)14(T)6" $count14_7 "(TG)14(T)7" $count14_8 "(TG)14(T)8" $count14_9 "(TG)14(T)9" $count14_10 "(TG)14(T)10" > $temp_file2
		
		max_array=( $( sort -nrk1,1 $temp_file2 | head -2 | cut -d '	' -f1 --output-delimiter=" " ) )
		top_geno_1_count=${max_array[0]}
		top_geno_2_count=${max_array[1]}
		
		max_array=( $( sort -nrk1,1 $temp_file2 | head -2 | cut -d '	' -f2 --output-delimiter=" " ) )
		top_geno_1_name=${max_array[0]}
		top_geno_2_name=${max_array[1]}
		
		printf -v percent_our_geno_vs_total_at_locus "%0.2f" $(bc -l <<< "($sum_our_geno/$total_reads) * 100")
		
		printf -v top_geno_1_percent "%0.2f" $(bc -l <<< "($top_geno_1_count/$sum_our_geno) * 100")
		printf -v top_geno_2_percent "%0.2f" $(bc -l <<< "($top_geno_2_count/$sum_our_geno) * 100")
		
		#ratio_top_2=$(bc <<< "scale=4; ($top_geno_2_percent/$top_geno_1_percent)")
		printf -v ratio_top_2 "%0.3f" $(bc -l <<< "($top_geno_2_percent/$top_geno_1_percent)")
		
		HET_CUTOFF=0.302
		
		homozygous_flag="Het"
		if (( $(echo "$ratio_top_2 < $HET_CUTOFF" |bc -l) )); then
			homozygous_flag="Homo"
		fi
	fi
	#now outputs
	#polyTGT_counts.txt
	printf "%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s\n" $out_base $total_reads $count4_2 $count4_3 $count4_4 $count4_5 $count4_6 $count4_7 $count4_8 $count4_9 $count4_10 $count5_2 $count5_3 $count5_4 $count5_5 $count5_6 $count5_7 $count5_8 $count5_9 $count5_10 $count6_2 $count6_3 $count6_4 $count6_5 $count6_6 $count6_7 $count6_8 $count6_9 $count6_10 $count7_2 $count7_3 $count7_4 $count7_5 $count7_6 $count7_7 $count7_8 $count7_9 $count7_10 $count8_2 $count8_3 $count8_4 $count8_5 $count8_6 $count8_7 $count8_8 $count8_9 $count8_10 $count9_2 $count9_3 $count9_4 $count9_5 $count9_6 $count9_7 $count9_8 $count9_9 $count9_10 $count10_2 $count10_3 $count10_4 $count10_5 $count10_6 $count10_7 $count10_8 $count10_9 $count10_10 $count11_2 $count11_3 $count11_4 $count11_5 $count11_6 $count11_7 $count11_8 $count11_9 $count11_10 $count12_2 $count12_3 $count12_4 $count12_5 $count12_6 $count12_7 $count12_8 $count12_9 $count12_10 $count13_2 $count13_3 $count13_4 $count13_5 $count13_6 $count13_7 $count13_8 $count13_9 $count13_10 $count14_2 $count14_3 $count14_4 $count14_5 $count14_6 $count14_7 $count14_8 $count14_9 $count14_10 >> $out_dir/polyTGT_counts.txt
	
	#polyTGT_percents.txt
	#sample	total_reads_at_locus	sum_our_geno	percent_our_geno_vs_total_at_locus	(TG)4(T)2_percent	(TG)4(T)3_percent	(TG)4(T)4_percent	(TG)4(T)5_percent	(TG)4(T)6_percent	(TG)4(T)7_percent	(TG)4(T)8_percent	(TG)4(T)9_percent	(TG)4(T)10_percent	(TG)5(T)2_percent	(TG)5(T)3_percent	(TG)5(T)4_percent	(TG)5(T)5_percent	(TG)5(T)6_percent	(TG)5(T)7_percent	(TG)5(T)8_percent	(TG)5(T)9_percent	(TG)5(T)10_percent	(TG)6(T)2_percent	(TG)6(T)3_percent	(TG)6(T)4_percent	(TG)6(T)5_percent	(TG)6(T)6_percent	(TG)6(T)7_percent	(TG)6(T)8_percent	(TG)6(T)9_percent	(TG)6(T)10_percent	(TG)7(T)2_percent	(TG)7(T)3_percent	(TG)7(T)4_percent	(TG)7(T)5_percent	(TG)7(T)6_percent	(TG)7(T)7_percent	(TG)7(T)8_percent	(TG)7(T)9_percent	(TG)7(T)10_percent	(TG)8(T)2_percent	(TG)8(T)3_percent	(TG)8(T)4_percent	(TG)8(T)5_percent	(TG)8(T)6_percent	(TG)8(T)7_percent	(TG)8(T)8_percent	(TG)8(T)9_percent	(TG)8(T)10_percent	(TG)9(T)2_percent	(TG)9(T)3_percent	(TG)9(T)4_percent	(TG)9(T)5_percent	(TG)9(T)6_percent	(TG)9(T)7_percent	(TG)9(T)8_percent	(TG)9(T)9_percent	(TG)9(T)10_percent	(TG)10(T)2_percent	(TG)10(T)3_percent	(TG)10(T)4_percent	(TG)10(T)5_percent	(TG)10(T)6_percent	(TG)10(T)7_percent	(TG)10(T)8_percent	(TG)10(T)9_percent	(TG)10(T)10_percent	(TG)11(T)2_percent	(TG)11(T)3_percent	(TG)11(T)4_percent	(TG)11(T)5_percent	(TG)11(T)6_percent	(TG)11(T)7_percent	(TG)11(T)8_percent	(TG)11(T)9_percent	(TG)11(T)10_percent	(TG)12(T)2_percent	(TG)12(T)3_percent	(TG)12(T)4_percent	(TG)12(T)5_percent	(TG)12(T)6_percent	(TG)12(T)7_percent	(TG)12(T)8_percent	(TG)12(T)9_percent	(TG)12(T)10_percent	(TG)13(T)2_percent	(TG)13(T)3_percent	(TG)13(T)4_percent	(TG)13(T)5_percent	(TG)13(T)6_percent	(TG)13(T)7_percent	(TG)13(T)8_percent	(TG)13(T)9_percent	(TG)13(T)10_percent	(TG)14(T)2_percent	(TG)14(T)3_percent	(TG)14(T)4_percent	(TG)14(T)5_percent	(TG)14(T)6_percent	(TG)14(T)7_percent	(TG)14(T)8_percent	(TG)14(T)9_percent	(TG)14(T)10_percent
	printf "%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s\n" $out_base $total_reads $sum_our_geno	$percent_our_geno_vs_total_at_locus	$perc4_2 $perc4_3 $perc4_4 $perc4_5 $perc4_6 $perc4_7 $perc4_8 $perc4_9 $perc4_10 $perc5_2 $perc5_3 $perc5_4 $perc5_5 $perc5_6 $perc5_7 $perc5_8 $perc5_9 $perc5_10 $perc6_2 $perc6_3 $perc6_4 $perc6_5 $perc6_6 $perc6_7 $perc6_8 $perc6_9 $perc6_10 $perc7_2 $perc7_3 $perc7_4 $perc7_5 $perc7_6 $perc7_7 $perc7_8 $perc7_9 $perc7_10 $perc8_2 $perc8_3 $perc8_4 $perc8_5 $perc8_6 $perc8_7 $perc8_8 $perc8_9 $perc8_10 $perc9_2 $perc9_3 $perc9_4 $perc9_5 $perc9_6 $perc9_7 $perc9_8 $perc9_9 $perc9_10 $perc10_2 $perc10_3 $perc10_4 $perc10_5 $perc10_6 $perc10_7 $perc10_8 $perc10_9 $perc10_10 $perc11_2 $perc11_3 $perc11_4 $perc11_5 $perc11_6 $perc11_7 $perc11_8 $perc11_9 $perc11_10 $perc12_2 $perc12_3 $perc12_4 $perc12_5 $perc12_6 $perc12_7 $perc12_8 $perc12_9 $perc12_10 $perc13_2 $perc13_3 $perc13_4 $perc13_5 $perc13_6 $perc13_7 $perc13_8 $perc13_9 $perc13_10 $perc14_2 $perc14_3 $perc14_4 $perc14_5 $perc14_6 $perc14_7 $perc14_8 $perc14_9 $perc14_10 >> $out_dir/polyTGT_percents.txt
	
	
	#polyTGT_calls.txt
	#sample	total_reads_at_locus	sum_our_geno	percent_our_geno_vs_total_at_locus	top_geno_1_name	top_geno_1_count	top_geno_1_percent	top_geno_2_name	top_geno_2_count	top_geno_2_percent	ratio_top_2	zygosity\n"
	printf "%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	%s\n" $out_base $total_reads $sum_our_geno $percent_our_geno_vs_total_at_locus $top_geno_1_name $top_geno_1_count $top_geno_1_percent $top_geno_2_name $top_geno_2_count $top_geno_2_percent $ratio_top_2 $homozygous_flag >> $out_dir/polyTGT_calls.txt
done