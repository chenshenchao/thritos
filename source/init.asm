%include "source/conf.asm"

; 加载器
    org K_INIT_ADDR

    ; 初始化栈
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov sp, K_INIT_ADDR

    call print_load

    call init_vga

    ; 进入保护模式
    call into_protect

    ; 加载并跳入内核
    call load_elf_c
    jmp 0x30400

; 进入保护模式
into_protect:
    ; TODO
    ret

; 通过 elf 结构找到 main 函数地址并执行
load_elf_c:
    xor esi, esi
    xor ecx, ecx
    mov cx, word[K_BUF_ADDR + 0x2C]; e_phnum
    mov esi, [K_BUF_ADDR + 0X1C] ; e_phoff
    add esi, K_BUF_ADDR; K_BUF_ADD + e_phoff
load_elf_c_begin:
    mov eax, [esi + 0]
    cmp eax, 0
    je load_elf_c_no_action; 等于 0 说明无用段
    
    push dword [esi + 0x10];
    mov eax, [esi + 0x04];
    add eax, K_BUF_ADDR;
    push eax;
    push dword[esi + 0x08];
    call copy_memory
    add esp, 12
load_elf_c_no_action:
    add esi, 0x20;
    dec ecx
    jnz load_elf_c_begin
    ret

; 内存复制
copy_memory:
    push esi
    push edi
    push ecx
    mov edi,[esp+ 0x04 * 0x04]; source
    mov esi,[esp+ 0x04 * 0x05]; target
    mov ecx,[esp+ 0x04 * 0x06]; count
copy_memory_loop:
    cmp ecx, 0
    jz copy_memory_end
    mov al, [ds:esi]
    inc esi
    mov [es:edi], al
    inc edi
    loop copy_memory_loop
copy_memory_end:
    mov eax, [esp + 0x04 * 0x04]
    pop ecx
    pop edi
    pop esi
    ret

init_vga:
    mov al, 0x13; VGA 320x200x8bit
    mov ah, 0x00
    int 0x10
    mov byte [VGA_MODE], 8;
    mov word [VGA_SCRN_W], 320
    mov word [VGA_SCRN_H], 200
    mov dword [VGA_VRAM], 0x000A0000; 该模式显存映射地址[0xA0000, 0xAFFFF]

    mov ah,0x02
    int 0x16 ; 键盘 BIOS
    mov [VGA_LEDS], al
    ret

;打印
print_load:
    mov ax, cs
    mov es, ax
    mov ax, message_load
    mov bp, ax; es:bp

    mov cx, 0x07
    mov ax, 0x1301
    mov bx, 0x0002
    mov dh, 0x00
    mov dl, 0x00
    int 0x10
    ret
;存储信息
message_load:
    db "load..."

;补零
    times 512 - ($ - $$) db 0
