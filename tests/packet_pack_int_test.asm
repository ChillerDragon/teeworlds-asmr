%include "tests/assert.asm"

_start:
    init_test __FILE__

    call packet_packer_reset
    packet_packer_pack_int 01
    packet_packer_pack_int 01
    packet_packer_pack_int 01
    packet_packer_pack_int 02
    packet_packer_pack_int 64
    packet_packer_pack_int -1
    packet_packer_pack_int 2
    mov eax, 0
    packet_packer_pack_int eax
    mov eax, 1
    packet_packer_pack_int eax
    mov r9d, 9
    packet_packer_pack_int r9d
    mov r9d, 2
    packet_packer_pack_int r9d

    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 0]
    assert_al_eq 0x01, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 1]
    assert_al_eq 0x01, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 2]
    assert_al_eq 0x01, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 3]
    assert_al_eq 0x02, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 4]
    assert_al_eq 0x80, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 5]
    assert_al_eq 0x01, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 6]
    assert_al_eq 0x40, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 7]
    assert_al_eq 0x02, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 8]
    assert_al_eq 0x00, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 9]
    assert_al_eq 0x01, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 10]
    assert_al_eq 0x09, __LINE__
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 11]
    assert_al_eq 0x02, __LINE__

    end_test __LINE__

