org 0x0000

test_multalg:
  ori   $29, $29, 0xFFFC
  addi  $29, $29, -8
  ori   $1, $0, 24
  ori   $2, $0, 3
  sw    $1, 4($29)
  sw    $2, 0($29)
  jal   multalg
  halt

multalg:
  pop   $1
  pop   $2
  ori   $3, $0, 0
  ori   $4, $0, 0
multalg_for:
  slti  $5, $4, 32
  beq   $5, $0, multalg_done
multalg_body:
  andi  $5, $1, 1
  beq   $5, $0, multalg_shifting
multalg_adding:
  add   $3, $3, $2
multalg_shifting:
  ori   $5, $0, 1
  sllv  $2, $5, $2
  srlv  $1, $5, $1
multalg_update:
  addi  $4, $4, 1
  j     multalg_for
multalg_done:
  push  $3
  jr    $31
