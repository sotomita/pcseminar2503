subroutine read_config_heateq(config_path, nx, ny, nt, skipt, kappa, dt, init_fpath, output_fpath,forcing_fpath)
    implicit none
    character(len=*), intent(in)  :: config_path
    integer, intent(out)           :: nx, ny, nt, skipt
    real(8), intent(out)           :: kappa, dt
    character(len=256), intent(out):: init_fpath, output_fpath, forcing_fpath

    character(len=256) :: line, key, value
    integer :: ios, iunit

    open(newunit=iunit, file=config_path, status='old', action='read')

    do
        read(iunit,'(A)', iostat=ios) line
        if (ios /= 0) exit  ! EOF

        if (index(line,'=') > 0) then
            key = adjustl(trim(line(1:index(line,'=')-1)))
            value = adjustl(trim(line(index(line,'=')+1:)))

            select case (trim(key))
                case ('nx')
                    read(value,*) nx
                case ('ny')
                    read(value,*) ny
                case ('nt')
                    read(value,*) nt
                case ('skipt')
                    read(value,*) skipt
                case ('kappa')
                    read(value,*) kappa
                case ('dt')
                    read(value,*) dt
                case ('init_fpath')
                    init_fpath = trim(value)
                case ('output_fpath')
                    output_fpath = trim(value)
                case ('forcing_fpath')
                    forcing_fpath = trim(value)
            end select
        end if
    end do

    close(iunit)
end subroutine read_config_heateq