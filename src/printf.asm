%define MAX_PRINTF_ARGS 8

; TODO: do not segfault when we write out of those bounds
%define MAX_PRINTF_LEN 2048

%macro printlnf 1-*
    printf %{1:-1}
    call print_newline
%endmacro

%macro printf 1-*
    push_registers
    ; amount of args 1 based
    ; without format string
    ;
    ;  printf "foo %s", "bar"         => 1 arg
    ;  printf "foo %d %s", 10, "bar"  => 2 arg
    ;
    %xdefine num_args %count(%{1:-1})
    %assign num_args (num_args-1)

    %if num_args == 0
        mov dword [printf_num_args], 0
    %elif num_args == 1
        mov qword [printf_arg_1_buf], %{2:2}
        mov dword [printf_num_args], 1
    %elif num_args == 2
        mov qword [printf_arg_1_buf], %{2:2}
        mov qword [printf_arg_2_buf], %{3:3}
        mov dword [printf_num_args], 2
    %elif num_args == 3
        mov qword [printf_arg_1_buf], %{2:2}
        mov qword [printf_arg_2_buf], %{3:3}
        mov qword [printf_arg_3_buf], %{4:4}
        mov dword [printf_num_args], 3
    %elif num_args == 4
        mov qword [printf_arg_1_buf], %{2:2}
        mov qword [printf_arg_2_buf], %{3:3}
        mov qword [printf_arg_3_buf], %{4:4}
        mov qword [printf_arg_4_buf], %{5:5}
        mov dword [printf_num_args], 4
    %elif num_args == 5
        mov qword [printf_arg_1_buf], %{2:2}
        mov qword [printf_arg_2_buf], %{3:3}
        mov qword [printf_arg_3_buf], %{4:4}
        mov qword [printf_arg_4_buf], %{5:5}
        mov qword [printf_arg_5_buf], %{6:6}
        mov dword [printf_num_args], 5
    %elif num_args == 6
        mov qword [printf_arg_1_buf], %{2:2}
        mov qword [printf_arg_2_buf], %{3:3}
        mov qword [printf_arg_3_buf], %{4:4}
        mov qword [printf_arg_4_buf], %{5:5}
        mov qword [printf_arg_5_buf], %{6:6}
        mov qword [printf_arg_6_buf], %{7:7}
        mov dword [printf_num_args], 6
    %elif num_args == 7
        mov qword [printf_arg_1_buf], %{2:2}
        mov qword [printf_arg_2_buf], %{3:3}
        mov qword [printf_arg_3_buf], %{4:4}
        mov qword [printf_arg_4_buf], %{5:5}
        mov qword [printf_arg_5_buf], %{6:6}
        mov qword [printf_arg_6_buf], %{7:7}
        mov qword [printf_arg_7_buf], %{8:8}
        mov dword [printf_num_args], 7
    %elif num_args == 8
        mov qword [printf_arg_1_buf], %{2:2}
        mov qword [printf_arg_2_buf], %{3:3}
        mov qword [printf_arg_3_buf], %{4:4}
        mov qword [printf_arg_4_buf], %{5:5}
        mov qword [printf_arg_5_buf], %{6:6}
        mov qword [printf_arg_6_buf], %{7:7}
        mov qword [printf_arg_7_buf], %{8:8}
        mov qword [printf_arg_8_buf], %{9:9}
        mov dword [printf_num_args], 8
    %else
        jmp %%error_many_args
    %endif

    jmp %%okay_many_args

    %%error_many_args:

    puts  "error: tried to call printf with too many arguments"
    print "  max: "
    mov rax, MAX_PRINTF_ARGS
    call println_int32
    print "  got: "
    mov rax, num_args
    call println_int32
    exit 1

    %%okay_many_args:

    ; rax = is null terminated format str
    str_to_stack %1
    call _printf_args

    ; frees stack string
    mov rsp, rbp

    pop_registers
    %%printf_end:
%endmacro

_printf_fill_arg:
    ; _printf_fill_arg [r7]
    ;  rsi = print function

    ; overwrite the %d
    dec r10
    inc rcx

    push rax
    push rdi

    mov rbx, r8
    imul rbx, 8

    inc r8

    mov rax, [printf_arg_1_buf+rbx]
    lea rdi, [r11+r10]
    call rsi
    add r10, rax

    pop rdi
    pop rax
    ret

_printf_args:
    ; _printf_args [format str] [num args]
    ;  rax = format string
    ;  needs the labels
    ;
    ;  [printf_num_args]
    ;
    ;  [printf_arg_1_buf]
    ;  [printf_arg_2_buf]
    ;  ...
    ;
    ;  to be filled. The amount depends on num_args.
    push_registers


    ; r8 is the arg index
    ; we increment before compare
    ; so 1 = is the first
    ; but it will be %2 because %1 is the fmt string
    mov r8, 0

    mov rbp, rsp
    sub rsp, MAX_PRINTF_LEN
    ; r10 is index in final output string
    mov r10, 0
    ; r11 is pointer to start of output string
    lea r11, [rbp-MAX_PRINTF_LEN]

    mov rcx, 0
.__printf_fmt_char_loop:
    mov r9b, byte [rax+rcx]
    inc rcx

    ; copy one letter from the format string
    ; to the output buffer
    mov byte [r11+r10], r9b
    inc r10

    cmp r9b, '%'
    je .__printf_fmt_char_loop_got_percentage
    cmp r9b, '\'
    je .__printf_fmt_char_loop_got_backslash

    jmp .__printf_fmt_char_loop_check_repeat

.__printf_fmt_char_loop_got_backslash:
    ; \n newline
    mov r9b, byte [rax+rcx]
    cmp r9b, 'n'
    dec r10
    mov byte [r11+r10], 0xa
    inc r10
    inc rcx
    jmp .__printf_fmt_char_loop_check_repeat

.__printf_fmt_char_loop_got_percentage:
    mov r9b, byte [rax+rcx]
    cmp r9b, 'd'
    je .__printf_fmt_char_loop_got_fmt_d
    cmp r9b, 'p'
    je .__printf_fmt_char_loop_got_fmt_p

    puts "error: printf got invalid format character"
    exit 1

.__printf_fmt_char_loop_got_fmt_d:
    mov rsi, int32_to_str
    call _printf_fill_arg
    jmp .__printf_fmt_char_loop_check_repeat

.__printf_fmt_char_loop_got_fmt_p:
    mov rsi, ptr_to_str
    call _printf_fill_arg
    jmp .__printf_fmt_char_loop_check_repeat

.__printf_fmt_char_loop_check_repeat:

    cmp r9b, 0
    jne .__printf_fmt_char_loop

    ; print output buffer
    dec r10
    printn r11, r10

    ; free copy buffer
    mov rsp, rbp

    cmp r8d, [printf_num_args]
    je .__printf_args_end

    puts "error: printf number of args does not match number of args in format string"
    print "      expected args: "
    mov rax, 0
    mov eax, [printf_num_args]
    call println_int32
    print "           got args: "
    mov rax, r8
    call println_int32
    exit 1

.__printf_args_end:

    pop_registers
    ret

