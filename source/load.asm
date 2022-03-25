%include "source/conf.asm"

;
    org K_LOAD_ADDR
    ; xor eax, eax

    call load_elf_c

    jmp dword K_START

; 通过 elf 结构找到 main 函数地址并执行
load_elf_c:
    xor esi, dword esi
    xor ecx, dword ecx
    mov cx, word [K_BUF_ADDR + 0x2C]; e_phnum
    mov esi, dword [K_BUF_ADDR + 0X1C] ; e_phoff
    add esi, dword K_BUF_ADDR; K_BUF_ADD + e_phoff
load_elf_c_begin:
    mov eax, dword [esi + 0]
    cmp eax, dword 0
    je load_elf_c_no_action; 等于 0 说明无用段
    
    push dword [esi + 0x08];
    mov eax, dword [esi + 0x04];
    add eax, dword K_BUF_ADDR;
    push dword eax ;
    push dword [esi + 0x10];
    call copy_memory
    add esp, dword 12
load_elf_c_no_action:
    add esi, dword 0x00000020;
    dec dword ecx
    jnz load_elf_c_begin
    ret

; 内存复制
copy_memory:
    push dword esi
    push dword edi
    push dword ecx
    mov edi, dword [esp+ 0x04 * 0x03]; target
    mov esi, dword [esp+ 0x04 * 0x04]; source
    mov ecx, dword [esp+ 0x04 * 0x05]; count
copy_memory_loop:
    cmp ecx, dword 0
    jz copy_memory_end
    mov byte al, byte [ds:esi]
    inc dword esi
    mov byte [es:edi], byte al
    inc dword edi
    loop copy_memory_loop
copy_memory_end:
    mov eax, dword [esp + 0x04 * 0x03]
    pop dword ecx
    pop dword edi
    pop dword esi
    ret

;补零
    times 512 - ($ - $$) db 0