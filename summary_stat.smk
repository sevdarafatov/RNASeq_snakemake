import os
def getlist():
        id_list=[]
        for i in os.listdir():
                #gets list of bams:
                if i.endswith('sorted.bam'):
                        id = os.path.basename(i)[:-10]
                        id_list.append(id)
        return id_list
SAMPLES=getlist()
rule all:
    input:  expand("{sample}sambambastats.txt", sample=SAMPLES)
rule summary_stat:
    input:  "{sample}sorted.bam"
    output: "{sample}sambambastats.txt"
    threads:    10
    shell:   'samtools flagstat {input} -@ {threads} > {output} '
