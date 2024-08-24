%include "tests/assert.asm"

test_message_callback:
    push_registers

    mov eax, [assert_counter]
    inc eax
    mov [assert_counter], eax

    pop_registers
    ret

_start:
    init_test __FILE__

test_madeup_chunks_with_one_byte_payload:
    ; prepare
    assert_input_buf_reset

    ; two hand crafted artificial vital chunks
    ; with only one byte payload

    mov byte [in_packet_header_num_chunks], 2

    ; chunk 1
    assert_input_buf_push_byte 0x40 ; flags (vitaL)
    assert_input_buf_push_byte 0x02 ; size
    assert_input_buf_push_byte 0x01 ; seq
    assert_input_buf_push_byte 0x06 ; msg id
    assert_input_buf_push_byte 0xFF ; payload
    ; chunk 2
    assert_input_buf_push_byte 0x40 ; flags (vitaL)
    assert_input_buf_push_byte 0x02 ; size
    assert_input_buf_push_byte 0x01 ; seq
    assert_input_buf_push_byte 0x07 ; msg id
    assert_input_buf_push_byte 0xFF ; payload

    mov dword [assert_counter], 0

    ;  rax = payload buffer
    mov rax, assert_input_buf
    ;  rdi = 8 byte payload size
    mov rdi, 8
    ;  rsi = chunk callback
    mov rsi, test_message_callback
    call on_system_or_game_messages

    mov rax, 0
    mov eax, dword [assert_counter]
    assert_eax_eq 2, __LINE__

    end_test __LINE__
