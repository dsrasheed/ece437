org 0x0000

ori $1, $0, 0x0F00
addi $2, $1, 4
addi $3, $1, 8 
ori $4, $0, 0x1000

lw $6, 0($1)
lw $7, 0($2)
lw $8, 0($3)
sw $6, 0($1)
sw $7, 0($1)
sw $8, 0($1)
halt

org   0x0F00
cfw   0x7337
cfw   0x2701
cfw   0x1337
