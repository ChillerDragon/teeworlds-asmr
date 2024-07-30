; exit [exit code]
%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro

; nanosleep [nanoseconds]
%macro nanosleep 1
    ; struct timespec {
    ;     time_t tv_sec;        /* seconds */
    ;     long   tv_nsec;       /* nanoseconds */
    ; };

    ; > sizeof(time_t)
    ; (size_t)8
    ; > sizeof(long)
    ; (size_t)8

    ; zero 8 byte seconds field
    mov r9, 0
    mov [generic_buffer_512], r9

    ; set 8 byte nanoseconds
    mov qword [generic_buffer_512 + 8], %1

    mov rax, SYS_NANOSLEEP
    mov rdi, generic_buffer_512
    mov rsi, generic_buffer_512
    syscall
%endmacro

