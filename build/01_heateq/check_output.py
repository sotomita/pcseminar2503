#! /usr/bin/env python3

import sys
import os
import xarray as xr
import matplotlib.pyplot as plt
from tqdm import tqdm

valid_t = int(sys.argv[1])


fig_dir = "./fig/output"
fpath = "./output.nc"
ds = xr.open_dataset(fpath)
print(ds)

os.makedirs(fig_dir, exist_ok=True)

for valid_t in tqdm(range(0, len(ds.t), 1)):
    fig, ax = plt.subplots(1, 1)
    cf = ax.pcolormesh(ds["u"].isel(t=valid_t), vmin=-1, vmax=1)
    plt.colorbar(cf)
    plt.savefig(f"{fig_dir}/output_{valid_t:04}.png")
    plt.close()
