#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

process SCVI {
    cpus { n_cpus }
    conda "/home/sturm/.conda/envs/pircher-sc-integrate2"
    // container "containers/sc-integrate2.sif"
    // // support for nvidia https://lucacozzuto.medium.com/using-gpu-within-nextflow-19cd185d5e69
    // containerOptions = "--nv"
    clusterOptions "-V -S /bin/bash -q \"${params.queues[machine]}\""

    input:
        tuple val(id), path(input_adata), val(machine), val(n_cpus)
        val batch_key

    output:
        tuple val(meta), path("*_integrated_scvi.h5ad"), emit: adata
        tuple val(meta), path("*_scvi_model"), emit: scvi_model

    script:
    meta = ['id': id, 'machine': machine, 'n_cpus': n_cpus]
    use_gpu = machine.equals("gpu") ? "--use_gpu" : ""
    suffix = "${machine}_${n_cpus}cpus"
    """
    export CUDA_VISIBLE_DEVICES=\$((0 + \$RANDOM % 2))
    export OPENBLAS_NUM_THREADS=${task.cpus} OMP_NUM_THREADS=${task.cpus}  \\
        MKL_NUM_THREADS=${task.cpus} OMP_NUM_cpus=${task.cpus}  \\
        MKL_NUM_cpus=${task.cpus} OPENBLAS_NUM_cpus=${task.cpus}
    integrate_scvi.py \\
        ${input_adata} \\
        --adata_out ${id}_${suffix}_integrated_scvi.h5ad \\
        --model_out ${id}_${suffix}_scvi_model \\
        ${use_gpu} \\
        --batch_key ${batch_key} \\
    """
}
