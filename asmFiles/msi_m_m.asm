#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000

# main function does something ugly but demonstrates beautifully
mainp0:
  ori $1, $0, 1
  ori $3, $0, 3
  ori $2, $0, l1
  sw  $1, 0($2)
  nop
  nop
  nop
  nop
  sw  $3, 0($2)
  nop
  nop
  halt

#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1

# main function does something ugly but demonstrates beautifully
mainp1:
  ori $1, $0, 2
  ori $3, $0, 4
  ori $2, $0, l2
  nop
  nop
  sw  $1, 0($2)
  nop
  nop
  sw  $3, 0($2)
  halt

l1:
  cfw 0x0

l2:
  cfw 0x0
