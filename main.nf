#!/usr/bin/env nextflow

nextflow.enable.dsl = 2



include { SCVI } from "./modules/scvi.nf"
include { NEIGHBORS } from "./modules/neighbors_leiden_umap.nf"

ch_configs_scvi = Channel.from([
    ['zeus', 20],
    ['apollo-new', 20],
    ['apollo-new', 40],
    ['apollo-old', 20],
    ['apollo-old', 40],
    // ['gpu', 4]
])

ch_configs_neighbors = Channel.from([
    ['zeus', 4],
    ['zeus', 8],
    ['apollo-new', 4],
    ['apollo-new', 8],
    ['apollo-old', 4],
    ['apollo-old', 8],
])

ch_datasets = Channel.fromPath("data/datasets/*.h5ad")

workflow {
    SCVI(
        ch_datasets.map{it -> [it.baseName, it]}.combine(ch_configs_scvi).view(),
        "sample"
    )
    ch_adata_scvi_for_neighbors = SCVI.out.adata.filter(
        it -> it[0]['n_cpus'] == 40 && it[0]['machine'].equals("apollo-new")
    )
    NEIGHBORS(
        ch_adata_scvi_for_neighbors.combine(ch_configs_neighbors).view(),
        "X_scVI",
    )
    // LEIDEN_UMAP(
    //     file("analyses/leiden_umap.py"),
    //     Channel.from(
    //         ["from_latent", file("data/adata_scvi.h5ad")]
    //     ),
    //     Channel.from("zeus", "apollo-01", "apollo-13", "apollo-15")
    // )
}
