%include "tests/assert.asm"
%include "src/chunks.asm"

_start:
    mov dword [connection_sequence], 9

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 6
    mov rsi, assert_actual_buf
    call pack_chunk_header

    mov al, [assert_actual_buf]
    assert_al_eq 0x40
    mov al, [assert_actual_buf + 1]
    assert_al_eq 0x06
    mov al, [assert_actual_buf + 2]
    assert_al_eq 0x09
    exit 0

