# Test reproducibility of leiden/umap on different systems

This nextflow pipeline runs a jupyter notebook that runs 
```
sc.pp.neighbors
sc.tl.umap
sc.tl.leiden
```

on a test dataset with a pre-computed latent representation stored in `adata.obsm["X_scVI"]`.

The test-dataset is available in the [data](./data) directory. 

## Running the pipeline

There are a few minor things you may need to adjust on your system: 

 * The [run_pipeline.sh](./run_pipeline.sh) script starts nextflow with a work directory
   and a profile specific to our institute.
 * The `clusterOptions` is used to submit the jobs to different nodes on our HPC and
   is specific to our queue and node names. 
 * The node names are passed on to `clusterOptions` from a channel defined in `main.nf`. 

## Results

The results (tested on 5 nodes, 4 of which have different CPUs) are available from: 
https://grst.github.io/scanpy_reproducibility/
