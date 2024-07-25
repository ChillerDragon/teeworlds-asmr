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
