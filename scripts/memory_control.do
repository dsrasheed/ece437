onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/CLK
add wave -noupdate /memory_control_tb/nRST
add wave -noupdate -color Gold /memory_control_tb/PROG/testcase
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/iwait
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/dwait
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/iREN
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/dREN
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/dWEN
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/iload
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/dload
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/dstore
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/iaddr
add wave -noupdate -expand -group Cache /memory_control_tb/DUT/ccif/daddr
add wave -noupdate -expand -group Ram /memory_control_tb/DUT/ccif/ramWEN
add wave -noupdate -expand -group Ram /memory_control_tb/DUT/ccif/ramREN
add wave -noupdate -expand -group Ram /memory_control_tb/DUT/ccif/ramstate
add wave -noupdate -expand -group Ram /memory_control_tb/DUT/ccif/ramaddr
add wave -noupdate -expand -group Ram /memory_control_tb/DUT/ccif/ramstore
add wave -noupdate -expand -group Ram /memory_control_tb/DUT/ccif/ramload
add wave -noupdate /memory_control_tb/RAM/altsyncram_component/mem_data
add wave -noupdate -expand -group Control /memory_control_tb/DUT/ccif/ccwrite
add wave -noupdate -expand -group Control /memory_control_tb/DUT/ccif/ccwait
add wave -noupdate -expand -group Control /memory_control_tb/DUT/ccif/cctrans
add wave -noupdate -expand -group Control /memory_control_tb/DUT/ccif/ccsnoopaddr
add wave -noupdate -expand -group Control /memory_control_tb/DUT/ccif/ccinv
add wave -noupdate /memory_control_tb/DUT/snooping
add wave -noupdate /memory_control_tb/DUT/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19903 ps} 0}
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
WaveRestoreZoom {0 ps} {74814 ps}
