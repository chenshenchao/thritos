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

    ; ; 加载内核
    ; call load_elf_c

    call print_load

    call init_vga


; 进入保护模式
into_protect:
    ; TODO
    jmp into_protect_begin
GDT_START:
    ;               基址        界限        属性
    def_descriptor 0x00000000, 0x00000000, 0x00000000; 
GDT_CODE_DESC: ;代码段
    def_descriptor K_START, K_LENGTH, DA_C + DA_32;
GDT_VIDEO_DESC: ; 显存
    def_descriptor 0x000B8000, 0x0000FFFF, DA_DRW
GDT_SIZE equ $ - GDT_START
GDT_LIMIT equ GDT_SIZE - 1
GDT_PTR:
    dw GDT_LIMIT
    dd GDT_START

SELECTOR_CODE equ GDT_CODE_DESC - GDT_START

into_protect_begin:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x100

    ; 代码段描述符初始化
    xor eax, eax
    mov ax, cs
    shl eax, 4
    add eax, K_START
    mov word [GDT_CODE_DESC + 2], ax
    shr eax, 16
    mov byte [GDT_CODE_DESC + 4], al
    mov byte [GDT_CODE_DESC + 7], ah

    ; 获取 GDT 内存地址
    xor eax, eax
    mov ax, ds
    shl eax, 4
    add eax, GDT_START
    mov dword [GDT_PTR + 2], eax;

    ; 加载 GDT
    lgdt [GDT_PTR]

    ; 打开地址线 A20
    in al, 0x92
    or al, 0b00000010
    out 0x92, al

    ; 关闭中断
    cli

    ; 进入保护模式
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; 打开中断
    ; sti

    mov ah, 15
    mov ecx, 0xA0000
    mov ebx, 0xAFFFF
s_15:
    mov [ecx], ah
    inc ecx
    test ecx, ebx
    jne s_15

    mov ah, 10
    mov ecx, 0xA0010
    mov [ecx], ah

; loop:
;     hlt
;     jmp loop

    ; 加载内核
    call load_elf_c

    ; 跳入内核
    ; jmp dword SELECTOR_CODE:0 ;K_START
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
    mov edi, dword [esp+ 0x04 * 0x04]; target
    mov esi, dword [esp+ 0x04 * 0x05]; source
    mov ecx, dword [esp+ 0x04 * 0x06]; count
copy_memory_loop:
    cmp ecx, dword 0
    jz copy_memory_end
    mov byte al, byte [ds:esi]
    inc dword esi
    mov byte [es:edi], byte al
    inc dword edi
    loop copy_memory_loop
copy_memory_end:
    mov eax, dword [esp + 0x04 * 0x04]
    pop dword ecx
    pop dword edi
    pop dword esi
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
