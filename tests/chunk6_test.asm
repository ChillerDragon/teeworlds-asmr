%include "tests/assert.asm"

_start:
    init_test __FILE__

test_pack_chunk_header6_size23_seq3:
    mov dword [connection_sequence], 3

    ; tested with twnet_parser
    ; header: ChunkHeader = parser.parse_header6(b'\x41\x07\x03')
    ; assert header.flags.resend is False
    ; assert header.flags.vital is True
    ; assert header.size == 23
    ; assert header.seq == 3

    mov rax, 0
    set_rax_flag CHUNKFLAG_VITAL
    mov rdi, 23
    mov rsi, assert_actual_buf
    call pack_chunk_header6

    mov al, [assert_actual_buf]
    assert_al_eq 0x41, __LINE__
    mov al, [assert_actual_buf + 1]
    assert_al_eq 0x07, __LINE__
    mov al, [assert_actual_buf + 2]
    assert_al_eq 0x03, __LINE__


; test_pack_chunk_header6_size6_seq65:
;     mov dword [connection_sequence], 65
; 
;     ; tested with twnet_parser
;     ; header: ChunkHeader = parser.parse_header6(b'\x40\x16\x01')
;     ; assert header.flags.resend is False
;     ; assert header.flags.vital is True
;     ; assert header.size == 6
;     ; assert header.seq == 65
; 
;     mov rax, 0
;     set_rax_flag CHUNKFLAG_VITAL
;     mov rdi, 6
;     mov rsi, assert_actual_buf
;     call pack_chunk_header6
; 
;     mov al, [assert_actual_buf]
;     assert_al_eq 0x40, __LINE__
;     mov al, [assert_actual_buf + 1]
;     assert_al_eq 0x16, __LINE__
;     mov al, [assert_actual_buf + 2]
;     assert_al_eq 0x01, __LINE__

    end_test __LINE__
