onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CPUCLK /system_tb/DUT/CPU/CLK
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/halt
add wave -noupdate /system_tb/DUT/CPU/DP0/mem_wait
add wave -noupdate /system_tb/DUT/CPU/DP0/rinstr
add wave -noupdate /system_tb/DUT/CPU/DP1/mem_wait
add wave -noupdate /system_tb/DUT/CPU/DP1/rinstr
add wave -noupdate -expand /system_tb/DUT/CPU/DP0/track
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
add wave -noupdate -group Fetch_Stage /system_tb/DUT/CPU/DP0/fsif/out
add wave -noupdate /system_tb/DUT/CPU/DP0/FSTAGE/pcif/pc_control
add wave -noupdate /system_tb/DUT/CPU/DP0/FSTAGE/pcif/pc_en
add wave -noupdate /system_tb/DUT/CPU/DP0/FSTAGE/pcif/pred_control
add wave -noupdate /system_tb/DUT/CPU/DP0/FSTAGE/pcif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/FSTAGE/pcif/iaddr
add wave -noupdate /system_tb/DUT/CPU/DP0/FSTAGE/pcif/nxt_pc
add wave -noupdate /system_tb/DUT/CPU/DP0/FSTAGE/pcif/pred_branch
add wave -noupdate -expand -group Fetch_Latch /system_tb/DUT/CPU/DP0/flif/stall
add wave -noupdate -expand -group Fetch_Latch /system_tb/DUT/CPU/DP0/flif/flush
add wave -noupdate -expand -group Fetch_Latch -expand /system_tb/DUT/CPU/DP0/flif/in
add wave -noupdate -expand -group Fetch_Latch -expand /system_tb/DUT/CPU/DP0/flif/out
add wave -noupdate -group Decode_Stage -expand /system_tb/DUT/CPU/DP0/dsif/in
add wave -noupdate -group Decode_Stage /system_tb/DUT/CPU/DP0/dsif/out
add wave -noupdate -group Decode_Stage /system_tb/DUT/CPU/DP0/DSTAGE/extOut
add wave -noupdate -group Decode_Latch /system_tb/DUT/CPU/DP0/dlif/stall
add wave -noupdate -group Decode_Latch /system_tb/DUT/CPU/DP0/dlif/flush
add wave -noupdate -group Decode_Latch /system_tb/DUT/CPU/DP0/dlif/in
add wave -noupdate -group Decode_Latch /system_tb/DUT/CPU/DP0/dlif/out
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/ESTAGE/aluif/aluop
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/ESTAGE/aluif/ra
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/ESTAGE/aluif/rb
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/ESTAGE/aluif/out
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/ESTAGE/aluif/negative
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/ESTAGE/aluif/overflow
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/ESTAGE/aluif/zero
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/esif/in
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP0/esif/out
add wave -noupdate -group Exec_Latch /system_tb/DUT/CPU/DP0/elif/stall
add wave -noupdate -group Exec_Latch /system_tb/DUT/CPU/DP0/elif/flush
add wave -noupdate -group Exec_Latch /system_tb/DUT/CPU/DP0/elif/in
add wave -noupdate -group Exec_Latch /system_tb/DUT/CPU/DP0/elif/out
add wave -noupdate -group Mem_Stage /system_tb/DUT/CPU/DP0/msif/in
add wave -noupdate -group Mem_Stage -expand /system_tb/DUT/CPU/DP0/msif/out
add wave -noupdate -group Mem_Latch /system_tb/DUT/CPU/DP0/mlif/stall
add wave -noupdate -group Mem_Latch /system_tb/DUT/CPU/DP0/mlif/in
add wave -noupdate -group Mem_Latch /system_tb/DUT/CPU/DP0/mlif/out
add wave -noupdate /system_tb/DUT/CPU/DP0/write_back
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP0/DSTAGE/rfif/WEN
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP0/DSTAGE/reg_file/registers
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP0/DSTAGE/rfif/wsel
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP0/DSTAGE/rfif/rsel1
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP0/DSTAGE/rfif/rsel2
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP0/DSTAGE/rfif/wdat
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP0/DSTAGE/rfif/rdat1
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP0/DSTAGE/rfif/rdat2
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/PCSrc
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/rs
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/rt
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/exec_wsel
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/br_pred_result
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/zero
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/flush
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/pred_taken
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/insert_nop
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP0/huif/exec_MemRd
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/puif/pred_branch
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/puif/b_offset
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/puif/pred_control
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/puif/pred_result
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/puif/PCSrc
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/PRED_UNIT/hash_in
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/PRED_UNIT/hash_out
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/PRED_UNIT/nxt_branch
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP0/PRED_UNIT/BTS
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/mem_RegWr
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/mem_wsel
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/rs
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/rt
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/wr_RegWr
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/wr_wsel
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/rs
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/rt
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/writeback
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/aluOut
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/override_rdat1
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/new_rdat1
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/override_rdat2
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP0/fuif/new_rdat2
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/hit_count
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/CONTROL_UNIT/state
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/frame0
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/frame1
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/frame_sel
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/hit
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/will_modify
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/dcif/dhit
add wave -noupdate -expand -group {Dcache Control unit} -expand /system_tb/DUT/CPU/CM0/DCACHE/dcuif/dmemaddr
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/halt
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/load_data
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/set_valid
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/clear_dirty
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/write_tag
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/flushed
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/cache_addr
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/mem_ready
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/dREN
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/dWEN
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/daddr
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM0/DCACHE/dcuif/dstore
add wave -noupdate -expand -group {Frame 0} -label frame0 -expand /system_tb/DUT/CPU/CM0/DCACHE/FRAME0/frames
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM0/DCACHE/frame0if/set_valid
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM0/DCACHE/frame0if/store_data
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM0/DCACHE/frame0if/clear_dirty
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM0/DCACHE/frame0if/write_tag
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM0/DCACHE/frame0if/addr
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM0/DCACHE/frame0if/store
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM0/DCACHE/frame0if/hit
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM0/DCACHE/frame0if/out_frame
add wave -noupdate -expand -group {Frame 1} -label frame1 -expand /system_tb/DUT/CPU/CM0/DCACHE/FRAME1/frames
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/frame1if/set_valid
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/frame1if/store_data
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/frame1if/clear_dirty
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/frame1if/write_tag
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/frame1if/addr
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/frame1if/store
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/frame1if/hit
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/frame1if/out_frame
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/mem_ready
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/iwait
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/state
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/dwait
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/iREN
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/dREN
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/dWEN
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/dload
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/dstore
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/iaddr
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/daddr
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ccwait
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ccinv
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ccwrite
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/cctrans
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ccsnoopaddr
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ramWEN
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ramREN
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ramstate
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ramstore
add wave -noupdate -expand -group {Bus Controlle} /system_tb/DUT/CPU/CC/ccif/ramload
add wave -noupdate -expand -subitemconfig {{/system_tb/DUT/CPU/CM1/DCACHE/FRAME0/frames[2]} -expand} /system_tb/DUT/CPU/CM1/DCACHE/FRAME0/frames
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/FRAME1/frames
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/CM1/DCACHE/dcuif/ccwrite
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/CM1/DCACHE/CONTROL_UNIT/state
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/CM1/DCACHE/dcif/dmemstore
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/CM1/DCACHE/dcif/dmemWEN
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/CM1/DCACHE/dcuif/hit
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/CM1/DCACHE/dcuif/cctrans
add wave -noupdate -expand -group {Control Unit} /system_tb/DUT/CPU/CM1/DCACHE/dcuif/cache_addr
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/SNOOP_UNIT/state
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/snoop_hit
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/snoop_frame
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/ccwait
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/cctrans
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/ccwrite
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/ccinv
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/ccsnoopaddr
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/clear_dirty
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/clear_valid
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/daddr
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/dstore
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/mem_ready
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/dsuif/pr_stall
add wave -noupdate /system_tb/DUT/CPU/DP1/FSTAGE/pcif/iaddr
add wave -noupdate -group Cache-DP0-Out /system_tb/DUT/CPU/CM0/DCACHE/dcif/dhit
add wave -noupdate -group Cache-DP0-Out /system_tb/DUT/CPU/CM0/DCACHE/dcif/halt
add wave -noupdate -group Cache-DP0-Out /system_tb/DUT/CPU/CM0/DCACHE/dcif/dmemREN
add wave -noupdate -group Cache-DP0-Out /system_tb/DUT/CPU/CM0/DCACHE/dcif/dmemWEN
add wave -noupdate -group Cache-DP0-Out /system_tb/DUT/CPU/CM0/DCACHE/dcif/flushed
add wave -noupdate -group Cache-DP0-Out /system_tb/DUT/CPU/CM0/DCACHE/dcif/dmemload
add wave -noupdate -group Cache-DP0-Out /system_tb/DUT/CPU/CM0/DCACHE/dcif/dmemstore
add wave -noupdate -group Cache-DP0-Out /system_tb/DUT/CPU/CM0/DCACHE/dcif/dmemaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3343796 ps} 0}
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
WaveRestoreZoom {2818034 ps} {3818034 ps}
