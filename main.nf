#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include SCVI from "./modules/scvi.nf"

ch_queues = Channel.from(
    "all.q@zeus",
    "all.q@apollo-(01|02|03|04|05|06|07|08|09|10)",
    "all.q@apollo-(11|12|13|14)",
    // "all.q@apollo-15"
)
ch_cpus = Channel.from(
    20, 40
)
ch_datasets = Channel.fromPath("data/datasets/*.h5ad")

workflow {
    SCVI(
        ch_datasets.map{it -> [it.baseName, it]},
        ["sample", "sample", null],
        ch_queues,
        ch_cpus
    )
    // LEIDEN_UMAP(
    //     file("analyses/leiden_umap.py"),
    //     Channel.from(
    //         ["from_latent", file("data/adata_scvi.h5ad")]
    //     ),
    //     Channel.from("zeus", "apollo-01", "apollo-13", "apollo-15")
    // )
}
