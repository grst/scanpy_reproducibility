process JUPYTERNOTEBOOK {
    publishDir "${params.outdir}"

    // conda "/home/sturm/.conda/envs/pircher-sc-integrate2"
    // conda "ipykernel=6.0.3 jupytext=1.11.4 nbconvert=6.1.0 papermill=2.3.3 scanpy=1.7.2 leidenalg=0.8.7"
    container "https://github.com/grst/scanpy_reproducibility/releases/download/containers-0.1.0/scanpy_reproducibility.sif"
    clusterOptions "-V -S /bin/bash -q all.q@$node"

    input:
    path(notebook)
    path(input_adata)
    val(node)

    output:
    path("*.html"), emit: report
    path("artifacts/*"), emit: artifacts, optional: true

    script:
    """
    set -o pipefail

    # Create output directory
    mkdir artifacts

    # Set parallelism for BLAS/MKL etc. to avoid over-booking of resources
    export MKL_NUM_THREADS="${task.cpus}"
    export OPENBLAS_NUM_THREADS="${task.cpus}"
    export OMP_NUM_THREADS="${task.cpus}"
    export NUMBA_NUM_THREADS="${task.cpus}"

    # Convert notebook to ipynb using jupytext, execute using papermill, convert using nbconvert
    jupytext --to notebook --output - --set-kernel - ${notebook}  \\
        | papermill -p input_adata ${input_adata} \\
        | jupyter nbconvert --stdin --to html --output ${node}.html
    """
}
