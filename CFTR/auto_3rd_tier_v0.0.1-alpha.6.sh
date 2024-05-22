#!/usr/bin/env bash
# Be sure to include above #! as the script will be called directly
#
# Author: kkhalsa (kkhalsa@archerdx.com)
# Bash hook example
# Example UI Args: -j ${JOB_ID} -d ${JOB_DIR} -o ${HOOK_OUTPUT_DIR} ${SAMPLE_NAMES_SPACED}

####auto_3rd_tier
####Author: Bob Sicko robert.sicko@health.ny.gov
####
####
####Change Log:
####		v0.0.1-alpha.1 - testing
####		v0.0.1-alpha.2 - comment out CNV job creation. The rest is working, but CNV job requires REST API job submission. Will upgrade to v7 analysis and get working there.
####                    - for now, alpha.2 will be used to call old samples for targeted then seq-SV for comparison to historic results. 
####                        this is being done to make sure gumby read filtering didn't cause us to miss any other variants.
####		v0.0.1-alpha.3 - attempt to get CNV job creation working for v7 server.
####                    - I noticed a statement in the RESTAPI documentation that samples with 'normal' in their name will be run as normals, otherwise they will be run as tumor
####                    - I'll try adding 'normal' to all samples that don't need CNV calls and see if it works 
####		v0.0.1-alpha.4 - added logic to look for PT samples
####                    - also modified logic to kick certain fails to seq-SV only (VHIRT, 1+ var, PT, SHC)
####    v0.0.1-alpha.6 - exploring writing a csv file with 2nd tier report info in this script
####                          - attempt to cp this csv to the 3rd tier job for additional writing after 3rd tier job completes
####                          - csv format per Chris 1/24/24:
####                              sample_id, num_vars, UFT, GSP2, 2nd_tier_var_annotation, 3rd_tier_var_annotation
####To Do:


set -eu

usage()
{
   echo "auto_3rd_tier Usage: $0 -o hook_output_dir -d job_dir -j job_id" 1>&2
   exit 1
}

while getopts ":o:d:j:" opt; do
    case "${opt}" in
        o)
            hook_output_dir=${OPTARG}
            ;;
		d)
			job_dir=${OPTARG}
			;;
		j)
			job_id=${OPTARG}
			;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

set +u

if [ -z "${hook_output_dir}" ]; then
   echo "Error: -o hook_output_dir argument is required." >> /dev/stderr
   exit 1
fi
if [ -z "${job_dir}" ]; then
   echo "Error: -d job_dir argument is required." >> /dev/stderr
   exit 1
fi
if [ -z "${job_id}" ]; then
   echo "Error: -j job_id argument is required." >> /dev/stderr
   exit 1
fi

set -u


#############################################################
##2023-122-1021_S2_L001_R1_001.r_and_d_results.txt###########
##UNIQUE_FRAGMENT_TOTAL	83807
##UNIQUE_FRAGMENT_ALIGNED	83798
##UNIQUE_FRAGMENT_FILTERED	83798
##UNIQUE_FRAGMENT_FILTERED_ON_TARGET	81832
##UNIQUE_FRAGMENT_FILTERED_ON_TARGET_PERCENT	97.65
##UNIQUE_FRAGMENT_FILTERED_OFF_TARGET	1966
##UNIQUE_FRAGMENT_FILTERED_OFF_TARGET_PERCENT	2.35
##RAW_FRAGMENT_TOTAL	203851
##RAW_FRAGMENT_ALIGNED	203842
##RAW_FRAGMENT_FILTERED	203842
##RAW_FRAGMENT_FILTERED_ON_TARGET	201128
##RAW_FRAGMENT_FILTERED_ON_TARGET_PERCENT	98.67
##RAW_FRAGMENT_FILTERED_OFF_TARGET	2714
##RAW_FRAGMENT_FILTERED_OFF_TARGET_PERCENT	1.33
##JUNK_PERCENT	0.03
##AVERAGE_UNIQUE_RNA_START_SITES_PER_CONTROL_GSP2	0.00
##AVERAGE_UNIQUE_DNA_START_SITES_PER_GSP2	146.28
#############################################################
VERSION="v0.0.1-alpha6"
WATCHED_FOLDER_mail="/var/www/analysis/watched/nys_nbs/mail"
WATCHED_FOLDER_3RD="/var/www/analysis/watched/robert.sicko@health.ny.gov/CFTR_3rd"
WATCHED_FOLDER_3RD_CNV="/var/www/analysis/watched/robert.sicko@health.ny.gov/CFTR_CNV"
VHIRT="/var/www/analysis/watched/nys_nbs/vhirt.csv"
LOG="${hook_output_dir}/${job_id}_auto_3rd_tier_${VERSION}.log"
#touch "$LOG"
exec >> "$LOG" 2>&1

