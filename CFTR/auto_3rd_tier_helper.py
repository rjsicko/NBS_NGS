# -*- coding: utf-8 -*-
import requests
import json
import re
import os
from dotenv import load_dotenv
from argparse import ArgumentParser


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



def main():
    credentials()
    parser = ArgumentParser(description='')
    parser.add_argument("-j", "--job_id", required=True, help="Job ID")
    args = parser.parse_args() 
    job_id=args.job_id
    url_2nd_tier = "{}api/{}/{}".format(server, endpoint, job_id)
    response_2nd_tier = requests.request("GET", url_2nd_tier, auth=(user, passw))
    respJSON_2nd_tier = response_2nd_tier.json()
    # print(respJSON_original)
    # pretty_json_original = json.dumps(respJSON_original, indent=4)
    data_2nd_tier = respJSON_2nd_tier['data']
    project_name = data_2nd_tier['name']
    project_name = project_name.removesuffix('_2nd-tier_auto')
    print(project_name)

if __name__ == "__main__":
    main()