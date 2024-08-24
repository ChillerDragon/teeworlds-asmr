%include "tests/assert.asm"

_start:
    init_test __FILE__

test_packer_macro_pack_two_single_byte_ints:
    packer_reset
    pack_int 1
    pack_int 2

    mov eax, [packer_buf]
    assert_eax_eq 0x02_01, __LINE__ ; 0x01 0x02 is the sane people endianness

test_packer_macro_pack_two_mixed_len_byte_ints:
    packer_reset
    pack_int 65
    pack_int 2

    mov eax, [packer_buf]
    assert_eax_eq 0x02_01_81, __LINE__ ; 0x81 0x01 0x02 is the sane people endianness

    end_test __LINE__
