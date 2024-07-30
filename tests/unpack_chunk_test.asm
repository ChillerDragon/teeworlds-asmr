%include "tests/assert.asm"
%include "src/chunk_unpacker.asm"

_start:
    assert_input_buf_reset
    assert_input_buf_push_byte 0x40
    assert_input_buf_push_byte 0x02
    assert_input_buf_push_byte 0x05

    mov rax, assert_input_buf
    call unpack_chunk_header

    mov rax, 0
    mov al, [chunk_header_flags]
    assert_al_eq 0x40

    is_rax_flag CHUNKFLAG_VITAL
    assert_is_true

    mov eax, [chunk_header_size]
    assert_al_eq 0x02

    mov eax, [chunk_header_sequence]
    assert_al_eq 0x05

    exit 0
