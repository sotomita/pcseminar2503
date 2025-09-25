#! /usr/bin/env python3

import os
import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
from tqdm import tqdm

a = np.arange()

fig_dir = "./fig/output"
fpath = "./data/output.nc"
ds = xr.open_dataset(fpath)
print(ds)

os.makedirs(fig_dir, exist_ok=True)

for t in tqdm(range(0, len(ds.t), 1)):
    fig, ax = plt.subplots(1, 1)
    ax.set_title(f"step[{t:4d}/{len(ds.t)-1:4d}] time={ds["t"].isel(t=t).values:.4f}")
    ax.set_xlabel("x")
    ax.set_ylabel("y")

    cf = ax.pcolormesh(ds["x"], ds["y"], ds["u"].isel(t=t), vmin=0, vmax=2, cmap="hot_r")

    plt.colorbar(cf)
    plt.savefig(f"{fig_dir}/output_{t:04}.png")
    plt.close()
