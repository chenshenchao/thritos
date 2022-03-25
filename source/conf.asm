;
;
;
VGA_CYLS    equ 0x0FF0; 设定启动区
VGA_LEDS    equ 0x0FF1; 
VGA_MODE    equ 0x0FF2; 颜色位数
VGA_SCRN_W   equ 0x0FF4; 分辨率宽
VGA_SCRN_H   equ 0x0FF6; 分辨率高
VGA_VRAM    equ 0x0FF8; 图像缓冲地址

K_INIT_ADDR     equ 0x8200 ; 内核加载器 地址
K_BUF_ADDR      equ 0x8400 ; 内核文件读入内存的地址，加载 load 的时候随后被加载进去
K_START         equ 0xC000; 内核入口
K_LENGTH        equ 0x7FFF; 内核代码长度

%macro def_descriptor 3
    dw %2 & 0xFFFF; 段界限1 (低 16bit)
    dw %1 & 0xFFFF; 段基址1 (低 16bit)
    db (%1 >> 16) & 0xFF; 段基址2 (中 8bit)
    dw ((%2 >> 8) & 0xF00) | (%3 & 0xF0FF); 属性1（G,D/B,L,AVL） + 段界限2(高 4bit) + 属性2(P,DPL,S,TYPE)
    db (%1 >> 24) & 0xFF; 段基址3 (高 8bit)
%endmacro

;
; 描述符类型
;
DA_32           equ 0x4000; 32位段

DA_DPL0         equ 0x00; DPL = 0
DA_DPL1         equ 0x20; DPL = 1
DA_DPL2         equ 0x40; DPL = 2
DA_DPL3         equ 0x60; DPL = 3

; 存储段描述符类型
DA_DR           equ 0x90; 只读数据段
DA_DRW          equ 0x92; 可读写数据段
DA_DRWA         equ 0x93; 已访问可读写数据段
DA_C            equ 0x98; 只执行代码段
DA_CR           equ 0x9A; 可执行可读代码段
DA_CCO          equ 0x9C; 只执行一致代码段
DA_CCOR         equ 0x9E; 可执行可读一致代码段

; 系统段描述符类型
DA_LDT          equ 0x82; 局部描述符表段
DA_TASK_GATE    equ 0x85; 任务门
DA_386_TSS      equ 0x89; 可用 386 任务状态段
DA_386_C_GATE   equ 0x8C; 386 调用门
DA_386_I_GATE   equ 0x8E; 386 中断门
DA_386_T_GATE   equ 0x8F; 386 陷阱门

;
; 选择子类型
;
SA_RPL0         equ 0x00;
SA_RPL1         equ 0x01;
SA_RPL2         equ 0x02;
SA_RPL3         equ 0x03;

SA_TIG          equ 0x00;
SA_TIL          equ 0x04;

;
; 宏
;

