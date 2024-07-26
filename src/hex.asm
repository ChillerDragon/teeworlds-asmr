print_hexdump:
    ; print_hexdump [rax] [rdi]
    ;   rax: pointer to data
    ;   rdi: data size
    push rsi
    push rcx
    push rbx
    push rdx
    push rdi
    push r9

    mov r9, rax ; r9 = data
    mov rcx, 0
.print_udp_loop_bytes:
    mov rax, [r9+rcx*1] ; r9 = data
    call print_hex_byte
    inc rcx
    cmp rcx, rdi
    jb .print_udp_loop_bytes

    pop r9
    pop rdi
    pop rdx
    pop rbx
    pop rcx
    pop rsi
    ret

hex_to_char:
    ; hex_to_char [rax]
    ;
    ; moves byte in `rax` as hex string into
    ; the `hex_str` variable
    ; https://stackoverflow.com/a/18879886/6287070
    push rbx
    push rax
    mov rbx, HEX_TABLE

    mov ah, al
    shr al, 4
    and ah, 0x0f
    xlat
    xchg ah, al
    xlat

    mov rbx, hex_str
    xchg ah, al
    mov [rbx], rax

    pop rax
    pop rbx
    ret

print_hex_byte:
    ; print_hex [rax]
    ;
    ; prints given arg as hex string
    ; to stdout
    push rax
    push rdi
    push rsi
    push rdx
    push rcx

    call hex_to_char

    mov eax, SYS_WRITE
    mov edi, STDOUT
    mov rsi, hex_str ; movabs
    mov edx, 0x2
    syscall

    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

