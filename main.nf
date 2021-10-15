#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { JUPYTERNOTEBOOK } from "./modules/jupyternotebook.nf"

workflow {
    JUPYTERNOTEBOOK(
        file("analyses/leiden_umap.py"),
        file("data/adata_scvi.h5ad"),
        Channel.from("zeus", "apollo-01", "apollo-02", "apollo-14", "apollo-15")
    )
}
