org 0x0000
  ori   $21,$zero,0x800
  ori   $22,$zero,0xF00
  ori   $23,$zero,0xA200
  ori   $24,$zero,0xC400

  lw $1, 0($21)
  lw $2, 4($21)
  lw $3, 8($21)
  sw $3, 0($23)
  sw $2, 4($23)
  sw $1, 8($23)
  halt

org   0x00800
  cfw   0x1331
  cfw   0x4242
  cfw   0x2332

org   0x00F00
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337
