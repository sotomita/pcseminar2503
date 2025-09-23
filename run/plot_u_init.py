#! /usr/bin/env python3

import os
import xarray as xr
import matplotlib.pyplot as plt

data_fpath = "./data/init.nc"
fig_dir = "./fig/init"


os.makedirs(fig_dir, exist_ok=True)
ds = xr.open_dataset(data_fpath)
print(ds)

fig, ax = plt.subplots(1, 1)
ax.set_title(f"initial u")
ax.set_xlabel("x")
ax.set_ylabel("y")

cf = ax.pcolormesh(ds["x"], ds["y"], ds["u"], vmin=-1, vmax=1, cmap="bwr")

plt.colorbar(cf)
plt.savefig(f"{fig_dir}/init.png")
plt.close()
