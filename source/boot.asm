%include "source/conf.asm"

;section mbr vstart=0x7C00
    org 0x7C00
;FAT12 格式头
    jmp start
    nop
    db "thritos "   ;厂商名
    dw 0x0200       ;每扇区字节数（Bytes/Sector）
    db 0x01         ;每簇扇区数（Sectors/Cluster）
    dw 0x0001       ;Boot 记录占用扇区数
    db 0x02         ;FAT 表数
    dw 0x00E0       ;根目录区文件最大数
    dw 0x0B40       ;扇区总数（数量可以用16位表示）
    db 0xF0         ;介质描述符
    dw 0x0009       ;每 FAT 表扇区数
    dw 0x0012       ;每磁道扇区数（Sectors/Track）
    dw 0x0002       ;磁头数（面数）
    dd 0x00000000   ;隐藏扇区数
    dd 0x00000000   ;扇区总数（数量需要用32位表示）
    db 0x00         ;int 0x13 驱动器号
    db 0x00         ;保留，未使用
    db 0x29         ;扩展引导标记 0x29
    dd 0x00000000   ;卷序列号
    db "thritos-vol";卷标
    db "FAT16   "   ;文件系统类型

start:
    ; 初始化栈
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov sp, 0x7C00

    call clear_screen
    call print_boot

; 加载扇区
load_boot:
    ;lahf
    ;and ah, 0xFE
    ;sahf
    mov ax, 0x0820  ; 加载到段 0x0820 段下
    mov es, ax
    mov bx, 0x0000
    mov ch, 0x00    ;柱面 0
    mov dh, 0x00    ;磁头 0
    mov cl, 0x02    ;扇区 2

    mov ah, 0x02    ;读盘
    mov al, 0x20    ;扇区数 32
    mov dl, 0x80    ;驱动器：软盘 0x00-0x7F；硬盘 0x80-0xFF
    int 0x13        ;调用磁盘程序
    jnc mbr_end
mbr_end:
    ; 加载内核
    jmp word K_LOAD_ADDR ;

;清屏
clear_screen:
    mov ax, 0x0600; 功能号 0x06
    mov bx, 0x0700; 
    mov cx, 0x0000; (0, 0) 左上角
    mov dx, 0x184f; (24, 79) 右下角
    int 0x10
    ret

;打印
print_boot:
    mov ax, cs
    mov es, ax
    mov ax, message_boot
    mov bp, ax; es:bp

    mov cx, 0x07
    mov ax, 0x1301
    mov bx, 0x0002
    mov dh, 0x00
    mov dl, 0x00
    int 0x10
    ret
;存储信息
message_boot:
    db "boot..."

;补零
    times 510 - ($ - $$) db 0
    db 0x55, 0xAA
