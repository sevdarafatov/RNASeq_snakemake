import os
import pandas as pd
import re
import sys
def getlist():
        id_list=[]
        for i in os.listdir("tsvs"):
                #gets list of tsvs:
                if i.endswith('sorted.bam.metrics.tsv'):
                        id = os.path.basename(i)[:-22]
                        id_list.append(id)
        return id_list
SAMPLES=getlist()
print(SAMPLES)
rule all:
        input:  "rnaseqc.txt"
rule rnaseqc_scr:
        input:  expand("{dir}/{sample}sorted.bam.metrics.tsv", sample=SAMPLES, dir="tsvs")
        output: "rnaseqc.txt"
        script: "scripts/s.py"
