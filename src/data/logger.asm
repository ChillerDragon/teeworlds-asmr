char_newline      db 0x0a
char_space        db 0x20
char_dot          db '.'
char_minus        db '-'
char_single_quote db 0x27
char_double_quote db 0x22

s_dbg_rax_digit db "[debug] value of rax is: "
l_s_dbg_rax_digit equ $ - s_dbg_rax_digit

s_dbg_reg_digit db "[debug] value of register is: "
l_s_dbg_reg_digit equ $ - s_dbg_reg_digit

s_dbg_hexdump_register db "[debug] hexdumping register: "
l_s_dbg_hexdump_register equ $ - s_dbg_hexdump_register

s_strings_do_not_match db "[system] strings do not match", 0x0a
l_s_strings_do_not_match equ $ - s_strings_do_not_match
s_string1 db              "[system]  string1: '"
l_s_string1 equ $ - s_string1
s_string2 db              "[system]  string2: '"
l_s_string2 equ $ - s_string2
