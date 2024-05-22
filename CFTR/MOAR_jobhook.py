#!/usr/bin/env python
# Be sure to include above #! as the script will be called directly
# -*- coding: utf-8 -*-
# ╔╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╗
# ╠╬╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╬╣
# ╠╣ __  __   ___     _     ____                                                                                   ╠╣
# ╠╣|  \/  | / _ \   / \   |  _ \                                                                                  ╠╣
# ╠╣| |\/| || | | | / _ \  | |_) |                                                                                 ╠╣
# ╠╣| |  | || |_| |/ ___ \ |  _ <                                                                                  ╠╣
# ╠╣|_|  |_| \___//_/   \_\|_| \_\                                                                                 ╠╣
# ╠╣                                                                                                               ╠╣
# ╠╣ __  __         _    _                           __      _     _  _   ____                            _        ╠╣
# ╠╣|  \/  |  ___  | |_ | |__    ___  _ __    ___   / _|    / \   | || | |  _ \  ___  _ __    ___   _ __ | |_  ___ ╠╣
# ╠╣| |\/| | / _ \ | __|| '_ \  / _ \| '__|  / _ \ | |_    / _ \  | || | | |_) |/ _ \| '_ \  / _ \ | '__|| __|/ __|╠╣
# ╠╣| |  | || (_) || |_ | | | ||  __/| |    | (_) ||  _|  / ___ \ | || | |  _ <|  __/| |_) || (_) || |   | |_ \__ \╠╣
# ╠╣|_|  |_| \___/  \__||_| |_| \___||_|     \___/ |_|   /_/   \_\|_||_| |_| \_\\___|| .__/  \___/ |_|    \__||___/╠╣
# ╠╣                                                                                 |_|                           ╠╣
# ╠╬╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╬╣
# ╚╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╝
#__author__ = 'Bob Sicko'
#__credits__ = ["kkhalsa (ArcherDx) created python_job_hook_example.py"]
#__version__ = "0.1"
#__maintainer__ = "Bob Sicko"
#__email__ = "robert.sicko@health.ny.gov"
#__status__ = "Development"
#__modname__ = "MOAR_jobhook.py"

# https://stackoverflow.com/questions/22162027/how-do-i-generate-a-static-html-file-from-a-django-template
# https://stackoverflow.com/questions/63876397/python-script-to-django-html-output
# https://stackoverflow.com/questions/41990794/django-executing-python-code-in-html
# http://10.50.100.113/auth/login?next=/about_archer

# https://realpython.com/primer-on-jinja-templating/#get-started-with-jinja


from argparse import ArgumentParser
from sys import stderr
import requests
import json
import re
import os
import csv
import io
#import pprint
import pandas as pd
import numpy as np
#from pandas.io.json import json_normalize
#from json2html import *
from collections import OrderedDict
from weasyprint import HTML, CSS
from weasyprint.text.fonts import FontConfiguration
from jinja2 import Environment, FileSystemLoader
from dotenv import load_dotenv

def credentials():
    dotenv = '/var/www/analysis/watched/nys_nbs/.env'
    load_dotenv(dotenv)
    global server
    server = os.environ.get("API_SERVER")
    global user
    user = os.environ.get("API_USER")
    global passw
    passw = os.environ.get("API_PASSW")
    global endpoint
    endpoint = "jobs"






def read_var_db():
    #############################################################################
    #NYS Var Database
    #/var/www/analysis/watched/nys_nbs/var_db.csv
    #############################################################################
    #ID	Gene	Chr	Current NBS Classification	Last Verification Date	Position VCF format (GRCh37)	Ref GRCh37	Alt GRCh37#
    fields = ['ID', 'Gene', 'Chr', 'Current NBS Classification', 'Last Verification Date', 'Position VCF format (GRCh37)', 'Ref GRCh37', 'Alt GRCh37']
    global var_database
    var_database = pd.read_csv('/var/www/analysis/watched/nys_nbs/var_db.csv', usecols=fields, \
      dtype = {'ID': str, 'Gene': str, 'Chr': str, 'Current NBS Classification': str, 'Last Verification Date': str, 'Position VCF format (GRCh37)': str, 'Ref GRCh37': str, 'Alt GRCh37': str})
    var_database = var_database[var_database['Gene'] == "CFTR"]


