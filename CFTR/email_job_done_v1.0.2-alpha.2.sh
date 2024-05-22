#!/usr/bin/env bash
# Be sure to include above #! as the script will be called directly
#
# Author: kkhalsa (kkhalsa@archerdx.com)
# Bash hook example
# Example UI Args: -j ${JOB_ID} -d ${JOB_DIR} -o ${HOOK_OUTPUT_DIR} ${SAMPLE_NAMES_SPACED}

####email_job_done_v1.0.0-alpha.1.sh
####Author: Bob Sicko robert.sicko@health.ny.gov
####
####
####This script sends an email to the Archer CF Analysis group alerting them that a job has finished.
####Change Log:
####		v1.0.0-alpha.1 - Initial release.
####		v1.0.1-alpha.1 - Added Matt.
####		v1.0.2-alpha.1 - Added Allison.
####		v1.0.2-alpha.2 - version for v7 server. Save the mail to a file and mailsender service sends that email on host.

set -eu

usage()
{
   echo "Usage: $0 -o hook_output_dir -j job_id" 1>&2
   exit 1
}

while getopts ":o:j:" opt; do
    case "${opt}" in
        o)
            hook_output_dir=${OPTARG}
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


if [ -z "${job_id}" ]; then
   echo "Error: -j job_id argument is required." >> /dev/stderr
   exit 1
fi

set -u

WATCHED_FOLDER_mail="/var/www/analysis/watched/nys_nbs/mail"
EMAIL_LIST="robert.sicko@health.ny.gov"
#Erin.Hughes@health.ny.gov lea.krein@health.ny.gov lisa.diantonio@health.ny.gov matthew.nichols@health.ny.gov Allison.Brown-Madole@health.ny.gov "
echo "${EMAIL_LIST}" > "${WATCHED_FOLDER_mail}/analysis_done_${job_id}.txt"
echo "Analysis complete for job ${job_id}" >> "${WATCHED_FOLDER_mail}/analysis_done_${job_id}.txt"
