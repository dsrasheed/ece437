# set the address where you want this
# code segment
  org 0x0000

main:
  ori   $29, $29, 0xFFFC

  // Current Year
  lui   $1, 2022
  ori   $2, $0, 16
  srlv  $1, $1, $2
  addi  $1, $1, -2000
  ori   $2, $0, 365
  push  $1
  push  $2
  jal   multalg
  pop   $6

  // Month
  ori   $1, $0, 1
  addi  $1, $1, -1
  ori   $2, $0, 30
  push $1
  push $2
  jal multalg
  pop  $7
  add  $6, $6, $7

  // Current Day
  ori   $1, $0, 10

  // Num Days
  add   $1, $1, $6
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

