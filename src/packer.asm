; push bytes into a packer buffer
; you can also push bytes directly into
; the udp buffer see packet.asm for that

%macro packer_reset 0
    mov dword [packer_size], 0
%endmacro

; prints something like this
; [packer] amount of bytes packed: 2
%macro packer_print_size 0
    push rax

    print s_packer_size

    mov eax, [packer_size]
    call print_uint32
    call print_newline

    pop rax
%endmacro

; pack_raw [buffer] [buffer size]
%macro pack_raw 2
    push rax
    push rdx
    push rdi
    push rsi

    ; copy dest
    mov dword edx, [packer_size]
    lea rax, [packer_buf + edx]
    ; copy source
    mov rdi, %1
    ; copy size
    mov rsi, %2
    call mem_copy

    add dword [packer_size], %2

    pop rsi
    pop rdi
    pop rdx
    pop rax
%endmacro

%macro pack_byte 1
    push rax
    push rdx
    push rdi
    push rcx

    mov dword edx, [packer_size]
    lea rdi, [packer_buf + edx]
    mov byte [rdi], %1

    ; increment payload index by bytes packed
    inc edx
    mov dword [packer_size], edx

    pop rcx
    pop rdi
    pop rdx
    pop rax
%endmacro

%macro pack_str 1
    ; pack_str [null terminated buffer]
    push rax
    push rdi
    push rdx

    ; rax = destination buffer pointer
    mov dword edx, [packer_size]
    lea rax, [packer_buf + edx]

    ; rdi = source buffer pointer
    mov rdi, %1

    ; rsi = truncation len (max size)
    ; todo: this should be
    ; packer buffer size - packer size written
    mov rsi, 2048

    call str_copy

    ; increment size by copied bytes
    mov dword edx, [packer_size]
    ; str_copy returned size written into eax
    add edx, eax
    mov dword [packer_size], edx

    ; null terminator
    pack_byte 0x00

    pop rdx
    pop rdi
    pop rax
%endmacro

%macro pack_int 1
    push rax
    push rdi
    push rdx

    mov rax, %1
    mov dword edx, [packer_size]
    lea rdi, [packer_buf + edx]
    call _pack_int

    ; increment payload index by bytes packed
    sub rax, rdi
    add edx, eax
    mov [packer_size], edx

    pop rdx
    pop rdi
    pop rax
%endmacro
