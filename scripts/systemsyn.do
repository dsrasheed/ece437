onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/req_unit/ruifdwreq
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/req_unit/ruifdrreq
add wave -noupdate -expand -group {Request Unit} /system_tb/DUT/CPU/DP/req_unit/ruifstall
add wave -noupdate -expand -group PC /system_tb/DUT/CPU/DP/PC/pcifiaddr_0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {739282 ps} 0}
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
WaveRestoreZoom {1310550 ns} {1311550 ns}
