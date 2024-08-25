%include "tests/assert.asm"

section .data
    sockaddr_localhost_8303 dw AF_INET ; 0x2 0x00
                db 0x20, 0x6f ; port 8303
                db 0x7f, 0x0, 0x0, 0x01 ; 127.0.0.1
                db 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 ; watafk is this?!
section .text

_start:
    init_test __FILE__

_test_sockaddr_to_str:
    ; sockaddr_to_str [rax] [rdi]
    ;  rax = pointer to sockaddr struct
    ;  rdi = output buffer

    mov rax, sockaddr_localhost_8303
    mov rdi, generic_buffer_512
    call sockaddr_to_str

    str_to_stack "127.0.0.1:8303"
    ; rax is set by str_to_stack
    ; rdi is still generic_buffer_512
    assert_str_eq rax, rdi, __LINE__
    mov rsp, rbp

_test_str_to_sockaddr:
    ; str_to_sockaddr [rax] [rdi]
    ;  rax = input string in the format "127.0.0.1:8303"
    ;  rdi = output buffer for sockaddr struct
    str_to_stack "127.0.0.1:8303"
    ; rax is set by str_to_stack
    mov rdi, generic_buffer_512
    call str_to_sockaddr
    mov rsp, rbp

    assert_mem_eq sockaddr_localhost_8303, generic_buffer_512, SOCKADDR_SIZE, __LINE__

    end_test __LINE__

