; vim: set tabstop=4:softtabstop=4:shiftwidth=4
; vim: set expandtab:

print_newline:
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, NEWLINE
    mov rdx, 1
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

