%include "tests/assert.asm"

_start:
    init_test __FILE__

test_vital_seq3_siz23:
    assert_input_buf_reset
    assert_input_buf_push_byte 0x41
    assert_input_buf_push_byte 0x07
    assert_input_buf_push_byte 0x03

    mov rax, assert_input_buf
    call unpack_chunk_header6

    mov rax, 0
    mov al, [chunk_header_flags]
    assert_al_eq 0x40, __LINE__

    is_rax_flag CHUNKFLAG_VITAL
    assert_is_true __LINE__

    is_rax_flag CHUNKFLAG_RESEND
    assert_is_false __LINE__

    mov eax, [chunk_header_size]
    assert_al_eq 23, __LINE__

    mov eax, [chunk_header_sequence]
    assert_al_eq 3, __LINE__

    end_test __LINE__
