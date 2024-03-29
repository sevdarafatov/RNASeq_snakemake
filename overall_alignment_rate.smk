import re
import os
import pandas as pd
def getlist():
        id_list=[]
        for i in os.listdir("samb/"):
                #gets list of sambamas:
                if i.endswith('samb.txt'):
                        id = os.path.basename(i)[:-8]
                        id_list.append(id)
        return id_list
SAMPLES=getlist()
rule all:
    input:  "rate1.txt"
rule overall_alignment_rate:
        input:  expand("{dir}/{sample}samb.txt", sample=SAMPLES, dir="samb")
        output: "rate1.txt"
        script: "scripts/Overall_alignment_rate.py"
