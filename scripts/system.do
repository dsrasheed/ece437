onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/halt
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/memstore
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/rqif/dREN
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/rqif/dWEN
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/rqif/dready
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/rqif/iready
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/rqif/drreq
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/rqif/dwreq
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/rqif/ireq
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/req_unit/state
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/rqif/stall
add wave -noupdate /system_tb/DUT/CPU/DP/reg_file/registers
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/opcode
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/funct
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/PCSrc
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/ALUOp
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/equal
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/stall
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/WrLinkReg
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/ShiftUp
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/MemRd
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/ExtOp
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/ALUSrc
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/MemToReg
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/MemWr
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/RegWr
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/RegDst
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/DP/ctrl_unit/cuif/halt
add wave -noupdate -expand -group {PC Unit} /system_tb/DUT/CPU/DP/pcif/PCSrc
add wave -noupdate -expand -group {PC Unit} /system_tb/DUT/CPU/DP/pcif/j_offset
add wave -noupdate -expand -group {PC Unit} /system_tb/DUT/CPU/DP/pcif/jr_addr
add wave -noupdate -expand -group {PC Unit} /system_tb/DUT/CPU/DP/pcif/iaddr
add wave -noupdate -expand -group {PC Unit} /system_tb/DUT/CPU/DP/pcif/b_offset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {51143 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 us}
