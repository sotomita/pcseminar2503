! 2025年PCゼミ #3　"2次元熱伝導方程式をFortranで解く"
! 数値積分プログラム

program solve_heateq
    use netcdf  ! NetCDFモジュールを読む
    implicit none   ! 暗黙の型変換は行わない

    ! === 宣言文

    integer nx, ny      ! x,y方向の次元
    integer nt          ! 計算する時間ステップ数
    integer skipt       ! 何ステップおきに保存するか
    integer len_time    ! 保存する時刻の次元
    real(8) dh          ! 水平方向の刻み幅(=dx=dy)
    real(8) dt          ! 時間方向の刻み幅
    real(8) kappa       ! 熱伝導率
    real(8), allocatable    ::  u0(:,:)     ! iステップ目の温度
    real(8), allocatable    ::  u1(:,:)     ! (i+1)ステップ目の温度
    real(8), allocatable    ::  frcng(:,:)  ! 強制項(加熱)
    real(8), allocatable :: x(:)    ! x座標保存用の配列
    real(8), allocatable :: y(:)    ! y座標保存用の配列
    real(8), allocatable :: time(:) ! 時刻保存用の配列
    integer i,j,t       ! カウンタ変数

    ! NetCDFファイル関連
    character(len=256) init_fpath       ! 初期値のNetCDFファイルのファイルパス
    character(len=256) forcing_fpath    ! 強制項(熱源)のNetCDFファイルのファイルパス
    character(len=256) output_fpath     ! 計算結果を保存するNetCDFファイルのファイルパス
    integer ncid        ! NetCDF ID保存用
    integer varid       ! 変数ID 保存用
    integer x_dimid     ! x次元 ID保存用
    integer y_dimid     ! y次元 ID保存用
    integer t_dimid     ! t次元 ID保存用
    integer status      ! エラーコード保存用

    ! === 宣言文(ここまで)

    ! === 実行文    

    ! 設定ファイル"config.txt"を読む
    call read_config_heateq('config.txt', nx, ny, nt, skipt, kappa, dt, init_fpath, output_fpath,forcing_fpath)
    
    dh = 1.0/dble(nx)   ! 水平方向の刻み幅(x,y方向の長さは1とする)
    len_time = nt/skipt ! 保存する時間ステップ数

    ! 配列の割り付け
    allocate(u0(nx,ny),u1(nx,ny),x(nx),y(ny),time(len_time))

    ! 時刻を計算
    time(1) = 0
    do t = 2,len_time
        time(t) = dt*dble(skipt)*dble(t)
    enddo

    ! 初期値を読む
    status = nf90_open(init_fpath,nf90_nowrite,ncid)    ! NetCDF IDを割り振る
    status = nf90_inq_varid(ncid,"x",varid)             ! 次元IDを割り振る
    status = nf90_get_var(ncid,varid,x)                 ! 次元変数xを読む
    status = nf90_inq_varid(ncid,"y",varid)             ! 次元IDを割り振る
    status = nf90_get_var(ncid,varid,y)                 ! 次元変数yを読む
    status = nf90_inq_varid(ncid,"u",varid)             ! 変数IDを割り振る
    status = nf90_get_var(ncid,varid,u0)                ! 変数uを読む
    status = nf90_close(ncid)                           ! 初期値NetCDFファイルを閉じる

    ! 強制項を読む
    status = nf90_open(forcing_fpath,nf90_nowrite,ncid) ! NetCDF IDを割り振る
    status = nf90_inq_varid(ncid,"q",varid)             ! 変数IDを割り振る
    status = nf90_get_var(ncid,varid,frcng)                ! 変数uを読む
    status = nf90_close(ncid)                           ! 強制項NetCDFファイルを閉じる


    ! 保存用NetCDFファイルを作成
    status = nf90_create(output_fpath,ior(nf90_netcdf4,nf90_clobber),ncid)
    ! 次元の定義
    status = nf90_def_dim(ncid, "t", nf90_unlimited, t_dimid)   ! 時刻tを無制限次元とする
    status = nf90_def_dim(ncid, "x", nx, x_dimid)
    status = nf90_def_dim(ncid, "y", ny, y_dimid)
    ! 次元変数を定義，値を代入
    status = nf90_def_var(ncid, "t", nf90_double, (/t_dimid/), varid)
    status = nf90_put_var(ncid,varid,time)
    status = nf90_def_var(ncid, "x", nf90_double, (/x_dimid/), varid)
    status = nf90_put_var(ncid, varid, x)
    status = nf90_def_var(ncid, "y", nf90_double, (/y_dimid/), varid)
    status = nf90_put_var(ncid, varid, y)

    ! 変数を定義
    status = nf90_def_var(ncid,"u",nf90_double,(/x_dimid,y_dimid,t_dimid/),varid)
    ! 定義モード終了
    status = nf90_enddef(ncid)

    ! 初期値を代入
    status = nf90_put_var(ncid,varid,u0,start=[1,1,1],count=[nx,ny,1])

    ! 時間積分
    do t = 1,nt     ! 時間ループ      
        do j = 2,ny-1   ! y方向のループ
            do i = 2,nx-1   ! x方向のループ
                ! 時間方向は前進Euler法，空間方向は中心差分で離散化し，時間積分する
                u1(i,j) = u0(i,j) + (dt/dh**2)*(u0(i-1,j)+u0(i+1,j)+u0(i,j-1)+u0(i,j+1)-4.0d0*u0(i,j))
            enddo
        enddo        

        ! 境界条件を代入(Dirichlet境界条件，端点はすべて0)
        u1(1,:) = 0.0d0
        u1(nx,:) = 0.0d0
        u1(:,1) = 0.0d0
        u1(:,ny) = 0.0d0

        ! skip_tステップごとにNetCDFファイルに保存
        if (mod(t,skipt) == 0) then
            write(*,*)'t:',t,'/',nt ! 標準出力(ターミナル画面)に現在のステップ数を表示
            
            ! NetCDFファイルに新しいuを追加
            status = nf90_put_var(ncid,varid,u1,start=[1,1,t/skipt],count=[nx,ny,1])
        endif       

        ! u0を更新
        u0 = u1
    enddo

    ! 保存用NetCDFファイルを閉じる
    status = nf90_close(ncid)

    ! 配列の割り付け解除
    deallocate(u0,u1,x,y,time)

end program solve_heateq