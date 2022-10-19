import os
def getlist():
        id_list=[]
        for i in os.listdir():
                #gets list of fastqs:
                if i.endswith('fastq.gz'):
                        id = os.path.basename(i)[:-8]
                        id_list.append(id)
        return id_list
SAMPLES = getlist()
rule all:
    input:      "seq.txt"
rule  seqkit:
    input:  expand("{sample}fastq.gz", sample=SAMPLES)
    output: "seq.txt"
    threads: 10
    shell:  'seqkit stats {input} -a -T -j {threads} >>  {output} '
