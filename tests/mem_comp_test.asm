%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_mem_comp_match:
    ; mem_comp [rax] [rdi] [rsi]
    ;  rax = memory region a to compare
    ;  rdi = memory region b to compare
    ;  rsi = amount of bytes to compare
    ; returns boolean into zero flag
    ; "je" will jump if they match

    mov byte [generic_buffer_512+0], 0xff
    mov byte [generic_buffer_512+1], 0xaa

    mov byte [generic_buffer_16+0], 0xff
    mov byte [generic_buffer_16+1], 0xaa

    mov rax, generic_buffer_512
    mov rdi, generic_buffer_16
    mov rsi, 2
    call mem_comp
    assert_is_true __LINE__

_test_mem_comp_no_match:
    mov byte [generic_buffer_512+0], 0xaa
    mov byte [generic_buffer_512+1], 0xaa

    mov byte [generic_buffer_16+0], 0xff
    mov byte [generic_buffer_16+1], 0xaa

    mov rax, generic_buffer_512
    mov rdi, generic_buffer_16
    mov rsi, 2
    call mem_comp
    assert_is_false __LINE__

_test_assert_macro:

    mov byte [generic_buffer_512+0], 0xff
    mov byte [generic_buffer_512+1], 0xaa

    mov byte [generic_buffer_16+0], 0xff
    mov byte [generic_buffer_16+1], 0xaa

    assert_mem_eq generic_buffer_512, generic_buffer_16, 2, __LINE__

    end_test __LINE__

