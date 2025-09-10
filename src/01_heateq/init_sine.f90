program init_sine
    use netcdf
    implicit none
    integer :: nx, ny, kx, ky, i, j
    real(8) :: amp, pi
    real(8), allocatable :: u(:,:), x(:), y(:)
    character(len=256) :: init_fpath
    integer ncid,varid,x_dimid,y_dimid,status

    nx = 300
    ny = 200
    kx = 1
    ky = 2
    amp = 1.0
    pi = 4.0d0*atan(1.0d0)



    init_fpath = './init.nc'

    allocate(u(nx,ny), x(nx), y(ny))

    do j = 1, ny
        do i = 1, nx
            u(i,j) = amp * sin(pi*dble(kx)*dble(i)/dble(nx)) * sin(pi*dble(ky)*dble(j)/dble(ny))
        end do
    end do

    
    ! 座標の定義
    do i = 1, nx
        x(i) = dble(i)
    end do
    do j = 1, ny
        y(j) = dble(j)
    end do

    ! NetCDFファイルを作成，定義モードに入る
    status = nf90_create(init_fpath,ior(nf90_netcdf4,nf90_clobber),ncid)

    ! 次元の定義
    status = nf90_def_dim(ncid, "x", nx, x_dimid)
    status = nf90_def_dim(ncid, "y", ny, y_dimid)



    ! 変数の定義
    status = nf90_def_var(ncid, "x", nf90_double, (/x_dimid/), varid)
    ! 変数に値を与える
    status = nf90_put_var(ncid, varid, x)

    ! 変数の定義
    status = nf90_def_var(ncid, "y", nf90_double, (/y_dimid/), varid)
    ! 変数に値を与える
    status = nf90_put_var(ncid, varid, y)

    ! 変数の定義
    status = nf90_def_var(ncid, "u", nf90_double,  (/x_dimid, y_dimid/), varid)
    ! 変数に値を与える
    status = nf90_put_var(ncid, varid, u)

    ! NetCDFファイルを閉じる
    status = nf90_close(ncid)

    deallocate(u, x, y)


end program init_sine
