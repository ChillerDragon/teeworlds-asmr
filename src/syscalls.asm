; exit [exit code]
%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro

write_str_to_file:
    ; write_str_fo_file [rax] [rdi]
    ;  rax = file descriptor
    ;  rdi = null terminated string
    ;
    ; use `fopen` to get file descriptor
    push_registers

    ; file descriptor
    mov r9, rax
    ; string
    mov r10, rdi
    ; string length
    mov rax, rdi
    call str_length
    mov r11, rax

    mov rax, SYS_WRITE
    mov rdi, r9 ; fd
    mov rsi, r10 ; str
    mov rdx, r11 ; string length
    syscall

    pop_registers
    ret

fopen:
    ; fopen [rax] [rdi]
    ;  rax = pointer to filename
    ;  rdi = O_APPEND or 0
    ;
    ; returns into rax the file handle
    ;
    ; don't forget to call `close`
    ;
    ; example:
    ;
    ; mov rax, [label_with_str_filename]
    ; mov rdi, O_APPEND
    ; call fopen
    ; call close
    push_registers_keep_rax

    ; filename
    mov r9, rax
    ; flags
    mov r10, rdi

    mov rax, SYS_OPEN

    ; filename
    mov rdi, r9

    ; create file if is not there yet
    mov rsi, r10
    or rsi, O_RDWR
    or rsi, O_CREAT

    ; mode is determined by `umask`
    mov rdx, 0666o
    syscall

    pop_registers_keep_rax
    ret

close:
    ; close [rax]
    ;  rax = file descriptor
    push_registers

    mov r9, rax
    mov rax, SYS_CLOSE
    mov rdi, r9
    syscall

    pop_registers
    ret

time:
    ; time
    ;  returns into rax the current unix epoch
    push_registers_keep_rax
    mov rax, SYS_TIME
    mov rdi, 0x00
    syscall
    pop_registers_keep_rax
    ret


; nanosleep [nanoseconds]
%macro nanosleep 1
    push_registers

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

    pop_registers
%endmacro

