    org 0x0000
    ori $29, $0, 0xFFFC

// EXPECTED OUTPUT: 1, 2, 3 on stack

// Test 1: jump
    j    test1
    halt
test1:
    ori  $1, $0, 1
    push $1

// Test 2 & 3: jal and jr
    jal  test2
    ori  $1, $0, 3
    push $1
    halt
test2:
    ori  $1, $0, 2
    push $1
    jr   $31
    halt
