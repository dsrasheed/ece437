org 0x0000
ori   $2, $0, 2
ori   $3, $0, 3
ori   $4, $0, 4
ori   $5, $0, 5
ori   $6, $0, 6
ori   $7, $0, 1
ori   $8, $0, 1

ori $21, $0, 0x0800
ori $22, $0, 0x0c00

sw $7, 0($21)

addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4

add $8, $2, $3
xor $7, $8, $5
sw $7, 0($21)

addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4

ori   $7, $0, 1
ori   $8, $0, 1

addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4

addu $8, $3, $4
addu $7, $6, $5
sub $8, $8, $5
addu $8, $8, $7
sw $8, 0($22)

addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4

ori   $7, $0, 1
ori   $8, $0, 1

addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4
addu $1, $3, $4

addu $8, $3, $4
addu $9, $4, $5
addu $7, $6, $5
sub $8, $8, $9
addu $8, $8, $7
sw $8, 4($22)

halt
 
 