function log_step () {
  local time_stamp
  time_stamp="$(date)"
  local step_name="$1"
  local step_status="$2"
  local msg="$3"
  echo "[$time_stamp]"$'\t'"$step_name"$'\t'"[$step_status]"$'\t'"$msg"
  if [[ "$step_status" = "ERROR" ]] || [[ "$step_status" = "WARNING" ]]; then
    tail -1 "$LOG" > "${WATCHED_FOLDER_mail}/warning_or_error_${time_stamp}.txt"
  fi
}

project_name="${job_id}_3rd-tier_seq_SV"
project_name_cnv="${job_id}_3rd-tier_CNV"

#CNV_SHEET="${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/cnv_sample_sheet.tsv"



#2004-176-1685-K7VJB-Archer-2022-133_S33_L001_R1_001.vision.vcf
#2004-176-1685-K7VJB-Archer-2022-133_S33_L001_R1_001.fastq.gz

log_step "globals" 'DEBUG' "before mkdir ${WATCHED_FOLDER_3RD}/${project_name}"
mkdir -p "${WATCHED_FOLDER_3RD}/${project_name}"
chmod g+w "${WATCHED_FOLDER_3RD}/${project_name}"

mkdir -p "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}"
chmod g+w "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}"
#touch "$CNV_SHEET"
#chmod g+w "${CNV_SHEET}"

#printf "SequenceFileName	ExperimentalCondition	Group	Replicate\n" > "${CNV_SHEET}"
##touch "${hook_output_dir}/${job_id}_auto_3rd_tier_${VERSION}.log"




