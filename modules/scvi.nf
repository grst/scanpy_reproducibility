#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

process SCVI {
    cpus { queue.contains("-15") ? 4 : n_cpus }
    conda "/home/sturm/.conda/envs/pircher-sc-integrate2"
    // container "containers/sc-integrate2.sif"
    // // support for nvidia https://lucacozzuto.medium.com/using-gpu-within-nextflow-19cd185d5e69
    // containerOptions = "--nv"
    clusterOptions "-V -S /bin/bash -q $queue"

    input:
        tuple val(id), path(input_adata)
        tuple val(batch_key), val(hvg_batch_key), val(labels_key)
        each queue
        each n_cpus

    output:
        tuple val(id), path("*_integrated_scvi.h5ad"), emit: adata
        tuple val(id), path("*_scvi_model"), emit: scvi_model

    script:
    def use_gpu = queue.contains("-15")
    def suffix = ""
    def labels_key_arg = labels_key ? "--labels_key ${labels_key}" : ""
    """
    export CUDA_VISIBLE_DEVICES=\$((0 + \$RANDOM % 2))
    export OPENBLAS_NUM_THREADS=${task.cpus} OMP_NUM_THREADS=${task.cpus}  \\
        MKL_NUM_THREADS=${task.cpus} OMP_NUM_cpus=${task.cpus}  \\
        MKL_NUM_cpus=${task.cpus} OPENBLAS_NUM_cpus=${task.cpus}
    integrate_scvi.py \\
        ${input_adata} \\
        --adata_out ${id}_${suffix}_integrated_scvi.h5ad \\
        --model_out ${id}_${suffix}_scvi_model \\
        --hvg_batch_key ${hvg_batch_key} \\
        --use_gpu ${use_gpu} \\
        --batch_key ${batch_key} \\
        ${labels_key_arg}
    """
}
