# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.13.1
#   kernelspec:
#     display_name: Python [conda env:.conda-pircher-sc-integrate2]
#     language: python
#     name: conda-env-.conda-pircher-sc-integrate2-py
# ---

# %%
import scanpy as sc
import pandas as pd
import numpy as np
from pathlib import Path
import numpy.testing as npt

# %%
scvi_adatas = list(Path("../results/scvi/").glob("*.h5ad"))


# %%
def make_df():
    for path in scvi_adatas:
        filename = path.stem
        dataset, rest = filename.split(".")
        _, node, cpus, _ = rest.split("_", maxsplit=3)
        yield dataset, node, cpus, str(path)

samplesheet = pd.DataFrame.from_records(make_df(), columns=["dataset", "node", "cpus", "adata_path"])

# %%
adatas = {
    r.Index: sc.read_h5ad(r.adata_path) for r in samplesheet.itertuples()
}

# %%
samplesheet

# %% [markdown]
# Things are reproducible on the same CPU generation, with the same number of cores, but that's about it

# %%
npt.assert_almost_equal(adatas[9].obsm["X_scVI"], adatas[4].obsm["X_scVI"])

# %% [markdown]
# Same CPU, different number of cores:

# %%
npt.assert_almost_equal(adatas[2].obsm["X_scVI"], adatas[3].obsm["X_scVI"])

# %% [markdown]
# Same number of cores, different CPUs

# %%
npt.assert_almost_equal(adatas[3].obsm["X_scVI"], adatas[4].obsm["X_scVI"])

# %% [markdown]
# And while the values are correlated, they
