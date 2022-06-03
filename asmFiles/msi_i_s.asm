#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000

# main function does something ugly but demonstrates beautifully
mainp0:
  ori $2, $0, l1
  lw  $1, 0($2)
  halt

#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1

# main function does something ugly but demonstrates beautifully
mainp1:
  ori $2, $0, l2
  lw  $1, 0($2)
  halt

l1:
  cfw 0xFEEDBEEF

l2:
  cfw 0x12345678
  cfw 0x87654321
