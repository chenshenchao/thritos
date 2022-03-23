# [ThritOS]

```sh
make
```

```sh
# 简略指定
qemu-system-i386 -hdd target/mbr

# -hdd 替换详细指定
qemu-system-i386 -drive file=target/mbr,format=raw,index=0,media=disk

# 如果找不到 bios-256k.bin 用 -L 附带该文件路径，通常在 qemu 目录下。
qemu-system-i386 -drive file=target/mbr,format=raw,index=0,media=disk -L E:\qemu

# -gdb tcp::1234 设置GDB 端口
# -S 挂起等待
qemu-system-i386 -drive file=target/mbr,format=raw,index=0,media=disk -L E:\qemu -gdb tcp::1234 -S

gdb
# 由于 wsl 所以通过 cat /etc/resolv.conf 查到宿主地址
target remote 172.19.80.1:1234

# 设置架构
set architecture i8086

# 设置汇编风格为 intel
set disassembly-flavor intel

# 设置断电 启示内存
b *0x7c00

# 断点到 加载器
b *0x8200

# 查看断点情况
info b

ni # next instruction
si # step instruction
c # continue # 直接执行

# 显示寄存器
p $eax

x/i $pc #显示指针汇编指令
x/10i $pc # 显示指针后10个汇编指令

x/10b $esp # 显示 10个 byte 数据
x/10w $esp # 显示栈10个 dword 数据
x/10s $rdi # 显示为10个 0结尾字符串

b 0x7c00 # 设置断点
```

## 内存特殊地址

大部分 0x30000 以上的地址

- 0x7COO 启动
- 0xB8000 显示
- 0x09FC00 0X09FFFF
