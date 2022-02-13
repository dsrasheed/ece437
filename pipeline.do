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
add wave -noupdate -expand -group Fetch_Stage /system_tb/DUT/CPU/DP/fsif/out
add wave -noupdate -expand -group Fetch_Latch /system_tb/DUT/CPU/DP/flif/in
add wave -noupdate -expand -group Fetch_Latch /system_tb/DUT/CPU/DP/flif/out
add wave -noupdate -expand -group Decode_Stage /system_tb/DUT/CPU/DP/dsif/in
add wave -noupdate -expand -group Decode_Stage /system_tb/DUT/CPU/DP/dsif/out
add wave -noupdate -expand -group Decode_Latch /system_tb/DUT/CPU/DP/dlif/in
add wave -noupdate -expand -group Decode_Latch /system_tb/DUT/CPU/DP/dlif/out
add wave -noupdate -expand -group Exec_Stage /system_tb/DUT/CPU/DP/esif/in
add wave -noupdate -expand -group Exec_Stage /system_tb/DUT/CPU/DP/esif/out
add wave -noupdate -expand -group Exec_Latch /system_tb/DUT/CPU/DP/elif/in
add wave -noupdate -expand -group Exec_Latch /system_tb/DUT/CPU/DP/elif/out
add wave -noupdate -expand -group Mem_Stage /system_tb/DUT/CPU/DP/msif/in
add wave -noupdate -expand -group Mem_Stage /system_tb/DUT/CPU/DP/msif/out
add wave -noupdate -expand -group Mem_Latch /system_tb/DUT/CPU/DP/mlif/in
add wave -noupdate -expand -group Mem_Latch /system_tb/DUT/CPU/DP/mlif/out
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
WaveRestoreZoom {1311730 ns} {1312730 ns}
