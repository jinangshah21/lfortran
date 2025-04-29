program test_stdin
    use iso_c_binding
    implicit none
    character(len=20) :: a
    integer :: istty
    logical :: is_gfortran = .false.

    interface
        function isatty(fd) bind(C)
            import :: c_int
            integer(c_int), value :: fd
            integer(c_int) :: isatty
        end function
    end interface

#ifdef __GFORTRAN__
    is_gfortran = .true.
#endif

    istty = isatty(0_c_int)

    if (istty == 1) then
        if (is_gfortran) then
            call execute_command_line("gfortran ./integration_tests/formatted_read_1.f90 &&" // &
            "./a.out < ./integration_tests/formatted_read_1.f90")
        else
            call execute_command_line("./src/bin/lfortran --cpp ./integration_tests/formatted_read_1.f90 " // &
            "< ./integration_tests/formatted_read_1.f90")
        end if
        stop
    else
        ! If not interactive, read from stdin
        read(*, '(a)') a
        print *, "From stdin:", trim(a)
        if (a /= "program test_stdin") error stop
    end if
end program