def read_sv_art_db():
    #############################################################################
    #SV artifact Database
    #/var/www/analysis/watched/nys_nbs/SV_artifacts.csv
    #############################################################################
    #Artifact ID,Start (hg19),Stop (hg19)
    fields = ['Artifact ID', 'Start (hg19)', 'Stop (hg19)']
    global sv_art_database
    sv_art_database = pd.read_csv('/var/www/analysis/watched/nys_nbs/SV_artifacts.csv', usecols=fields, \
      dtype = {'Artifact ID': str, 'Start (hg19)': str, 'Stop (hg19)': str})


#function to get classification and date here
#def my_function(fname):
#  print(fname + " Refsnes")

def get_classification(archer_position, archer_ref, archer_alt):
    key_names = ['Position VCF format (GRCh37)', 'Ref GRCh37', 'Alt GRCh37']
    keys = [archer_position, archer_ref, archer_alt]
   # print(var_database.query('`Position VCF format (GRCh37)` == @archer_position && `Ref GRCh37` == @archer_ref && `Alt GRCh37` == @archer_alt'))
    try:
        classification = var_database[(var_database[key_names] == keys).all(1)]['Current NBS Classification'].values[0]
        date = var_database[(var_database[key_names] == keys).all(1)]['Last Verification Date'].values[0]
    except IndexError:
        classification = "Not classified"
        date = "NA"
    #print(classification)
    #print(date)
    if(classification == "."):
        classification = "Not classified"
        date = "NA"
    return (classification + " " + date)
    
#    get_classification("117232228","C","G")
#14508  NBS029420  CFTR   7              Likely benign             12/27/2023                    117232228          C          T
#from API variant_filtered_list
# "genomic_location": "chr7:117174411",
#      "reference_variant": "T / G",

def check_sv(archer_start, archer_stop):
    return ((sv_art_database['Start (hg19)'] == archer_start) & (sv_art_database['Stop (hg19)'] == archer_stop)).any()


