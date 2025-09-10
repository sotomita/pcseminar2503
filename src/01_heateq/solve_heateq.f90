program solve_heateq
    use netcdf
    implicit none
    integer :: nx, ny, nt,skipt,len_time
    real(8) dh,dt,kappa
    real(8),    allocatable ::  u0(:,:),u1(:,:),x(:),y(:),time(:)
    integer i,j,t
    character(len=256) :: init_fpath,output_fpath,forcing_fpath
    integer ncid,varid,status,x_dimid,y_dimid,t_dimid

    call read_config_heat_eq('config.txt', nx, ny, nt, skipt, kappa, dt, init_fpath, output_fpath,forcing_fpath)
    !nx = 300
    !ny = 200
    !nt = 10000
    !skipt = 1000
    !kappa = 1.0d0
    !dt = 1.0d-6
    !init_fpath = './init.nc'
    !output_fpath = './output.nc'
    
    dh = 1.0/dble(nx)
    len_time = nt/skipt

    allocate(u0(nx,ny),u1(nx,ny),x(nx),y(ny),time(len_time))
    time(1) = 0
    do t = 2,len_time
        time(t) = dt*dble(skipt)*dble(t)
    enddo

    ! read initial values
    status = nf90_open(init_fpath,nf90_nowrite,ncid)
    status = nf90_inq_varid(ncid,"x",varid)
    status = nf90_get_var(ncid,varid,x)
    status = nf90_inq_varid(ncid,"y",varid)
    status = nf90_get_var(ncid,varid,y)
    status = nf90_inq_varid(ncid,"u",varid)
    status = nf90_get_var(ncid,varid,u0)
    status = nf90_close(ncid)

    status = nf90_create(output_fpath,ior(nf90_netcdf4,nf90_clobber),ncid)
    status = nf90_def_dim(ncid, "t", nf90_unlimited, t_dimid)
    status = nf90_def_dim(ncid, "x", nx, x_dimid)
    status = nf90_def_dim(ncid, "y", ny, y_dimid)
    status = nf90_def_var(ncid, "t", nf90_double, (/t_dimid/), varid)
    status = nf90_put_var(ncid,varid,time)
    status = nf90_def_var(ncid, "x", nf90_double, (/x_dimid/), varid)
    status = nf90_put_var(ncid, varid, x)
    status = nf90_def_var(ncid, "y", nf90_double, (/y_dimid/), varid)
    status = nf90_put_var(ncid, varid, y)
    status = nf90_def_var(ncid,"u",nf90_double,(/x_dimid,y_dimid,t_dimid/),varid)
    status = nf90_enddef(ncid)

    status = nf90_put_var(ncid,varid,u0,start=[1,1,1],count=[nx,ny,1])

    ! update
    do t = 1,nt              
        do j = 2,ny-1
            do i = 2,nx-1
                u1(i,j) = u0(i,j) + (dt/dh**2)*(u0(i-1,j)+u0(i+1,j)+u0(i,j-1)+u0(i,j+1)-4.0d0*u0(i,j))
            enddo
        enddo        

        ! boundary
        u1(1,:) = 0.0d0
        u1(nx,:) = 0.0d0
        u1(:,1) = 0.0d0
        u1(:,ny) = 0.0d0

        if (mod(t,skipt) == 0) then
            write(*,*)'t:',t,'/',nt
            status = nf90_put_var(ncid,varid,u1,start=[1,1,t/skipt],count=[nx,ny,1])
        endif       

        u0 = u1

    enddo

    status = nf90_close(ncid)
    deallocate(u0,u1)

end program solve_heateq