insane_console:
    ; fetch the current terminal settings
    mov eax, 0x10 ; __NR_ioctl
    mov edi, 0x0 ; fd: stdin
    mov esi, 0x5401 ; cmd: TCGETS
    mov rdx, tty_orig ; arg: the buffer, orig
    syscall
    ; agian, but this time for the 'new' buffer
    mov rax, 0x10
    mov rdi, 0x0
    mov rsi, 0x5401
    mov rdx, tty_new
    syscall
    ; change settings
    ; ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON)
    and dword [tty_new+0], 0xfffffa14 ; -1516
    ; ~OPOST
    and dword [tty_new+4], 0xfffffffe ; -2
    ; ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN)
    and dword [tty_new+12], 0xffff7fb4 ; -32844
    ; ~(CSIZE | PARENB)
    and dword [tty_new+8], 0xfffffecf ; -305
    ; set settings (with ioctl again)
    mov rax, 0x10 ; __NR_ioctl
    mov rdi, 0x0 ; fd: stdin
    mov rsi, 0x5402 ; cmd: TCSETS
    mov rdx, tty_new ; arg: the buffer, new
    syscall
    ret

sane_console:
    ; reset settings (with ioctl again)
    mov rax, 0x10 ; __NR_ioctl
    mov rdi, 0x0 ; fd: stdin
    mov rsi, 0x5402 ; cmd: TCSETS
    mov rdx, tty_orig ; arg: the buffer, orig
    syscall
    ret
