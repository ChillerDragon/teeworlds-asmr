%include "tests/assert.asm"

mov eax, 0xAABB
assert_eax_eq 0xAABB
exit 0

