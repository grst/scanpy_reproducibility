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
import os

os.environ["PYTHONHASHSEED"] = "0"

# %%
import scanpy as sc
import numpy as np
import random

sc.set_figure_params(figsize=(8, 8))

# %%
np.random.seed(0)  # Numpy random
random.seed(0)  # Python random

# %% tags=["parameters"]
input_adata = "../data/adata_scvi.h5ad"

# %%
sc.logging.print_versions()

# %%
# !lscpu

# %%
adata = sc.read_h5ad(input_adata)

# %%
sc.pp.neighbors(adata, use_rep="X_scVI")
sc.tl.umap(adata)
sc.tl.leiden(adata)

# %% [markdown]
# Check (superficially) if connectivities are the same

# %%
(
    adata.obsp["connectivities"].sum(),
    adata.obsp["connectivities"][
        np.random.choice(adata.shape[0], 1000, replace=False), :
    ].sum(),
)

# %%
sc.pl.umap(adata, color="leiden", legend_loc="on data")

# %%
adata.obs["leiden"].value_counts()
