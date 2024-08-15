%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_div_10_by_5:
    ; clear dividend remainder thing
    mov rdx, 0

    ; dividend
    mov eax, 10

    ; divisor
    mov ecx, 5

    div ecx

    ; result is stored in eax (always)
    ; remainder is stored in edx (always)
    assert_eax_eq 2, __LINE__
    mov eax, edx
    assert_eax_eq 0, __LINE__

_test_div_10_by_8:
    ; clear dividend remainder thing
    mov rdx, 0

    ; dividend
    mov eax, 10

    ; divisor
    mov ecx, 8

    div ecx

    ; result is stored in eax (always)
    ; remainder is stored in edx (always)
    assert_eax_eq 1, __LINE__
    mov eax, edx
    assert_eax_eq 2, __LINE__

_test_div_macro:
    div32_to_rax 10, 5
    assert_eax_eq 2, __LINE__

    div32_to_rax 10, 8
    assert_eax_eq 1, __LINE__

    div32_to_rax 100, 10
    assert_eax_eq 10, __LINE__

    mov rax, 100
    mov rcx, 10
    div32_to_rax eax, ecx
    assert_eax_eq 10, __LINE__

    exit 0

