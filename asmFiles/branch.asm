    org 0x0000
    ori $29, $0, 0xFFFC

// EXPECTED OUTPUT: 1, 2, 3, 4 on stack

// Test 1: beq taken
    beq $0, $0, beq_taken
    halt
beq_taken:
    ori $1, $0, 1
    push $1

// Test 2: bne taken
    ori $1, $0, 1
    ori $2, $0, 2
    bne $1, $2, bne_taken
    halt
bne_taken:
    ori $1, $0, 2
    push $1

// Test 3: beq not taken
    ori $1, $0, 1
    beq $1, $0, fail
    ori $1, $0, 3
    push $1

// Test 4: bne not taken
    bne $0, $0, fail
    ori $1, $0, 4
    push $1

fail:
    halt
