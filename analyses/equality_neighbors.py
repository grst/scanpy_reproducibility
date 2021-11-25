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
scvi_adatas = list(Path("../results/neighbors/").glob("*.h5ad"))

# %%
scvi_adatas


# %%
def make_df():
    for path in scvi_adatas:
        filename = path.stem
        dataset, rest, _ = filename.split(".")
        _, node, cpus = rest.split("_", maxsplit=3)
        yield dataset, node, cpus, str(path)

samplesheet = pd.DataFrame.from_records(make_df(), columns=["dataset", "node", "cpus", "adata_path"])

# %%
adatas = {
    r.Index: sc.read_h5ad(r.adata_path) for r in samplesheet.itertuples()
}

# %%
samplesheet.sort_values(["dataset", "node", "cpus"])

# %% [markdown]
# Things are reproducible on the same CPU generation...

# %%
npt.assert_almost_equal(adatas[15].obsp["connectivities"].toarray(), adatas[12].obsp["connectivities"].toarray())

# %% [markdown]
# ... on the same CPU, with different number of cores:

# %%
npt.assert_almost_equal(adatas[0].obsp["connectivities"].toarray(), adatas[15].obsp["connectivities"].toarray())

# %% [markdown]
# But not with the same number of cores on different CPU generations

# %%
npt.assert_almost_equal(adatas[0].obsp["connectivities"].toarray(), adatas[13].obsp["connectivities"].toarray())

# %% [markdown]
# But they are very similar:

# %%
npt.assert_almost_equal(adatas[0].obsp["connectivities"].toarray(), adatas[13].obsp["connectivities"].toarray(), decimal=5)

# %%
npt.assert_almost_equal(adatas[22].obsp["connectivities"].toarray(), adatas[4].obsp["connectivities"].toarray(), decimal=5)

# %%
npt.assert_almost_equal(adatas[7].obsp["connectivities"].toarray(), adatas[18].obsp["connectivities"].toarray(), decimal=5)

# %%
npt.assert_almost_equal(adatas[3].obsp["connectivities"].toarray(), adatas[2].obsp["connectivities"].toarray(), decimal=5)

# %%
