    org  0x0000
    ori  $29, $0, 0xFFFC

// EXPECTED OUTPUT: 1 on stack

// Test 1: halt
    ori  $1, $0, 1
    push $1
    halt
    pop $1
    addi $1, $1, 100
    push $1
    halt
