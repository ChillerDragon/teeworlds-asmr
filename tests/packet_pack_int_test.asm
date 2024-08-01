%include "tests/assert.asm"

_start:
    packet_packer_reset
    packet_packer_pack_int 01
    packet_packer_pack_int 01
    packet_packer_pack_int 01
    packet_packer_pack_int 02
    packet_packer_pack_int 64
    packet_packer_pack_int -1
    packet_packer_pack_int 2

    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 0]
    assert_al_eq 0x01
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 1]
    assert_al_eq 0x01
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 2]
    assert_al_eq 0x01
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 3]
    assert_al_eq 0x02
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 4]
    assert_al_eq 0x80
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 5]
    assert_al_eq 0x01
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 6]
    assert_al_eq 0x40
    mov byte al, [udp_send_buf + PACKET_HEADER_LEN + 7]
    assert_al_eq 0x02

    exit 0

