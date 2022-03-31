org 0x0000

ori $1, $0, 0x0F00
ori $2, $0, 0x0F18

Loop: 	lw $6, 0($1)
	addi $6, $6, 1
	sw $6, 0($1)
	addi $1, $1, 4
	beq $1, $2, Exit
	j Loop
Exit:
	halt

org   0x0F00
cfw   0x7337
cfw   0x2701
cfw   0x1337
cfw   0x5634
cfw   0x8877
cfw   0x3427
cfw   0x9559
