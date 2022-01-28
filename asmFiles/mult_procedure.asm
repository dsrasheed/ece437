# set the address where you want this
# code segment
  org 0x0000

mult_procedure:
  ori   $29, $29, 0xFFFC
  ori   $1, $0, 16
  ori   $2, $0, 16
  ori   $3, $0, 16
  ori   $4, $0, 16
  push  $1
  push  $2
  push  $3
  push  $4
mult_procedure_for:
  ori   $2, $0, 0xFFFC
  sub   $1, $2, $29
  beq   $1, $0, mult_procedure_done
mult_procedure_body:
  jal   multalg
  j     mult_procedure_for
mult_procedure_done:
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
