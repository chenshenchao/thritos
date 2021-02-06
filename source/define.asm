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

