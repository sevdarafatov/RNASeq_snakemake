import re
import os
import pandas as pd

def get_bams():
        bams_list=[]
        for i in os.listdir():
                #gets list of bams:
                if i.endswith('sorted.bam'):
                        id = os.path.basename(i)[:-10]
                        bams_list.append(id)
        return bams_list

SAMPLES=get_bams()
print(SAMPLES)

rule all:
    input:  expand("{sample}samb.txt", sample=SAMPLES),
            expand("{sample}rnaqc", sample=SAMPLES),
            "rate1.csv",
            "rnaseqc.csv",
            "alignment_qc.csv"

rule summary_stat:
    input:  "{sample}sorted.bam"
    output: "{sample}samb.txt"
    threads:    10
    shell:  "samtools flagstat {input} -@ {threads} > {output} "

rule RNASeqQC:
    input:  "{sample}sorted.bam"
    params: gtf="/home/genwork2/Desktop/05.ref_area/ref_hisat2_annhg38p13/gencode_annotation_genes.gtf"
    output: directory("{sample}rnaqc")
    threads: 10
    log: "{sample}rnaqc.log"
    shell:"rnaseqc {params} {input} {output} -d {threads} 2> {log}"

rule overall_alignment_rate:
        input:  expand("{sample}samb.txt", sample=SAMPLES)
        output: "rate1.csv"
        script: "scripts/Overall_alignment_rate.py"

rule rnaseqc_scr:
        input:  expand("{dir}/{sample}sorted.bam.metrics.tsv", sample=SAMPLES, dir="tsvs")
        output: "rnaseqc.csv"
        script: "scripts/s.py"

rule merging:
        input:  df1="rate1.csv",
                df2="rnaseqc.csv"
        output: "alignment_qc.csv"
        run:
                df1=pd.read_csv(f"{input.df1}", sep='\t')
                df2=pd.read_csv(f"{input.df2}", sep='\t')
                df3=df1.merge(df2, on="Sample_Name")
                df3.to_csv(f"{output}", sep='\t')
