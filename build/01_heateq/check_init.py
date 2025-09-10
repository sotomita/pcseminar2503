#! /usr/bin/env python3

import xarray as xr
import matplotlib.pyplot as plt

fpath = "./init.nc"
ds = xr.open_dataset(fpath)
print(ds)

fig, ax = plt.subplots(1, 1)
cf = ax.pcolormesh(ds["u"])
plt.colorbar(cf)
plt.savefig("init.png")
plt.close()
