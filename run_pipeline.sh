#!/bin/bash

nextflow run ./main.nf -resume \
    -profile icbi \
    -w /home/sturm/scratch/projects/2021/scanpy_reproducibility
