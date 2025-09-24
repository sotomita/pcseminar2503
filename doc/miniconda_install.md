# Miniconda環境の構築
出力を描画するPythonスクリプトを実行する環境の構築例．

## Minicondaのインストール
[Anacondaのダウンロードページ](https://www.anaconda.com/download/success)からLinux向け・64bit-x86 Installerをダウンロードする．
```
$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda_Installer.sh
```
インストーラをbatchモードで実行する．
```
$ bash Miniconda_Installer.sh -bp path_to_install_dir
```
インストールが完了したら作業ディレクトリ直下に```miniconda3```ディレクトリが生成されている．
.bashrcファイルをsourceする．
```
$ . ~/.bashrc
```
## ゼミ用仮想環境を作成
仮想環境```pcseminar2503```を作成する．
```
$ conda create -n pcseminar2503 python=3.13 -y
```
仮想環境を有効化する．
```
$ conda activate pcseminar2503
```
Pythonスクリプト実行に必要なライブラリを導入する．
```
$ conda install -c conda-forge numpy xarray matplotlib tqdm
```
また必要があれば，GNU Fortranコンパイラ，NetCDF-Fortranも導入する．
```
$ conda install -c conda-forge gfortran netcdf-fortran
```
