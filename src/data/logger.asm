char_newline       db 0x0a
char_space         db 0x20
char_dot           db '.'
char_colon         db ':'
char_minus         db '-'
char_single_quote  db 0x27
char_double_quote  db 0x22
char_comma         db ','
char_open_bracket  db '['
char_close_bracket db ']'
char_open_curly    db '{'
char_close_curly   db '}'
char_open_paren    db '('
char_close_paren   db ')'

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

s_too_many_shifts db "[error] crash because got too many shifts: "
l_s_too_many_shifts equ $ - s_too_many_shifts

s_supported_ints db "[logger] supported int sizes are 1, 2, 4 and 8 but got: "
l_s_supported_ints equ $ - s_supported_ints

s_print_i db "[logger] i="
l_s_print_i equ $ - s_print_i

s_logger db "[logger] "
l_s_logger equ $ - s_logger

