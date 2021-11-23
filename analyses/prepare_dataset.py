# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.11.2
#   kernelspec:
#     display_name: Python [conda env:.conda-scanpy_2020-12]
#     language: python
#     name: conda-env-.conda-scanpy_2020-12-py
# ---

# %%
import scanpy as sc

# %%
# !mkdir data

# %%
adata = sc.read_h5ad("/home/sturm/projects/2020/pircher-scrnaseq-lung/data/20_integrate_scrnaseq_data/integrate_datasets/11_seed_annotations/artifacts/Lambrechts_2018_LUAD_6653_annotated.h5ad")

# %%
adata.obsm

# %%
adata.obs

# %%
test_dataset = sc.AnnData(
    var=adata.var,
    obs=adata.obs.loc[:, []],
    obsm=adata.obsm
)

# %%
test_dataset.write_h5ad("./data/adata_scvi.h5ad", compression="gzip")

# %%
sc.pp.neighbors(test_dataset, use_rep="X_scVI")

# %%
test_dataset.write_h5ad("./data/adata_scvi_neighbors.h5ad", compression="gzip")

# %%
# !ls -lh data
