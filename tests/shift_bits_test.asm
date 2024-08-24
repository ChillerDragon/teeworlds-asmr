%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_shift_left_0_0:
    mov rax, 0
    shift_left rax, 0
    assert_eax_eq 0, __LINE__

_test_shift_left_0_1:
    mov rax, 0
    shift_left rax, 1
    assert_eax_eq 0, __LINE__

_test_shift_left_1_0:
    mov rax, 1
    shift_left rax, 0
    assert_eax_eq 1, __LINE__

_test_shift_left_1_1:
    mov rax, 1
    shift_left rax, 1
    assert_eax_eq 2, __LINE__

_test_shift_left_1_2:
    mov rax, 1
    shift_left rax, 2
    assert_eax_eq 4, __LINE__

_test_shift_left_8_4:
    mov rax, 8
    shift_left rax, 4
    assert_eax_eq 128, __LINE__

_test_shift_left_64_8:
    mov rax, 64
    shift_left rax, 8
    assert_eax_eq 16384, __LINE__

_test_shift_left_128_24:
    mov rax, 128
    shift_left rax, 24
    assert_eax_eq 2147483648, __LINE__

    end_test __LINE__
