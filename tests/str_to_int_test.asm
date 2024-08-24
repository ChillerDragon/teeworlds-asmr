%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_str_to_int_123:
    write_str_to_mem "123.", generic_buffer_128
    mov rax, generic_buffer_128
    call str_to_int_unsigned
    assert_eax_eq 123, __LINE__

_test_str_to_int_2:
    write_str_to_mem "2.", generic_buffer_128
    mov rax, generic_buffer_128
    call str_to_int_unsigned
    assert_eax_eq 2, __LINE__

    end_test __LINE__

