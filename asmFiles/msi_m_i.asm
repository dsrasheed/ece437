#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000

# main function does something ugly but demonstrates beautifully
mainp0:
  ori $2, $0, l1
  lw  $1, 0($2)

  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  lui $1, 0xFACE
  sw  $1, 0($2)

  nop
  nop
  nop
  nop
  nop
  nop

  halt

#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1

# main function does something ugly but demonstrates beautifully
mainp1:
  nop
  nop
  nop
  nop
  nop
  nop

  ori $2, $0, l1
  lw  $1, 0($2)

  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  lui $1, 0x1234
  sw  $1, 0($2)

  halt

l1:
  cfw 0xFEEDBEEF