def runHook(job_id, hook_output_dir):
    """

    :param str job_id: Job ID
    :param str job_dir_path: Path to job dir
    :param [str] sample_names: Sample names
    :param str hook_output_dir: path to hook output dir
    :return:
    """
    
    # polyT_report = job_dir + "job_hook_output/polyTG_table_v2.0.1/" + str(job) + "_polyTGT_calls_v2.0.1.txt"
    #polyT_report = "/home/rocky/4744_polyTGT_calls_v2.0.1.txt"
    # coverage_report = job_dir + "job_hook_output/coverage_report/" + str(job) + "_coverage_report.txt"
    #coverage_report = "/home/centos/4744_coverage_report.txt"

    # access 3rd tier job hooks through API here
    response_polyT = requests.request("GET", url_polyT, auth=(user, passw))
    polyT_report=response_polyT.content

    response_coverage = requests.request("GET", url_coverage, auth=(user, passw))
    coverage_report=response_coverage.content
    rawCoverage = pd.read_csv(io.StringIO(coverage_report.decode('utf-8')),sep="\t")
    url = "{}api/{}/{}".format(server, endpoint, job_id)
    job_dir = "/var/www/analysis/" + str(job_id) + "/"
    hook_output_dir_path=job_dir + "job_hook_output/"
    url_polyT = "{}api/{}/{}/job-directory-files/download/job_hook_output/polyTG_table_v2.0.1/{}_polyTGT_calls_v2.0.1.txt".format(server, endpoint, job,job)
    url_coverage = "{}api/{}/{}/job-directory-files/download/job_hook_output/coverage_report_v1.0.1/{}_coverage_report.txt".format(server, endpoint, job,job)

    environment = Environment(loader=FileSystemLoader("/home/rocky/templates/"))
    #results_filename = "/home/rocky/{}_test_MOAR.html".format(job)
    results_template = environment.get_template("MOAR_template.html")
    under10x_template = environment.get_template("under10x_template.html")
    sv_template = environment.get_template("SV_template.html")

    class Item:
      def __init__(self, vals):
        self.__dict__ = vals
    # report_output = hook_output_dir_path + str(job) + "_MOAR.csv"
    #report_output_json = "/home/centos/4744_test_MOAR.json"
    # access 3rd tier job API here
    response_3rd_tier = requests.request("GET", url, auth=(user, passw))
    respJSON_3rd_tier = response_3rd_tier.json()
    # grab the name since this starts with 2nd tier job number
    name=respJSON_3rd_tier['data'].get('name')
    # grab the number
    job_original=re.search(r'\d+', name).group()
    # access 2nd tier job API here
    url_2nd_tier = "{}api/{}/{}".format(server, endpoint, job_original)
    response_2nd_tier = requests.request("GET", url_2nd_tier, auth=(user, passw))
    respJSON_2nd_tier = response_2nd_tier.json()
    # print(respJSON_original)
    # pretty_json_original = json.dumps(respJSON_original, indent=4)
    data_2nd_tier = respJSON_2nd_tier['data']
    project_name = data_2nd_tier['name']
    project_name = project_name.removesuffix('_2nd-tier_auto')
    report_output_html = hook_output_dir + "{}_test_MOAR.html".format(project_name)
    report_output_pdf = hook_output_dir + "{}_test_MOAR.pdf".format(project_name)

    samples = data_2nd_tier['samples'] # list of samples
    gsp2 = [] # list of gsp2 start sites to fill in the loop below
    uft = [] # list of unique fragement total to fill in the loop below
    # loop through all samples
    sample_index = 0
    our_sample_list=[]
    sv_list=[]
    var_under_10x_list= []
    for sample in samples:
        sample_index = sample_index+1
        # print(sample['name'])
    # access 2nd tier sample details API here
        sample_url = sample['detail_url']
        sample_response = requests.request("GET", sample_url, auth=(user, passw))
        sample_dict = sample_response.json()
    # access 2nd tier sample read statistics API here
        sample_read_stats_url = sample_dict['data']['results']['read_stats_url']
        sample_read_stats_response = requests.request("GET", sample_read_stats_url, auth=(user, passw))
        sample_read_stats_dict = sample_read_stats_response.json()
        sample_UFT = sample_read_stats_dict['data']['read_stat_types'][1]['total_reads']
        sample_gsp2 = sample_read_stats_dict['data']['total_stats'][4]['dna_reads'] # this particular samples gsp2 value
        # print(sample_gsp2)
        gsp2.append(sample_gsp2) # store it in our gsp2 list
        sample_3rd_tier_vars = []
        sample_3rd_tier_svs = []
        tier3_count = 0
        tier3_sv_count = 0
    # access 2nd tier variant API here
        sample_2nd_tier_variant_url = sample_dict['data']['results']['variants']['variant_filtered_list_url']
        sample_2nd_tier_variant_response = requests.request("GET", sample_2nd_tier_variant_url, auth=(user, passw))
        sample_2nd_tier_variant_dict = sample_2nd_tier_variant_response.json()
        tier2_count = sample_2nd_tier_variant_dict['count']
        tier2_vars = sample_2nd_tier_variant_dict['results']
        sample_2nd_tier_vars = []
        one_variant = {}
        for variant in tier2_vars:
            #print(variant['genomic_location'].split(":")[1].strip())
            #print(variant['reference_variant'].split("/")[0].strip())
            #print(variant['reference_variant'].split("/")[1].strip())
            one_variant = {
                        "cDNA": re.split('[:]', variant['name'])[1],
                        "Prot": re.split('[:]', variant['name'])[2],
                        "Legacy": re.split('[:]', variant['name'])[3],
                        "AF": round(float(variant['allele_fraction']),3),
                        "hg19": int(re.split('[:]',variant['genomic_location'])[1]),
                        "AO": variant['ao'],
                        "UAO": variant['uao'],
                        #get classification and date here
                         "classification": get_classification((variant['genomic_location'].split(":")[1].strip()), (variant['reference_variant'].split("/")[0].strip()), (variant['reference_variant'].split("/")[1].strip()))
            }
            sample_2nd_tier_vars.append(one_variant)
    #    access 3rd tier variant API here
        sample_went_to_3rd = False
        samples_3rd_tier = respJSON_3rd_tier['data']['samples']
        sample_2nd_tier_name = sample['name']
        for i in range(len(samples_3rd_tier)):
          # is this sample in the 3rd tier job?
            if sample_2nd_tier_name in samples_3rd_tier[i]['name']:
                sample_went_to_3rd = True
                detailed_3rd_sample_url = samples_3rd_tier[i]['detail_url']
                detailed_3rd_sample_response = requests.request("GET", detailed_3rd_sample_url, auth=(user, passw))
                detailed_3rd_sample_dict = detailed_3rd_sample_response.json()
                sample_3nd_tier_variant_url = detailed_3rd_sample_dict['data']['results']['variants']['variant_filtered_list_url']
                sample_3rd_tier_variant_response = requests.request("GET", sample_3nd_tier_variant_url, auth=(user, passw))
                sample_3rd_tier_variant_dict = sample_3rd_tier_variant_response.json()
                tier3_count = sample_3rd_tier_variant_dict['count']
                tier3_vars = sample_3rd_tier_variant_dict['results']
                variant_3rd = {}
                for variant in tier3_vars:
                    try:
                        Prot = re.split('[:]', variant['hgvs_p'])[1]
                    except TypeError:
                        Prot = "p.?"
                    variant_3rd = {
                            "cDNA": re.split('[:]', variant['hgvs_c'])[1],
                            "Prot": Prot,
                            "AF": round(float(variant['allele_fraction']),3),
                            "hg19": int(re.split('[:]',variant['genomic_location'])[1]),
                            "AO": variant['ao'],
                            "UAO": variant['uao'],
                            #get classification and date here
                            "classification": get_classification((variant['genomic_location'].split(":")[1].strip()), (variant['reference_variant'].split("/")[0].strip()), (variant['reference_variant'].split("/")[1].strip()))
                    }
                    sample_3rd_tier_vars.append(variant_3rd)

                sample_3rd_tier_sv_url = detailed_3rd_sample_dict['data']['results']['isoforms']['isoform_list_url']
                sample_3rd_tier_sv_response = requests.request("GET", sample_3rd_tier_sv_url, auth=(user, passw))
                sample_3rd_tier_sv_dict = sample_3rd_tier_sv_response.json()

                tier3_svs = sample_3rd_tier_sv_dict['results']
                one_sv = {}
                for sv in tier3_svs:
                    if not sv['is_artifact'] and sv['strong_evidence_aberration']: # not an artifact and strong
                        start = sv['breakpoint_signature'].split(",")[0]
                        start = start.split(":")[1]
                        stop = sv['breakpoint_signature'].split(",")[1]
                        stop = stop.split(":")[1]
                        #print(start)
                        #print(stop)
                        #print(check_sv(start, stop))
                        if not check_sv(start, stop):
                            tier3_sv_count = tier3_sv_count+1
                            one_sv = {
                                "uss": sv['unique_start_sites'],
                                "num_reads": sv['num_reads'],
                                "per_reads": sv['percent_of_coverage'],
                                "bps": sv['breakpoint_signature']
                            }
                    sample_3rd_tier_svs.append(one_sv)
        sample_name_clean = re.sub("_S\d{1,2}_L001_R1_001$", "",sample['name'])
        #polyT_hap1 = ""
        #polyT_hap2 = ""
        rawPolyT = pd.read_csv(io.StringIO(polyT_report.decode('utf-8')),sep="\t")
        try:
           polyT_call = rawPolyT.loc[rawPolyT['sample'].str.contains(sample_name_clean), 'final_call'].values[0]
        except IndexError:
           polyT_call = "not_found"
           
        #with open(polyT_report) as tsv:
        #    for line in csv.reader(tsv, dialect="excel-tab"):
        #        sample_name_clean_polyT = re.sub("_S\d{1,2}$", "",line[0])
        #        if sample_name_clean == sample_name_clean_polyT:
        #            polyT_call = line[1]
        #        #if sample_name_clean == sample_name_clean_polyT:
        #        #    polyT_call = re.split('/', line[1])
        #        #    polyT_hap1 = polyT_call[0]
        #        #    polyT_hap2 = polyT_call[1]
        sample_has_svs = "No"
        if tier3_sv_count > 0:
            sample_has_svs = "Yes"
            one_sample_svs = {
                    "Name": sample_name_clean,
                    "gsp2ss": int(float(sample_gsp2)),
                    "uft": sample_UFT,
                    "Reportable_SVs": sample_3rd_tier_svs
            }
            order_of_keys_sv = ["Name", "gsp2ss", "uft","Reportable_SVs"]
            list_of_tuples_sv = [(key, one_sample_svs[key]) for key in order_of_keys_sv]
            one_sample_svs = OrderedDict(list_of_tuples_sv)
            sv_list.append(one_sample_svs)
            
    #under 10x report
        if not re.search(sample_2nd_tier_name, 'ntc', re.IGNORECASE):
            if sample_UFT >= 20000 and sample_gsp2 >= 30:
    #    access raw 2nd tier variant API here
                sample_raw_2nd_tier_variant_url = sample_dict['data']['results']['variants']['variant_list_url']
                sample_raw_2nd_tier_variant_response = requests.request("GET", sample_raw_2nd_tier_variant_url, auth=(user, passw))
                sample_raw_2nd_tier_variant_dict = sample_raw_2nd_tier_variant_response.json()
                raw_tier2_vars = sample_raw_2nd_tier_variant_dict['results']
                one_raw_variant = {}
                for raw_var in raw_tier2_vars:
                    if raw_var['depth'] < 10:
                        one_raw_variant = {
                                        "Name" : sample_name_clean,
                                        "cDNA": re.split('[:]', raw_var['name'])[1],
                                        "Prot": re.split('[:]', raw_var['name'])[2],
                                        "Legacy": re.split('[:]', raw_var['name'])[3],
                                        "AF": round(float(variant['allele_fraction']),3),
                                        "hg19": int(re.split('[:]',variant['genomic_location'])[1]),
                                        "AO": variant['ao'],
                                        "UAO": variant['uao']
                        }
                        var_under_10x_list.append(one_raw_variant)
        one_sample = {
                    "Count": sample_index,
                    "Name": sample_name_clean,
                    "gsp2ss": int(float(sample_gsp2)),
                    "uft": sample_UFT,
                    "tier2_var_num": tier2_count,
                    "tier2_vars": sample_2nd_tier_vars,
                    "has_3rd": sample_went_to_3rd,
                    "tier3_var_num": tier3_count,
                    "tier3_vars": sample_3rd_tier_vars,
                    "Reportable_SVs": sample_has_svs,
                    "polyT_call": polyT_call,
        }
        
        order_of_keys = ["Count", "Name", "gsp2ss", "uft", "tier2_var_num","tier2_vars","has_3rd","tier3_var_num","tier3_vars","polyT_call","Reportable_SVs"]
        list_of_tuples = [(key, one_sample[key]) for key in order_of_keys]
        one_sample = OrderedDict(list_of_tuples)
        our_sample_list.append(one_sample)

    #polyT report
    #original_polyT_report = pd.read_csv(polyT_report,sep='\t') 
    #sample	final_call	total_reads_at_locus	sum_our_haplo	percent_our_haplo_vs_total_at_locus	percent_not_our_haplo	top_haplo_1_name	top_haplo_1_count	top_haplo_1_percent	
    #top_haplo_2_name	top_haplo_2_count	top_haplo_2_percent	proportion_hap2	zygosity	percent_haplo_used_for_call	next_highest_percent_haplo
    rawPolyT['sample'] = rawPolyT['sample'].replace("_S\d{1,2}$", '', regex=True)
    rawPolyT.index = np.arange(1, len(rawPolyT)+1)
    rawPolyT.rename(columns={'sample': 'Sample<br/>ID', 'final_call': 'Diplotype', 'total_reads_at_locus': 'Total<br/>Reads<br/>at Locus', 'sum_our_haplo': 'Reads In<br/>Known<br/>Haplotype', \
                             'percent_our_haplo_vs_total_at_locus': '% Reads<br/>In Known<br/>Haplotype', 'percent_not_our_haplo': '% Reads<br/>In Unknown<br/>Haplotype', \
                             'top_haplo_1_name': 'Top<br/>Haplotype', 'top_haplo_1_count': 'Reads In<br/>Top<br/>Haplotype', 'top_haplo_1_percent': '% Reads<br/>In Top<br/>Haplotype', \
                             'top_haplo_2_name': 'Second<br/>Haplotype', 'top_haplo_2_count': 'Reads In<br/>Second<br/>Haplotype', 'top_haplo_2_percent': '% Reads<br/>In Second<br/>Haplotype', \
                             'proportion_hap2': 'Proportion<br/>Second<br/>Haplotype', 'zygosity': 'Zygosity', 'percent_haplo_used_for_call': '% Reads<br/>Used In<br/>Diplotype', 'next_highest_percent_haplo': '% Reads<br/>In Next<br/>Highest<br/>Haplotype' }, inplace=True)
    original_polyT_report_html = rawPolyT.to_html(escape=False)

    #coverage report
    #original_coverage_report = pd.read_csv(coverage_report,sep='\t') 
    #Sample	Average_Coverage_Overall	Average_Coverage_CDS	Average_Coverage_Intron	Average_Coverage_UTR	Average_Coverage_SNP_Amps	Average_Coverage_Promoter	Uniformity_Overall	Uniformity_CDS	Uniformity_Intron	Uniformity_UTR	Uniformity_SNP_Amps	Uniformity_Promoter
    rawCoverage['Sample'] = rawCoverage['Sample'].replace("_S\d{1,2}$", '', regex=True)
    rawCoverage.index = np.arange(1, len(rawCoverage)+1)
    rawCoverage['Average_Coverage_Overall'] = rawCoverage['Average_Coverage_Overall'].astype(int)
    rawCoverage['Average_Coverage_CDS'] = rawCoverage['Average_Coverage_CDS'].astype(int)
    rawCoverage['Average_Coverage_Intron'] = rawCoverage['Average_Coverage_Intron'].astype(int)
    rawCoverage['Average_Coverage_UTR'] = rawCoverage['Average_Coverage_UTR'].astype(int)
    rawCoverage['Average_Coverage_SNP_Amps'] = rawCoverage['Average_Coverage_SNP_Amps'].astype(int)
    rawCoverage['Average_Coverage_Promoter'] = rawCoverage['Average_Coverage_Promoter'].astype(int)
    rawCoverage.rename(columns={'Sample': 'Sample<br/>ID', 'Average_Coverage_Overall': 'Average<br/>Coverage<br/>Overall', 'Average_Coverage_CDS': 'Average<br/>Coverage<br/>CDS', 'Average_Coverage_Intron': 'Average<br/>Coverage<br/>Intron', \
                                'Average_Coverage_UTR': 'Average<br/>Coverage<br/>UTR', 'Average_Coverage_SNP_Amps': 'Average<br/>Coverage<br/>SNP<br/>Amps', 'Average_Coverage_Promoter': 'Average<br/>Coverage<br/>Promoter', \
                                'Uniformity_Overall': 'Uniformity<br/>Overall', 'Uniformity_CDS': 'Uniformity<br/>CDS', 'Uniformity_Intron': 'Uniformity<br/>Intron', \
                                'Uniformity_UTR': 'Uniformity<br/>UTR', 'Uniformity_SNP_Amps': 'Uniformity<br/>SNP<br/>Amps', 'Uniformity_Promoter': 'Uniformity<br/>Promoter'}, inplace=True)

    original_coverage_report_html = rawCoverage.to_html(escape=False)

    samples_html_report = results_template.render(our_sample_list=[Item(i) for i in our_sample_list])
    under10x_html_report = under10x_template.render(var_under_10x_list=[Item(i) for i in var_under_10x_list])
    sv_html_report = sv_template.render(sv_list=[Item(i) for i in sv_list])

    html_report = "<header id=\"pageHeader\">Archer " + project_name + "</header>" + samples_html_report + sv_html_report + under10x_html_report \
                + "<caption style=\"font-weight: bold; font-size: 12px;\">Coverage Report</caption>" + original_coverage_report_html \
                + "<caption style=\"font-weight: bold; font-size: 12px;\">PolyTGT Report</caption>" + original_polyT_report_html

    with open(report_output_html, mode="w", encoding="utf-8") as results:
        results.write(html_report)
        print(f"... wrote {report_output_html}")

    css = CSS(string='''<style type="text/css">
                @page {
                    size: landscape; margin: 0.5cm;
                    @top-center {
                        content: element(pageHeader);
                    }
                    @bottom-center {
                        content: counter(page) " of " counter(pages);
                    }
                }
                #pageHeader{
                    font-size: 14px;
                    position: running(pageHeader);
                }
                tbody {
                    break-inside: avoid;
                    display:table-row-group;
                }
                thead {
                    display: table-header-group;
                }
            @font-face {
                font-family: "dejavu-sans-fonts";
                src: url(/usr/share/fonts/dejavu-sans-fonts/DejaVuSansCondensed-Oblique.ttf);
                font-stretch: ultra-condensed;
            }
            table {font-size: 10px; border: 1px solid black; border-color: black; margin-bottom: 15px; word-wrap: break-word; border-collapse: collapse;
                  table-layout: auto;}
                     td { border: 1px solid black; line-height: 13px; vertical-align: top; padding: 2px; text-align: center; color: black; break-inside: avoid;}
                     th { border: 1px solid black; line-height: 13px; vertical-align: center; padding: 2px; text-align: center; background: #5789c6; color: #FFF;}
                     td.fail {color: red; font-weight: bold;}
                     td.metric{text-align: right;}
                     td.nowrap{white-space: nowrap;}
                     td.highlight{background-color:yellow}
                     td.na{font-style:italic; font-size:8px; color:grey}
            caption {align: left; white-space: nowrap; font-weight: bold; font-size: 12px;}
    </style>''')
    font_config = FontConfiguration()
    HTML(string=html_report).write_pdf(report_output_pdf, stylesheets=[css], font_config=font_config)

def main():
    parser = ArgumentParser(description='')

    parser.add_argument("-j", "--job_id", required=True, help="Job ID")
    parser.add_argument("-o", "--hook_output_dir_path", required=True, help="Hook output dir path")
    args = parser.parse_args()
    credentials()
    read_var_db()
    read_sv_art_db()
    runHook(job_id=args.job_id, hook_output_dir=args.hook_output_dir_path)

# Example UI Args: -j ${JOB_ID} -d ${JOB_DIR} -s ${SAMPLE_NAMES_SPACED} -o ${HOOK_OUTPUT_DIR}

if __name__ == "__main__":
    main()
