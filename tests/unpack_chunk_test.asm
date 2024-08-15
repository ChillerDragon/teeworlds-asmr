%include "tests/assert.asm"

_start:
    init_test __FILE__

test_vital_low_seq_and_size:
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

test_vital_size_3_seq_201:
    assert_input_buf_reset
    assert_input_buf_push_byte 0x40
    assert_input_buf_push_byte 0x03
    assert_input_buf_push_byte 0xC9

    mov rax, assert_input_buf
    call unpack_chunk_header

    mov rax, 0
    mov al, [chunk_header_flags]
    assert_al_eq 0x40

    is_rax_flag CHUNKFLAG_VITAL
    assert_is_true

    mov eax, [chunk_header_size]
    assert_al_eq 3

    mov eax, [chunk_header_sequence]
    assert_al_eq 201

test_vital_size_58_seq_1:
    assert_input_buf_reset
    assert_input_buf_push_byte 0x40
    assert_input_buf_push_byte 0x3a
    assert_input_buf_push_byte 0x01

    mov rax, assert_input_buf
    call unpack_chunk_header

    mov rax, 0
    mov al, [chunk_header_flags]
    assert_al_eq 0x40

    is_rax_flag CHUNKFLAG_VITAL
    assert_is_true

    mov eax, [chunk_header_size]
    assert_al_eq 58

    mov eax, [chunk_header_sequence]
    assert_al_eq 1

test_vital_maxed_all_set_size_4095_seq_1023:
    assert_input_buf_reset
    assert_input_buf_push_byte 0xFF
    assert_input_buf_push_byte 0xFF
    assert_input_buf_push_byte 0xFF

    mov rax, assert_input_buf
    call unpack_chunk_header

    mov rax, 0
    mov al, [chunk_header_flags]
    assert_al_eq 0xC0

    is_rax_flag CHUNKFLAG_VITAL
    assert_is_true

    mov eax, [chunk_header_size]
    assert_eax_eq 4095, __LINE__

    mov eax, [chunk_header_sequence]
    assert_eax_eq 1023, __LINE__

    exit 0
