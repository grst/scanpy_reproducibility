
process NEIGHBORS {
    cpus { n_cpus }
    conda "/home/sturm/.conda/envs/pircher-sc-integrate2"
    clusterOptions "-V -S /bin/bash -q \"${params.queues[machine]}\""
    // container "containers/sc-integrate2.sif"

    input:
    tuple val(meta), path(adata), val(machine), val(n_cpus)
    val use_rep

    output:
    tuple val(meta), path("*.h5ad"), emit: adata

    script:
    meta = ['id': meta.id, 'machine': machine, 'n_cpus': n_cpus]
    """
    #!/usr/bin/env python

    import scanpy as sc
    from threadpoolctl import threadpool_limits

    threadpool_limits(${task.cpus})
    sc.settings.n_jobs = ${task.cpus}

    adata = sc.read_h5ad("${adata}")
    sc.pp.neighbors(adata, use_rep="${use_rep}")
    adata.write_h5ad("${meta.id}_${meta.machine}_${meta.n_cpus}cpus.neighbors.h5ad")
    """
}

// process UMAP {
//     conda "/home/sturm/.conda/envs/pircher-sc-integrate2"
//     // container "containers/sc-integrate2.sif"
//     cpus 8

//     input:
//     tuple val(id), path(adata)

//     output:
//     tuple val(id), path("*.h5ad"), emit: adata

//     script:
//     """
//     #!/usr/bin/env python

//     import scanpy as sc
//     from threadpoolctl import threadpool_limits

//     threadpool_limits(${task.cpus})
//     sc.settings.n_jobs = ${task.cpus}

//     adata = sc.read_h5ad("${adata}")
//     sc.tl.umap(adata)
//     adata.write_h5ad("${id}.umap.h5ad")
//     """
// }

// process LEIDEN {
//     conda "/home/sturm/.conda/envs/pircher-sc-integrate2"
//     // container "containers/sc-integrate2.sif"
//     cpus 1

//     input:
//     tuple val(id), path(adata)
//     each resolution

//     output:
//     tuple val(id), val(resolution), path("*.h5ad"), emit: adata

//     script:
//     """
//     #!/usr/bin/env python

//     import scanpy as sc
//     from threadpoolctl import threadpool_limits

//     threadpool_limits(${task.cpus})
//     sc.settings.n_jobs = ${task.cpus}

//     adata = sc.read_h5ad("${adata}")
//     sc.tl.leiden(adata, resolution=${resolution})
//     adata.write_h5ad("${id}.res_${resolution}.leiden.h5ad")
//     """
// }

// process MERGE_UMAP_LEIDEN {
//     publishDir "${params.outdir}",
//         mode: params.publish_dir_mode,
//         saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:meta, publish_by_meta:['id']) }

//     conda "/home/sturm/.conda/envs/pircher-sc-integrate2"
//     // container "containers/sc-integrate2.sif"
//     cpus 1

//     input:
//     tuple val(id), path(adata_umap), val(leiden_resolutions), path(adata_leiden)

//     output:
//     tuple val(id), path("*.h5ad"), emit: adata

//     script:
//     """
//     #!/usr/bin/env python

//     import scanpy as sc
//     from threadpoolctl import threadpool_limits

//     threadpool_limits(${task.cpus})
//     sc.settings.n_jobs = ${task.cpus}

//     resolutions = ${leiden_resolutions}
//     if not isinstance(resolutions, list):
//         resolutions = [resolutions]
//     leiden_adatas = "${adata_leiden}".split(" ")

//     adata_umap = sc.read_h5ad("${adata_umap}")
//     for res, adata_path in zip(resolutions, leiden_adatas):
//         tmp_adata = sc.read_h5ad(adata_path)
//         adata_umap.obs[f"leiden_{res:.2f}"] = tmp_adata.obs["leiden"]
//     adata_umap.write_h5ad("${id}.umap_leiden.h5ad")
//     """
// }



// workflow NEIGHBORS_LEIDEN_UMAP {
//     take:
//     adata
//     neihbors_rep
//     leiden_res

//     main:
//     NEIGHBORS(adata, neihbors_rep)
//     UMAP(NEIGHBORS.out.adata)
//     LEIDEN(NEIGHBORS.out.adata, leiden_res)

//     MERGE_UMAP_LEIDEN(UMAP.out.adata.join(LEIDEN.out.groupTuple()))

//     emit:
//     adata = MERGE_UMAP_LEIDEN.out.adata
// }
