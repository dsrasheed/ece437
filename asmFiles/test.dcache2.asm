org 0x0000
  ori   $4,$zero,0xF000
  ori   $5,$zero,0x108
  ori   $6,$zero,0x510
  ori   $7,$zero,0xA18
  ori   $8,$zero,0xBA0
  ori   $9,$zero,0xCA8
  ori   $10,$zero,0xDB0
  ori   $11,$zero,0xEB8

  lw $1, 0($4)
  lw $2, 4($4)
  lw $3, 8($4)

  add $21, $4, $5

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  add $21, $4, $6

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  add $21, $4, $7

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  add $21, $4, $8

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  add $21, $4, $9

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  add $21, $4, $10

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  add $21, $4, $11

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  halt

org   0xF000
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0xF108
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337

org   0xF510
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0xFA18
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337

org   0xFBA0
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0xFCA8
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337

org   0xFDB0
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0xFEB8
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337
