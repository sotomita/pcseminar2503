#! /usr/bin/env python3

import os
import xarray as xr
import matplotlib.pyplot as plt

fig_dir = "./fig/init"
fpath = "./data/init.nc"

os.makedirs(fig_dir, exist_ok=True)
ds = xr.open_dataset(fpath)
print(ds)

fig, ax = plt.subplots(1, 1)
cf = ax.pcolormesh(ds["u"])
plt.colorbar(cf)
plt.savefig(f"{fig_dir}/init.png")
plt.close()
