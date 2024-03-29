import os
def getlist():
        id_list=[]
        for i in os.listdir():
                #gets list of fastqs:
                if i.endswith('.fastq.gz'):
                        id = os.path.basename(i)[:-8]
                        id_list.append(id)
        return id_list
SAMPLES = getlist()
rule all:
        input:
            expand("{sample}_fastqc.html", sample=SAMPLES),
            expand("{sample}_fastqc.zip", sample=SAMPLES)
rule FastQC:
    """
    QC on fastq read data
    """
    input:  "{sample}.fastq.gz"
    output:
        html="{sample}_fastqc.html",
        zip="{sample}_fastqc.zip"
    threads: 5
    shell: 'fastqc {input} -t {threads}'
