org 0x0000
  ori   $1, $0, 0x1000
  ori   $2, $0, 0x2000
  ori   $3, $0, 0x3000
  ori   $4, $0, 0x4000
  ori   $7, $0, 0

loop:

  lw $5, 0($1)
  lw $6, 4($1)
  sw $6, 0($1)
  sw $5, 4($1)

  lw $5, 0($2)
  lw $6, 4($2)
  sw $6, 0($2)
  sw $5, 4($2)

  lw $5, 0($3)
  lw $6, 4($3)
  sw $6, 0($3)
  sw $5, 4($3)

  lw $5, 0($4)
  lw $6, 4($4)
  sw $6, 0($4)
  sw $5, 4($4)

  addi $1, $1, 8
  addi $2, $2, 8
  addi $3, $3, 8
  addi $4, $4, 8

  addi $7, $7, 1
  ori  $8, $0, 8
  bne  $7, $8, loop

  #lw $6, 0($9)
  #lw $3, 0($6)

  halt

org 0x1000
  cfw   0x11111111
  cfw   0x22222222
org 0x1008
  cfw   0x11111111
  cfw   0x22222222
org 0x1010
  cfw   0x11111111
  cfw   0x22222222
org 0x1018
  cfw   0x11111111
  cfw   0x22222222
org 0x1020
  cfw   0x11111111
  cfw   0x22222222
org 0x1028
  cfw   0x11111111
  cfw   0x22222222
org 0x1030
  cfw   0x11111111
  cfw   0x22222222
org 0x1038
  cfw   0x11111111
  cfw   0x22222222

org 0x2000
  cfw   0x33333333
  cfw   0x44444444
org 0x2008
  cfw   0x33333333
  cfw   0x44444444
org 0x2010
  cfw   0x33333333
  cfw   0x44444444
org 0x2018
  cfw   0x33333333
  cfw   0x44444444
org 0x2020
  cfw   0x33333333
  cfw   0x44444444
org 0x2028
  cfw   0x33333333
  cfw   0x44444444
org 0x2030
  cfw   0x33333333
  cfw   0x44444444
org 0x2038
  cfw   0x33333333
  cfw   0x44444444

org 0x3000
  cfw   0x55555555
  cfw   0x66666666
org 0x3008
  cfw   0x55555555
  cfw   0x66666666
org 0x3010
  cfw   0x55555555
  cfw   0x66666666
org 0x3018
  cfw   0x55555555
  cfw   0x66666666
org 0x3020
  cfw   0x55555555
  cfw   0x66666666
org 0x3028
  cfw   0x55555555
  cfw   0x66666666
org 0x3030
  cfw   0x55555555
  cfw   0x66666666
org 0x3038
  cfw   0x55555555
  cfw   0x66666666

org 0x4000
  cfw   0x77777777
  cfw   0x88888888
org 0x4008
  cfw   0x77777777
  cfw   0x88888888
org 0x4010
  cfw   0xFEEDBEEF
  cfw   0xBEEFFEED
org 0x4018
  cfw   0x77777777
  cfw   0x88888888
org 0x4020
  cfw   0x77777777
  cfw   0x88888888
org 0x4028
  cfw   0x77777777
  cfw   0x88888888
org 0x4030
  cfw   0x77777777
  cfw   0x88888888
org 0x4038
  cfw   0x77777777
  cfw   0x88888888
