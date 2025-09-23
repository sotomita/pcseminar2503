! 2025年PCゼミ #3　"2次元熱伝導方程式をFortranで解く"
! 初期値生成プログラム

program init_sine
    use netcdf  ! netcdfモジュールを読む
    implicit none   ! 暗黙の型変換は行わない

    ! === 宣言文

    integer nx, ny      ! x,y方向の次元
    integer kx,ky       ! x,y方向の波数
    real(8) dh          ! 水平方向の刻み幅(=dx=dy)
    real(8) amp         ! 初期値の振幅
    integer i,j         ! カウンタ変数
    real(8) pi          ! 円周率
    real(8), allocatable :: u(:,:)  ! 温度保存用の配列(動的割り付け可能な定義)
    real(8), allocatable :: x(:)    ! x座標保存用の配列(動的割り付け可能な定義)
    real(8), allocatable :: y(:)    ! y座標保存用の配列(動的割り付け可能な定義)
    
    ! NetCDFファイル関連
    character(len=256) :: init_fpath    ! 初期値を保存するNetCDFファイルのファイルパス
    integer ncid        ! NetCDF ID保存用
    integer varid       ! 変数ID 保存用
    integer x_dimid     ! x次元 ID保存用
    integer y_dimid     ! y次元 ID保存用
    integer status      ! エラーコード保存用

    ! === 宣言文(ここまで)

    ! === 実行文

    ! 実験設定
    nx = 240    ! x方向の次元
    ny = 240    ! y方向の次元
    kx = 1      ! x方向の波数
    ky = 2      ! y方向の波数
    amp = 1.0   ! 振幅
    pi = 4.0d0*atan(1.0d0)  !　円周率
    dh = 1.0/dble(nx-1)   ! 水平方向の刻み幅(x,y方向の長さは1とする)
    
    ! 配列の割り付け
    allocate(u(nx,ny), x(nx), y(ny))

    ! 初期値を計算
    do j = 1, ny
        do i = 1, nx
            u(i,j) = amp * sin(pi*dble(kx)*dble(i)/dble(nx)) * sin(pi*dble(ky)*dble(j)/dble(ny))
        end do
    end do
    
    ! 座標の定義
    do i = 1, nx
        x(i) = dble(i-1)*dh
    end do
    do j = 1, ny
        y(j) = dble(j-1)*dh
    end do

    
    
    init_fpath = './data/init.nc'    ! NetCDFファイルのファイルパス

    ! NetCDFファイルを作成，定義モードに入る
    status = nf90_create(init_fpath,ior(nf90_netcdf4,nf90_clobber),ncid)

    ! 次元の定義
    status = nf90_def_dim(ncid, "x", nx, x_dimid)
    status = nf90_def_dim(ncid, "y", ny, y_dimid)

    ! 次元変数xの定義
    status = nf90_def_var(ncid, "x", nf90_double, (/x_dimid/), varid)
    ! 代入
    status = nf90_put_var(ncid, varid, x)

    ! 次元変数yの定義
    status = nf90_def_var(ncid, "y", nf90_double, (/y_dimid/), varid)
    ! 代入
    status = nf90_put_var(ncid, varid, y)

    ! 変数uの定義
    status = nf90_def_var(ncid, "u", nf90_double,  (/x_dimid, y_dimid/), varid)
    ! 代入
    status = nf90_put_var(ncid, varid, u)

    ! NetCDFファイルを閉じる
    status = nf90_close(ncid)

    
    deallocate(u, x, y) ! 配列の割り付けを解除

    ! === 実行文(ここまで)
end program init_sine
