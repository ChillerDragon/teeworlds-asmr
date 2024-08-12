%include "tests/assert.asm"

_start:
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
    assert_eax_eq 2
    mov eax, edx
    assert_eax_eq 0

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
    assert_eax_eq 1
    mov eax, edx
    assert_eax_eq 2

    exit 0

