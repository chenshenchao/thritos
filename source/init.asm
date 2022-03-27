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

    call init_vga

; 进入保护模式
into_protect:
    ; TODO
    jmp into_protect_begin
GDT_START:
    ;               基址        界限        属性
    def_descriptor 0x00000000, 0x00000000, 0x00000000; 
GDT_CODE_DESC: ;代码段
    def_descriptor K_START, K_LENGTH, DA_C + DA_32; C000 - D000
GDT_VIDEO_DESC: ; 显存
    def_descriptor 0x000B8000, 0x0000FFFF, DA_DRW ; B8000 - C8000
GDT_RAW_DESC:
    def_descriptor 0x00000100, 0x0000B800, DA_DRW ; 100 - B900
GDT_VGA_DESC:
    def_descriptor 0x000A0000, 0X000AFFFF, DA_DRW; A0000 - AFFFF VGA
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

    ;hlt

    ; 跳入加载器
    jmp dword K_LOAD_ADDR

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

;补零
    times 512 - ($ - $$) db 0
