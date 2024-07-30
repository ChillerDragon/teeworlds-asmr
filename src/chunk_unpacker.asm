%macro is_chunk_flag 1
    ; is_chunk_flag [CHUNKFLAG_CONSTANT]
    ;
    ; example:
    ;
    ;  is_chunk_flag CHUNKFLAG_VITAL
    ;  je on_vital_chunk
    ;
    push rax
    mov al, [chunk_header_flags]
    is_rax_flag %1
    pop rax
%endmacro

print_chunk_header:
    print s_got_chunk_header
    print s_size
    mov rax, [chunk_header_size]
    call print_uint32

    print s_sequence
    mov rax, [chunk_header_sequence]
    call print_uint32

    is_chunk_flag CHUNKFLAG_VITAL
    je .print_chunk_header_vital
.print_chunk_header_non_vital:
    print s_vital_no
    jmp .print_chunk_header_resend
.print_chunk_header_vital:
    print s_vital_yes

    is_chunk_flag CHUNKFLAG_RESEND
    je .print_chunk_header_resend
.print_chunk_header_no_resend:
    print s_resend_no
    jmp .print_chunk_header_end
.print_chunk_header_resend:
    print s_resend_yes

.print_chunk_header_end:
    ret

unpack_chunk_header:
    ; unpack_chunk_header [rax]
    ;   rax = buffer
    push_registers

    ; flags
    mov dl, [rax]
    and dl, 0b1100_0000
    mov [chunk_header_flags], dl

    ; size
    ; extract bits from first byte
    mov dl, [rax]
    and dl, 0b0011_1111
    shl dl, 6
    ; extract bits from second byte
    mov bl, [rax+1]
    and bl, 0b0011_1111
    ; merge them together to one 2 byte integer
    or ebx, edx
    mov [chunk_header_size], ebx

    ; sequence
    ; teeworlds uses -1 to represent a unset sequence
    ; but i am scared of negative numbers so i will use
    ; the ambiguous value zero to represent unset sequence numbers
    ; in non vital chunks
    mov dword [chunk_header_sequence], 0
    is_chunk_flag CHUNKFLAG_VITAL
    jne .unpack_chunk_header_end

    ; first sequence byte
    mov dl, [rax+1]
    and dl, 0b1100_0000
    shl dl, 2
    ; 2nd sequence byte
    mov bl, [rax+2]
    ; merge
    xor ebx, edx
    mov [chunk_header_sequence], ebx

.unpack_chunk_header_end:

    pop_registers
    ret
