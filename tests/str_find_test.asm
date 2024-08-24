%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_str_find_letter_0:
    ; rax = string
    write_str_to_mem "hello", generic_buffer_128
    mov rax, generic_buffer_128
    ; rdi = search
    mov rdi, 'h'
    call str_find_char

    assert_eax_eq 0, __LINE__

_test_str_find_letter_1:
    ; rax = string
    write_str_to_mem "hello", generic_buffer_128
    mov rax, generic_buffer_128
    ; rdi = search
    mov rdi, 'e'
    call str_find_char

    assert_eax_eq 1, __LINE__

_test_str_find_letter_2:
    ; rax = string
    write_str_to_mem "hello", generic_buffer_128
    mov rax, generic_buffer_128
    ; rdi = search
    mov rdi, 'l'
    call str_find_char

    assert_eax_eq 2, __LINE__

_test_str_find_letter_last:
    ; rax = string
    write_str_to_mem "hello", generic_buffer_128
    mov rax, generic_buffer_128
    ; rdi = search
    mov rdi, 'o'
    call str_find_char

    assert_eax_eq 4, __LINE__

_test_str_find_letter_no_match:
    ; rax = string
    write_str_to_mem "hello", generic_buffer_128
    mov rax, generic_buffer_128
    ; rdi = search
    mov rdi, 'x'
    call str_find_char

    assert_eax_eq -1, __LINE__

    end_test __LINE__

