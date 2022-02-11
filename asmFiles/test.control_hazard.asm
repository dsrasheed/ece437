org 0x000

ori $2, $0, 2
ori $3, $0, 3
ori $4, $0, 0x0200
ori $5, $0, 0x0400
ori $6, $0, 6
ori $7, $0, 7
ori $8, $0, 3

	beq $2, $0, test_branch2
	bne $2, $6, test_branch3

test_branch1:
	sw $2, 0($5)
	halt
	sw $7, 0($5)

test_branch2:
	halt

test_branch3:
	add $2, $2, $6
	bne $0, $0, test_branch4
	sw $7, 0($4)

test_branch4:
	add $2, $2, $6
	beq $3, $8, test_branch1


halt
