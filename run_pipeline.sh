#!/bin/bash

nextflow run ./main.nf \
    -profile icbi \
    -w $(readlink -f /home/sturm/scratch/projects/2021/scanpy_reproducibility/work) \
    -with-trace -with-timeline -with-report \
    --outdir $(readlink -f ./results) \
    -resume
