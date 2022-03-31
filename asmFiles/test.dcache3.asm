org 0x0000
  ori   $1,$zero,0xFEED
  ori   $2,$zero,0xBEEF
  ori   $3,$zero,0xFACE
  ori   $4,$zero,0xF000
  ori   $5,$zero,0x108
  ori   $6,$zero,0x510
  ori   $7,$zero,0xA18
  ori   $8,$zero,0xBA0
  ori   $9,$zero,0xCA8
  ori   $10,$zero,0xDB0
  ori   $11,$zero,0xEB8

  sw $1, 0($4)
  sw $2, 4($4)
  sw $3, 8($4)

  add $21, $4, $5

  sw $1, 0($21)
  sw $2, 4($21)
  sw $3, 8($21)

  add $21, $4, $6

  sw $1, 0($21)
  sw $2, 4($21)
  sw $3, 8($21)

  add $21, $4, $7

  sw $1, 0($21)
  sw $2, 4($21)
  sw $3, 8($21)

  add $21, $4, $8

  sw $1, 0($21)
  sw $2, 4($21)
  sw $3, 8($21)

  add $21, $4, $9

  sw $1, 0($21)
  sw $2, 4($21)
  sw $3, 8($21)

  add $21, $4, $10

  sw $1, 0($21)
  sw $2, 4($21)
  sw $3, 8($21)

  add $21, $4, $11

  sw $1, 0($21)
  sw $2, 4($21)
  sw $3, 8($21)

  halt

