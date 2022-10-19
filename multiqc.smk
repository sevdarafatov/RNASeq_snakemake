from cgitb import html
import os
from random import sample
def getlist():
        id_list=[]
        for i in os.listdir():
                #gets list of fastqcs
                if i.endswith('fastqc.zip'):
                        id = os.path.basename(i)[:-10]
                        id_list.append(id)
        return id_list
SAMPLES = getlist()
rule all:
    input:      "multiQC.zip",
                "multiQC.html"
rule multiqc:
    input:  expand("{sample}fastqc.zip", sample=SAMPLES)
    output: "multiQC.zip",
            "multiQC.html"
    threads:    10
    shell:  'multiqc {input}'