function link_fastq(){
  fastq_wo_path=${fastq##*/}
  fastq2_wo_path=${fastq2##*/}
  
  ######################################
  #SEQ-SV
  ######################################
  if [[ "$cnv_type" == "tumor" ]] || [[ "$cnv_type" == "ntc" ]] ; then
  #samples that require 3rd tier are marked 'tumor' to generate CNV calls. but 'normal' are still copied to CNV 3rd tier for baseline
  #also need to copy ntc to seq-sv
    log_step "link_fastq" 'DEBUG' "in 'tumor' if - line 145. fastq_wo_path ${fastq_wo_path}."
    cp -pr "${fastq}" "${WATCHED_FOLDER_3RD}/${project_name}/${fastq_wo_path}"
    #chmod g+w "${WATCHED_FOLDER_3RD}/${project_name}/${fastq_wo_path}"
    cp -pr "${fastq2}" "${WATCHED_FOLDER_3RD}/${project_name}/${fastq2_wo_path}"
    #chmod g+w "${WATCHED_FOLDER_3RD}/${project_name}/${fastq2_wo_path}"
  fi
  
  ######################################
  #CNV
  ######################################
  #now copy all to CNV project, but label the samples that don't need CNV analysis "normal"
  if [[ "$cnv_type" == "tumor" ]] ; then  # don't add "normal" to fastq 
    log_step "link_fastq" 'DEBUG' "line 160. fastq_wo_path ${fastq_wo_path}."
    cp -pr "${fastq}" "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/${fastq_wo_path}"
    #chmod g+w "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/${fastq_wo_path}"
    cp -pr "${fastq2}" "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/${fastq2_wo_path}"
    #chmod g+w "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/${fastq2_wo_path}"
  elif [[ "$cnv_type" == "ntc" ]] ; then
    log_step "link_fastq" 'DEBUG' "found an NTC - fastq_wo_path ${fastq_wo_path}."
    #return 1 # don't copy ntc at all
  else # we have to add "normal" to the fastqs
    log_step "link_fastq" 'DEBUG' "line 160. fastq_wo_path ${fastq_wo_path}."
    cp -pr "${fastq}" "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/normal${fastq_wo_path}"
    #chmod g+w "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/normal${fastq_wo_path}"
    cp -pr "${fastq2}" "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/normal${fastq2_wo_path}"
    #chmod g+w "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}/normal${fastq2_wo_path}"
  fi
}

function main (){
  log_step "main" 'DEBUG' "entered main"
  #list=$(ls -la /mnt)
  #log_step "main" 'DEBUG' "list is ${list}"
  second_tier_sample_count=0
  third_tier_sample_count=0
  third_tier_control_count=0
  normal_samples=0
  shc_count=0
  failed_qc=0
  pt_count=0
  for vision_vcf in "${job_dir}"/VCFs/*.vision.vcf.gz
  do
    second_tier_sample_count=$((second_tier_sample_count+1))
    #prefix=$(echo ${R1} | sed "s/_L001_R1_\001\.preprocessed.bam//") 
    ###################################
    #default to not needing 3rd tier
    cnv_type="normal"
    vcf_wo_path=${vision_vcf##*/}
    base=$(echo "${vcf_wo_path}" | sed "s/.vision.vcf.gz//")
    fastq="${job_dir}/${base}.fastq.gz"
    fastq2=$(echo "${fastq}" | sed "s/R1/R2/")
    r_and_d_results="${job_dir}/${base}.r_and_d_results.txt"
    log_step "main" 'DEBUG' "r_and_d_results is ${r_and_d_results}."
    log_step "main" 'DEBUG' "base is ${base}."
    log_step "main" 'DEBUG' "vcf_wo_path is ${vcf_wo_path}."
    who=$(whoami)
    log_step "main" 'DEBUG' "whoami is ${who}."
    uft=$(awk 'NR == 1 {print int($2)}' "${r_and_d_results}")
    gsp=$(awk 'NR == 17 {print int($2)}' "${r_and_d_results}")
    
    vision_var_count=$(bcftools view --no-header -i'AF>0.200' "$vision_vcf" | wc -l)
    log_step "before ifs" 'DEBUG' "line 175. uft ${uft}."
    log_step "before ifs" 'DEBUG' "line 176. gsp ${gsp}."
    log_step "before ifs" 'DEBUG' "line 177. r_and_d_results ${r_and_d_results}."
    log_step "before ifs" 'DEBUG' "line 178. vision_var_count ${vision_var_count}."
    
    ####################################
    #ntc 
    if [[ "$vision_vcf" =~ "NTC" ]] ; then
        cnv_type="ntc"
        link_fastq #don't copy ntc to CNV, but need seq-SV
        log_step "main" 'DEBUG' "vcf ${vision_vcf} is the NTC."

    ####################################
    #control - if we find ACFC in sample name
    elif [[ "$vision_vcf" =~ "ACFC" ]] ; then
      #check fail first
      if [ "$uft" -lt 20000 ] || [ "$gsp" -lt 30 ] ; then
        failed_qc=$((failed_qc+1))
        cnv_type="ntc"
        link_fastq #since gets seq-SV but not CNV, just using this flag here
      else
        cnv_type="tumor"
        link_fastq
        third_tier_control_count=$((third_tier_control_count+1))
        log_step "main" 'DEBUG' "vcf ${vision_vcf} is a control."
      fi

    ####################################
    #if we find SHC in sample name
    elif [[ "$vision_vcf" =~ "SHC" ]] ; then
      #check fail first
      if [ "$uft" -lt 20000 ] || [ "$gsp" -lt 30 ] ; then
        failed_qc=$((failed_qc+1))
        cnv_type="ntc"
        link_fastq #since gets seq-SV but not CNV, just using this flag here
      else
        cnv_type="tumor"
        link_fastq
        shc_count=$((shc_count+1))
        log_step "main" 'DEBUG' "vcf ${vision_vcf} is a SHC."
      fi

    ####################################
    #if we find PT in sample name
    elif [[ "$vision_vcf" =~ "PT" || "$vision_vcf" =~ "CDC" ]] ; then
      #check fail first
      if [ "$uft" -lt 20000 ] || [ "$gsp" -lt 30 ] ; then
        failed_qc=$((failed_qc+1))
        cnv_type="ntc"
        link_fastq #since gets seq-SV but not CNV, just using this flag here
      else
        cnv_type="tumor"
        link_fastq
        pt_count=$((pt_count+1))
        log_step "main" 'DEBUG' "vcf ${vision_vcf} is a PT."
      fi

    ####################################
    #if we have a targeted variant
    elif [ "$vision_var_count" -gt 0 ] ; then
    ####################################
      #sample failed
      if [ "$uft" -lt 20000 ] || [ "$gsp" -lt 30 ] ; then
        failed_qc=$((failed_qc+1))
        cnv_type="ntc"
        link_fastq #since gets seq-SV but not CNV, just using this flag here
      else
        cnv_type="tumor"
        link_fastq
        third_tier_sample_count=$((third_tier_sample_count+1))
        log_step "main" 'DEBUG' "vcf ${vision_vcf} has one or more targeted vars."
      fi

    #####################################
    #last thing to check, VHIRT
    else
      accession=""
    #lets get accession number
      ###if sample is YYYY-DDD-NNNN
      if [[ "$vcf_wo_path" =~ ^(20[0-9]+)(-)([0-9]+)(-)([0-9]+) ]] ; then
        accession=$(echo "${vcf_wo_path:0:13}" | sed -e "s:-::g")
        log_step "main" 'DEBUG' "YYYY-DDD-NNNN if, accession ${accession} and vcf ${vision_vcf}."
      ###if sample is YYDDDNNNN
      elif [[ "$vcf_wo_path" =~ ^([0-9]{9}) ]] ; then
        accession="20"$(echo "${vcf_wo_path:0:9}")
        log_step "main" 'DEBUG' "YYDDDNNNN if, accession ${accession} and vcf ${vision_vcf}."
      ###if sample is YYYYDDDNNNN
      elif [[ "$vcf_wo_path" =~ ^([0-9]{13}) ]] ; then
        accession=$(echo "${vcf_wo_path:0:13}")
        log_step "main" 'DEBUG' "YYYYDDDNNNN if, accession ${accession} and vcf ${vision_vcf}."
      else
        accession="other"
        log_step "main" 'WARNING' "Possible issue. couldn't find accession number for ${vision_vcf}.
        The accession value is ${accession}"
      fi
      #make sure IRTELV or indet that was checked and needs 3rd
      vhirt=$(cat ${VHIRT} | awk -F',' -v accession="$accession" '$2 == accession && ($3 == "IRTELV" || $3 == "indet_yes" || $3 == "INDET_YES")' | wc -l)
      if [ "$vhirt" -gt 0 ] ; then
        #check if fail first
        if [ "$uft" -lt 20000 ] || [ "$gsp" -lt 30 ] ; then
          failed_qc=$((failed_qc+1))
          cnv_type="ntc"
          link_fastq #since gets seq-SV but not CNV, just using this flag here
        else
          log_step "main" 'DEBUG' "found a vhirt accession ${accession},  vcf ${vision_vcf}, vhirt ${vhirt}, cnv_type ${cnv_type}."
          cnv_type="tumor"
          link_fastq
          third_tier_sample_count=$((third_tier_sample_count+1))
        fi
      else #still copy to CNV project as 'normal'
        #first check if fail. if so don't link and just count as a fail
        if [ "$uft" -lt 20000 ] || [ "$gsp" -lt 30 ] ; then
          failed_qc=$((failed_qc+1))
        else
          log_step "main" 'DEBUG' "not found in vhirt, accession ${accession},  vcf ${vision_vcf}, vhirt ${vhirt}, cnv_type ${cnv_type}."
          link_fastq
          normal_samples=$((normal_samples+1))
        fi
      fi
    fi
  done
  touch "${WATCHED_FOLDER_3RD}/${project_name}.completed"
  touch "${WATCHED_FOLDER_3RD_CNV}/${project_name_cnv}.completed"
  log_step "wrap_up" 'SUMMARY' "Total samples in 2nd tier job: ${second_tier_sample_count}"
  log_step "wrap_up" 'SUMMARY' "Total samples that failed 2nd tier QC: ${failed_qc}"
  log_step "wrap_up" 'SUMMARY' "Total samples sent to 3rd tier (seq-SV): ${third_tier_sample_count}"
  log_step "wrap_up" 'SUMMARY' "Total samples used as CNV 'normal': ${normal_samples}"
  log_step "wrap_up" 'SUMMARY' "Total controls sent to 3rd tier: ${third_tier_control_count}"
  log_step "wrap_up" 'SUMMARY' "Total SHC sent to 3rd tier: ${shc_count}"
  log_step "wrap_up" 'SUMMARY' "Total PT sent to 3rd tier: ${pt_count}"

}

main "$@"