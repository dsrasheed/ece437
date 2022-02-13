onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/halt
add wave -noupdate /system_tb/DUT/CPU/DP/fetch_halt
add wave -noupdate /system_tb/DUT/CPU/DP/decode_halt
add wave -noupdate /system_tb/DUT/CPU/DP/exec_halt
add wave -noupdate /system_tb/DUT/CPU/DP/mem_halt
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wait
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memstore
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memstore
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memstore
add wave -noupdate /system_tb/DUT/halt
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate -expand -group icache /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate -expand -group Fetch_Stage /system_tb/DUT/CPU/DP/fsif/out
add wave -noupdate -expand -group Fetch_Stage /system_tb/DUT/CPU/DP/FSTAGE/pcif/pc_control
add wave -noupdate -expand -group Fetch_Stage /system_tb/DUT/CPU/DP/FSTAGE/pcif/pc_en
add wave -noupdate -expand -group Fetch_Stage /system_tb/DUT/CPU/DP/FSTAGE/pcif/iaddr
add wave -noupdate -expand -group Fetch_Stage /system_tb/DUT/CPU/DP/FSTAGE/pcif/nxt_pc
add wave -noupdate -expand -group Fetch_Latch /system_tb/DUT/CPU/DP/flif/in
add wave -noupdate -expand -group Fetch_Latch /system_tb/DUT/CPU/DP/flif/out
add wave -noupdate -expand -group Decode_Stage /system_tb/DUT/CPU/DP/dsif/in
add wave -noupdate -expand -group Decode_Stage /system_tb/DUT/CPU/DP/dsif/out
add wave -noupdate -expand -group Decode_Stage /system_tb/DUT/CPU/DP/DSTAGE/extOut
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
add wave -noupdate -expand -group dcache /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate -expand -group dcache /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate -expand -group dcache /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate -expand -group dcache /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate -expand -group dcache /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/WEN
add wave -noupdate -expand -group reg_file -expand /system_tb/DUT/CPU/DP/DSTAGE/reg_file/registers
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/wsel
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/rsel1
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/rsel2
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/wdat
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/rdat1
add wave -noupdate -expand -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/rdat2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1311810000 ps} 0}
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
WaveRestoreZoom {50 ns} {1050 ns}
