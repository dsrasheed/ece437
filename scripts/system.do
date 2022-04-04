onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CPUCLK /system_tb/DUT/CPU/CLK
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/halt
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wait
add wave -noupdate /system_tb/DUT/CPU/DP/rinstr
add wave -noupdate -expand /system_tb/DUT/CPU/DP/track
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
add wave -noupdate -group icache /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate -group icache /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate -group icache /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate -group icache /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate -group Fetch_Stage /system_tb/DUT/CPU/DP/fsif/out
add wave -noupdate /system_tb/DUT/CPU/DP/FSTAGE/pcif/pc_control
add wave -noupdate /system_tb/DUT/CPU/DP/FSTAGE/pcif/pc_en
add wave -noupdate /system_tb/DUT/CPU/DP/FSTAGE/pcif/pred_control
add wave -noupdate /system_tb/DUT/CPU/DP/FSTAGE/pcif/flush
add wave -noupdate /system_tb/DUT/CPU/DP/FSTAGE/pcif/iaddr
add wave -noupdate /system_tb/DUT/CPU/DP/FSTAGE/pcif/nxt_pc
add wave -noupdate /system_tb/DUT/CPU/DP/FSTAGE/pcif/pred_branch
add wave -noupdate -expand -group Fetch_Latch /system_tb/DUT/CPU/DP/flif/stall
add wave -noupdate -expand -group Fetch_Latch /system_tb/DUT/CPU/DP/flif/flush
add wave -noupdate -expand -group Fetch_Latch -expand /system_tb/DUT/CPU/DP/flif/in
add wave -noupdate -expand -group Fetch_Latch -expand /system_tb/DUT/CPU/DP/flif/out
add wave -noupdate -group Decode_Stage -expand /system_tb/DUT/CPU/DP/dsif/in
add wave -noupdate -group Decode_Stage /system_tb/DUT/CPU/DP/dsif/out
add wave -noupdate -group Decode_Stage /system_tb/DUT/CPU/DP/DSTAGE/extOut
add wave -noupdate -group Decode_Latch /system_tb/DUT/CPU/DP/dlif/stall
add wave -noupdate -group Decode_Latch /system_tb/DUT/CPU/DP/dlif/flush
add wave -noupdate -group Decode_Latch /system_tb/DUT/CPU/DP/dlif/in
add wave -noupdate -group Decode_Latch /system_tb/DUT/CPU/DP/dlif/out
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/ESTAGE/aluif/aluop
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/ESTAGE/aluif/ra
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/ESTAGE/aluif/rb
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/ESTAGE/aluif/out
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/ESTAGE/aluif/negative
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/ESTAGE/aluif/overflow
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/ESTAGE/aluif/zero
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/esif/in
add wave -noupdate -group Exec_Stage /system_tb/DUT/CPU/DP/esif/out
add wave -noupdate -group Exec_Latch /system_tb/DUT/CPU/DP/elif/stall
add wave -noupdate -group Exec_Latch /system_tb/DUT/CPU/DP/elif/flush
add wave -noupdate -group Exec_Latch /system_tb/DUT/CPU/DP/elif/in
add wave -noupdate -group Exec_Latch /system_tb/DUT/CPU/DP/elif/out
add wave -noupdate -group Mem_Stage /system_tb/DUT/CPU/DP/msif/in
add wave -noupdate -group Mem_Stage -expand /system_tb/DUT/CPU/DP/msif/out
add wave -noupdate -group Mem_Latch /system_tb/DUT/CPU/DP/mlif/stall
add wave -noupdate -group Mem_Latch /system_tb/DUT/CPU/DP/mlif/in
add wave -noupdate -group Mem_Latch /system_tb/DUT/CPU/DP/mlif/out
add wave -noupdate /system_tb/DUT/CPU/DP/write_back
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate -group dcache /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/WEN
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/reg_file/registers
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/wsel
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/rsel1
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/rsel2
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/wdat
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/rdat1
add wave -noupdate -group reg_file /system_tb/DUT/CPU/DP/DSTAGE/rfif/rdat2
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/PCSrc
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/rs
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/rt
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/exec_wsel
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/br_pred_result
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/zero
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/flush
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/pred_taken
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/insert_nop
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/exec_MemRd
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/puif/pred_branch
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/puif/b_offset
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/puif/pred_control
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/puif/pred_result
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/puif/PCSrc
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/PRED_UNIT/hash_in
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/PRED_UNIT/hash_out
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/PRED_UNIT/nxt_branch
add wave -noupdate -group {Prediction Unit} /system_tb/DUT/CPU/DP/PRED_UNIT/BTS
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/mem_RegWr
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/mem_wsel
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/rs
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/rt
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/wr_RegWr
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/wr_wsel
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/rs
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/rt
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/writeback
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/aluOut
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/override_rdat1
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/new_rdat1
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/override_rdat2
add wave -noupdate -group {Forward Unit} /system_tb/DUT/CPU/DP/fuif/new_rdat2
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/hit_count
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/CONTROL_UNIT/state
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/frame0
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/frame1
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/frame_sel
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/hit
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/dmemaddr
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/halt
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/load_data
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/set_valid
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/clear_dirty
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/write_tag
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/disable_hit_counter
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/flushed
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/cache_addr
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/mem_ready
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/dREN
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/dWEN
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/daddr
add wave -noupdate -expand -group {Dcache Control unit} /system_tb/DUT/CPU/CM/DCACHE/dcuif/dstore
add wave -noupdate -expand -group {Frame 0} -label frame0 /system_tb/DUT/CPU/CM/DCACHE/FRAME0/frames
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM/DCACHE/frame0if/set_valid
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM/DCACHE/frame0if/store_data
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM/DCACHE/frame0if/clear_dirty
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM/DCACHE/frame0if/write_tag
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM/DCACHE/frame0if/addr
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM/DCACHE/frame0if/store
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM/DCACHE/frame0if/hit
add wave -noupdate -expand -group {Frame 0} /system_tb/DUT/CPU/CM/DCACHE/frame0if/out_frame
add wave -noupdate -expand -group {Frame 1} -label frame1 /system_tb/DUT/CPU/CM/DCACHE/FRAME1/frames
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM/DCACHE/frame1if/set_valid
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM/DCACHE/frame1if/store_data
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM/DCACHE/frame1if/clear_dirty
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM/DCACHE/frame1if/write_tag
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM/DCACHE/frame1if/addr
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM/DCACHE/frame1if/store
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM/DCACHE/frame1if/hit
add wave -noupdate -expand -group {Frame 1} /system_tb/DUT/CPU/CM/DCACHE/frame1if/out_frame
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/hit_count
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/mem_ready
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/CONTROL_UNIT/miss_count
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/CONTROL_UNIT/access_count
add wave -noupdate -group Cache-DP-Out /system_tb/DUT/CPU/CM/DCACHE/dcif/dhit
add wave -noupdate -group Cache-DP-Out /system_tb/DUT/CPU/CM/DCACHE/dcif/halt
add wave -noupdate -group Cache-DP-Out /system_tb/DUT/CPU/CM/DCACHE/dcif/dmemREN
add wave -noupdate -group Cache-DP-Out /system_tb/DUT/CPU/CM/DCACHE/dcif/dmemWEN
add wave -noupdate -group Cache-DP-Out /system_tb/DUT/CPU/CM/DCACHE/dcif/flushed
add wave -noupdate -group Cache-DP-Out /system_tb/DUT/CPU/CM/DCACHE/dcif/dmemload
add wave -noupdate -group Cache-DP-Out /system_tb/DUT/CPU/CM/DCACHE/dcif/dmemstore
add wave -noupdate -group Cache-DP-Out /system_tb/DUT/CPU/CM/DCACHE/dcif/dmemaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {817031 ps} 0}
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
WaveRestoreZoom {1701210 ns} {1702210 ns}
