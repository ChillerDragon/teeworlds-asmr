%include "tests/assert.asm"

_start:
    init_test __FILE__

_test_huff_decompress_real_traffic:

    ; http://127.0.0.1:9822/?v=7&d=10+04+03+dd+dd+cc+cc+4a+36+4c+ed+e1+47+de+2e+e9+61+c4+ae+8d+ba+7c+8d+e6+f4+35+3c+62+0d+25+9c+c0+09+d3+f2+91+df+3c+3a+07+27+4e+e0+04+d7+4e+a7+8a+5b+8e+82+13+27+e6+44+5b+6a+8b+38+d1+16+b9+76+d7+0e+e5+d3+29+94+70+94+6b+e7+44+8e+82+13+27+a6+53+28+e1+28+d7+ce+89+1c+05+27+4e+4c+a7+50+c2+51+ae+9d+13+39+0a+4e+9c+18+f1+81+69+f5+9d+9d+aa+fd+26+f5+7a+a0+c1+6e+40+83+dd+80+06+bb+01+0d+76+8b+d0+4c+c9+f0+11+9a+d8+47+e8+82+cb+05+63+98+f4+10+d6+37+93+1e+7a+c2+24+0d+93+5e+cf+c2+24+1f+93+9e+f0+3c+93+10+93+9e+85+67+37+c9+d3+a4+e7+d9+8c+f5+15+f3+11+9a+94+53+f1+02+71+a5+4d+ca+61+bd+f5+f5+78+ff+64+c5+0d

    ; huff_decompress [rax] [rdi] [rsi] [rdx]
    ;  rax = input
    ;  rdi = input size
    ;  rsi = output
    ;  rdx = output size

    mov byte [generic_buffer_1024 + 0], 0x4a
    mov byte [generic_buffer_1024 + 1], 0x36
    mov byte [generic_buffer_1024 + 2], 0x4c
    mov byte [generic_buffer_1024 + 3], 0xed
    mov byte [generic_buffer_1024 + 4], 0xe1
    mov byte [generic_buffer_1024 + 5], 0x47
    mov byte [generic_buffer_1024 + 6], 0xde
    mov byte [generic_buffer_1024 + 7], 0x2e
    mov byte [generic_buffer_1024 + 8], 0xe9
    mov byte [generic_buffer_1024 + 9], 0x61
    mov byte [generic_buffer_1024 + 10], 0xc4
    mov byte [generic_buffer_1024 + 11], 0xae
    mov byte [generic_buffer_1024 + 12], 0x8d
    mov byte [generic_buffer_1024 + 13], 0xba
    mov byte [generic_buffer_1024 + 14], 0x7c
    mov byte [generic_buffer_1024 + 15], 0x8d
    mov byte [generic_buffer_1024 + 16], 0xe6
    mov byte [generic_buffer_1024 + 17], 0xf4
    mov byte [generic_buffer_1024 + 18], 0x35
    mov byte [generic_buffer_1024 + 19], 0x3c
    mov byte [generic_buffer_1024 + 20], 0x62
    mov byte [generic_buffer_1024 + 21], 0x0d
    mov byte [generic_buffer_1024 + 22], 0x25
    mov byte [generic_buffer_1024 + 23], 0x9c
    mov byte [generic_buffer_1024 + 24], 0xc0
    mov byte [generic_buffer_1024 + 25], 0x09
    mov byte [generic_buffer_1024 + 26], 0xd3
    mov byte [generic_buffer_1024 + 27], 0xf2
    mov byte [generic_buffer_1024 + 28], 0x91
    mov byte [generic_buffer_1024 + 29], 0xdf
    mov byte [generic_buffer_1024 + 30], 0x3c
    mov byte [generic_buffer_1024 + 31], 0x3a
    mov byte [generic_buffer_1024 + 32], 0x07
    mov byte [generic_buffer_1024 + 33], 0x27
    mov byte [generic_buffer_1024 + 34], 0x4e
    mov byte [generic_buffer_1024 + 35], 0xe0
    mov byte [generic_buffer_1024 + 36], 0x04
    mov byte [generic_buffer_1024 + 37], 0xd7
    mov byte [generic_buffer_1024 + 38], 0x4e
    mov byte [generic_buffer_1024 + 39], 0xa7
    mov byte [generic_buffer_1024 + 40], 0x8a
    mov byte [generic_buffer_1024 + 41], 0x5b
    mov byte [generic_buffer_1024 + 42], 0x8e
    mov byte [generic_buffer_1024 + 43], 0x82
    mov byte [generic_buffer_1024 + 44], 0x13
    mov byte [generic_buffer_1024 + 45], 0x27
    mov byte [generic_buffer_1024 + 46], 0xe6
    mov byte [generic_buffer_1024 + 47], 0x44
    mov byte [generic_buffer_1024 + 48], 0x5b
    mov byte [generic_buffer_1024 + 49], 0x6a
    mov byte [generic_buffer_1024 + 50], 0x8b
    mov byte [generic_buffer_1024 + 51], 0x38
    mov byte [generic_buffer_1024 + 52], 0xd1
    mov byte [generic_buffer_1024 + 53], 0x16
    mov byte [generic_buffer_1024 + 54], 0xb9
    mov byte [generic_buffer_1024 + 55], 0x76
    mov byte [generic_buffer_1024 + 56], 0xd7
    mov byte [generic_buffer_1024 + 57], 0x0e
    mov byte [generic_buffer_1024 + 58], 0xe5
    mov byte [generic_buffer_1024 + 59], 0xd3
    mov byte [generic_buffer_1024 + 60], 0x29
    mov byte [generic_buffer_1024 + 61], 0x94
    mov byte [generic_buffer_1024 + 62], 0x70
    mov byte [generic_buffer_1024 + 63], 0x94
    mov byte [generic_buffer_1024 + 64], 0x6b
    mov byte [generic_buffer_1024 + 65], 0xe7
    mov byte [generic_buffer_1024 + 66], 0x44
    mov byte [generic_buffer_1024 + 67], 0x8e
    mov byte [generic_buffer_1024 + 68], 0x82
    mov byte [generic_buffer_1024 + 69], 0x13
    mov byte [generic_buffer_1024 + 70], 0x27
    mov byte [generic_buffer_1024 + 71], 0xa6
    mov byte [generic_buffer_1024 + 72], 0x53
    mov byte [generic_buffer_1024 + 73], 0x28
    mov byte [generic_buffer_1024 + 74], 0xe1
    mov byte [generic_buffer_1024 + 75], 0x28
    mov byte [generic_buffer_1024 + 76], 0xd7
    mov byte [generic_buffer_1024 + 77], 0xce
    mov byte [generic_buffer_1024 + 78], 0x89
    mov byte [generic_buffer_1024 + 79], 0x1c
    mov byte [generic_buffer_1024 + 80], 0x05
    mov byte [generic_buffer_1024 + 81], 0x27
    mov byte [generic_buffer_1024 + 82], 0x4e
    mov byte [generic_buffer_1024 + 83], 0x4c
    mov byte [generic_buffer_1024 + 84], 0xa7
    mov byte [generic_buffer_1024 + 85], 0x50
    mov byte [generic_buffer_1024 + 86], 0xc2
    mov byte [generic_buffer_1024 + 87], 0x51
    mov byte [generic_buffer_1024 + 88], 0xae
    mov byte [generic_buffer_1024 + 89], 0x9d
    mov byte [generic_buffer_1024 + 90], 0x13
    mov byte [generic_buffer_1024 + 91], 0x39
    mov byte [generic_buffer_1024 + 92], 0x0a
    mov byte [generic_buffer_1024 + 93], 0x4e
    mov byte [generic_buffer_1024 + 94], 0x9c
    mov byte [generic_buffer_1024 + 95], 0x18
    mov byte [generic_buffer_1024 + 96], 0xf1
    mov byte [generic_buffer_1024 + 97], 0x81
    mov byte [generic_buffer_1024 + 98], 0x69
    mov byte [generic_buffer_1024 + 99], 0xf5
    mov byte [generic_buffer_1024 + 100], 0x9d
    mov byte [generic_buffer_1024 + 101], 0x9d
    mov byte [generic_buffer_1024 + 102], 0xaa
    mov byte [generic_buffer_1024 + 103], 0xfd
    mov byte [generic_buffer_1024 + 104], 0x26
    mov byte [generic_buffer_1024 + 105], 0xf5
    mov byte [generic_buffer_1024 + 106], 0x7a
    mov byte [generic_buffer_1024 + 107], 0xa0
    mov byte [generic_buffer_1024 + 108], 0xc1
    mov byte [generic_buffer_1024 + 109], 0x6e
    mov byte [generic_buffer_1024 + 110], 0x40
    mov byte [generic_buffer_1024 + 111], 0x83
    mov byte [generic_buffer_1024 + 112], 0xdd
    mov byte [generic_buffer_1024 + 113], 0x80
    mov byte [generic_buffer_1024 + 114], 0x06
    mov byte [generic_buffer_1024 + 115], 0xbb
    mov byte [generic_buffer_1024 + 116], 0x01
    mov byte [generic_buffer_1024 + 117], 0x0d
    mov byte [generic_buffer_1024 + 118], 0x76
    mov byte [generic_buffer_1024 + 119], 0x8b
    mov byte [generic_buffer_1024 + 120], 0xd0
    mov byte [generic_buffer_1024 + 121], 0x4c
    mov byte [generic_buffer_1024 + 122], 0xc9
    mov byte [generic_buffer_1024 + 123], 0xf0
    mov byte [generic_buffer_1024 + 124], 0x11
    mov byte [generic_buffer_1024 + 125], 0x9a
    mov byte [generic_buffer_1024 + 126], 0xd8
    mov byte [generic_buffer_1024 + 127], 0x47
    mov byte [generic_buffer_1024 + 128], 0xe8
    mov byte [generic_buffer_1024 + 129], 0x82
    mov byte [generic_buffer_1024 + 130], 0xcb
    mov byte [generic_buffer_1024 + 131], 0x05
    mov byte [generic_buffer_1024 + 132], 0x63
    mov byte [generic_buffer_1024 + 133], 0x98
    mov byte [generic_buffer_1024 + 134], 0xf4
    mov byte [generic_buffer_1024 + 135], 0x10
    mov byte [generic_buffer_1024 + 136], 0xd6
    mov byte [generic_buffer_1024 + 137], 0x37
    mov byte [generic_buffer_1024 + 138], 0x93
    mov byte [generic_buffer_1024 + 139], 0x1e
    mov byte [generic_buffer_1024 + 140], 0x7a
    mov byte [generic_buffer_1024 + 141], 0xc2
    mov byte [generic_buffer_1024 + 142], 0x24
    mov byte [generic_buffer_1024 + 143], 0x0d
    mov byte [generic_buffer_1024 + 144], 0x93
    mov byte [generic_buffer_1024 + 145], 0x5e
    mov byte [generic_buffer_1024 + 146], 0xcf
    mov byte [generic_buffer_1024 + 147], 0xc2
    mov byte [generic_buffer_1024 + 148], 0x24
    mov byte [generic_buffer_1024 + 149], 0x1f
    mov byte [generic_buffer_1024 + 150], 0x93
    mov byte [generic_buffer_1024 + 151], 0x9e
    mov byte [generic_buffer_1024 + 152], 0xf0
    mov byte [generic_buffer_1024 + 153], 0x3c
    mov byte [generic_buffer_1024 + 154], 0x93
    mov byte [generic_buffer_1024 + 155], 0x10
    mov byte [generic_buffer_1024 + 156], 0x93
    mov byte [generic_buffer_1024 + 157], 0x9e
    mov byte [generic_buffer_1024 + 158], 0x85
    mov byte [generic_buffer_1024 + 159], 0x67
    mov byte [generic_buffer_1024 + 160], 0x37
    mov byte [generic_buffer_1024 + 161], 0xc9
    mov byte [generic_buffer_1024 + 162], 0xd3
    mov byte [generic_buffer_1024 + 163], 0xa4
    mov byte [generic_buffer_1024 + 164], 0xe7
    mov byte [generic_buffer_1024 + 165], 0xd9
    mov byte [generic_buffer_1024 + 166], 0x8c
    mov byte [generic_buffer_1024 + 167], 0xf5
    mov byte [generic_buffer_1024 + 168], 0x15
    mov byte [generic_buffer_1024 + 169], 0xf3
    mov byte [generic_buffer_1024 + 170], 0x11
    mov byte [generic_buffer_1024 + 171], 0x9a
    mov byte [generic_buffer_1024 + 172], 0x94
    mov byte [generic_buffer_1024 + 173], 0x53
    mov byte [generic_buffer_1024 + 174], 0xf1
    mov byte [generic_buffer_1024 + 175], 0x02
    mov byte [generic_buffer_1024 + 176], 0x71
    mov byte [generic_buffer_1024 + 177], 0xa5
    mov byte [generic_buffer_1024 + 178], 0x4d
    mov byte [generic_buffer_1024 + 179], 0xca
    mov byte [generic_buffer_1024 + 180], 0x61
    mov byte [generic_buffer_1024 + 181], 0xbd
    mov byte [generic_buffer_1024 + 182], 0xf5
    mov byte [generic_buffer_1024 + 183], 0xf5
    mov byte [generic_buffer_1024 + 184], 0x78
    mov byte [generic_buffer_1024 + 185], 0xff
    mov byte [generic_buffer_1024 + 186], 0x64
    mov byte [generic_buffer_1024 + 187], 0xc5
    mov byte [generic_buffer_1024 + 188], 0x0d

    ;  rax = input
    mov rax, generic_buffer_1024
    ;  rdi = input size
    mov rdi, 189
    ;  rsi = output
    mov rsi, generic_buffer_512
    ;  rdx = output size
    mov rdx, 512
    call huff_decompress

    ; expect 200 as decompressed output size
    assert_eax_eq 200, __LINE__

    movzx rax, byte [generic_buffer_512 + 0]
    assert_al_eq 0x40, __LINE__

    movzx rax, byte [generic_buffer_512 + 1]
    assert_al_eq 0x06, __LINE__

    movzx rax, byte [generic_buffer_512 + 2]
    assert_al_eq 0x09, __LINE__

    exit 0

