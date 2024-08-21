; bss section:
;
; unpacker_size resb 4
; unpacker_index resb 4
; unpacker_data resb 8

%macro unpacker_reset 2
    push rbp

    mov rbp, rsp
    sub rsp, 16
    mov qword [rbp-16], %1
    mov qword [rbp-8], %2

    mov rax, qword [rbp-16]
    mov rdi, qword [rbp-8]
    call _unpacker_reset

    pop rbp
%endmacro

_unpacker_reset:
    ; _unpacker_reset [rax] [rdi]
    ;  rax = input buffer
    ;  rdi = input size
    mov qword [unpacker_data], rax
    mov dword [unpacker_size], edi
    ret

get_int:
    ; get_int
    ; returns into rax the unpacked integer by value
    ret

get_string:
    ; get_string
    ; returns into rax a pointer to the string
    ret

get_raw:
    ; get_raw [rax]
    ;  rax = size
    ; returns into rax a pointer to the raw data
    ret

