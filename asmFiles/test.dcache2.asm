org 0x0000
  ori   $10,$zero,0xF0000
  ori   $11,$zero,0x108
  ori   $12,$zero,0x510
  ori   $13,$zero,0xA18
  ori   $14,$zero,0xBA0
  ori   $15,$zero,0xCA8
  ori   $16,$zero,0xDB0
  ori   $17,$zero,0xEB8

  addu $21, $zero, $10

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  addu $21, $10, $11

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  addu $21, $10, $12

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  addu $21, $10, $12

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  addu $21, $10, $13

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  addu $21, $10, $14

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  addu $21, $10, $15

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  addu $21, $10, $16

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  addu $21, $10, $17

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)

  halt

org   0xF0000
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0xF0108
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337

org   0xF0510
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0xF0A18
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337

org   0xF0BA0
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0xF0CA8
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337

org   0xF0DB0
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0xF0EB8
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337
