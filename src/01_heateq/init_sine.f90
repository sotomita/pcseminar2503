program init_sine
    use netcdf
    implicit none
    integer :: nx, ny, kx, ky, i, j
    real(8) :: amp, pi
    real(8), allocatable :: u(:,:), x(:), y(:)
    character(len=256) :: input_fpath

    nx = 300
    ny = 200
    kx = 3
    ky = 2
    amp = 1.0
    pi = 4.0d0*atan(1.0d0)

    input_fpath = './input.nc'

    allocate(u(nx,ny), x(nx), y(ny))

    do j = 1, ny
        do i = 1, nx
            u(i,j) = amp * sin(2.0d0*pi*kx*dble(i)/dble(nx)) * sin(2.0d0*pi*ky*dble(j)/dble(ny))
        end do
    end do

    
    do i = 1, nx
        x(i) = dble(i)
    end do
    do j = 1, ny
        y(j) = dble(j)
    end do

    ! NetCDFファイルを作成，定義モードに入る
    retval = nf90_create(input_fpath,NF90_CLOBBER,ncid)

    ! 次元の定義
    retval = nf90_def_dim(ncid, "x", nx, x_dimid)
    retval = nf90_def_dim(ncid, "y", ny, y_dimid)

    dimids = (/x_dimid, y_dimid/)

    ! 変数の定義
    retval = nf90_def_var(ncid, "x", NF90_DOUBLE, (/x_dimid/), varid)
    ! 変数に値を与える
    retval = nf90_put_var(ncid, varid, x)

    ! 変数の定義
    retval = nf90_def_var(ncid, "y", NF90_DOUBLE, (/y_dimid/), varid)
    ! 変数に値を与える
    retval = nf90_put_var(ncid, varid, y)

    ! 変数の定義
    retval = nf90_def_var(ncid, "u", NF90_DOUBLE, dimids, varid)
    ! 変数に値を与える
    retval = nf90_put_var(ncid, varid, u)

    ! NetCDFファイルを閉じる
    retval = nf90_close(ncid)

    deallocate(u, x, y)


end program init_sine
