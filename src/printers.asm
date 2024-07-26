print_menu:
    mov eax, SYS_WRITE
    mov edi, STDOUT
    mov rsi, s_menu ; movabs
    mov edx, l_menu ; mov edx, 0x33
    syscall ; sys_write(1, s_end, l_end)
    ret

print_received_bytes:
    push rax
    push rdi
    push rsi
    push rdx

    mov eax, SYS_WRITE
    mov edi, STDOUT
    mov rsi, s_received_bytes
    mov edx, l_received_bytes
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

print_blocking_read:
    push rax
    push rdi
    push rsi
    push rdx

    mov eax, SYS_WRITE
    mov edi, STDOUT
    mov rsi, s_blocking_read
    mov edx, l_blocking_read
    syscall ; sys_write(1, s_blocking_read, l_blocking_read)

    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

print_dbg_fd:
    ; print_dbg_fd
    ;
    ; prints "got file descriptor: "
    ; there is no new line and no
    ; actual file descriptor being printed
    push rax
    push rdi
    push rsi
    push rdx

    mov rsi, s_got_file_desc ; movabs
    mov eax, SYS_WRITE
    mov edi, STDOUT
    mov edx, l_got_file_desc ; mov edx, 0x15
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret
