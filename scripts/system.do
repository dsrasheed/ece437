onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CPUCLK /system_tb/DUT/CPU/CLK
add wave -noupdate /system_tb/PROG/CLK
add wave -noupdate /system_tb/DUT/CPU/nRST
add wave -noupdate /system_tb/DUT/CPU/DP0/mem_wait
add wave -noupdate -group {Fetch Stage 0} /system_tb/DUT/CPU/DP0/FSTAGE/fsif/pc_control
add wave -noupdate -group {Fetch Stage 0} /system_tb/DUT/CPU/DP0/FSTAGE/fsif/ihit
add wave -noupdate -group {Fetch Stage 0} /system_tb/DUT/CPU/DP0/FSTAGE/fsif/pred_control
add wave -noupdate -group {Fetch Stage 0} /system_tb/DUT/CPU/DP0/FSTAGE/fsif/flush
add wave -noupdate -group {Fetch Stage 0} /system_tb/DUT/CPU/DP0/FSTAGE/fsif/nxt_pc
add wave -noupdate -group {Fetch Stage 0} /system_tb/DUT/CPU/DP0/FSTAGE/fsif/instr
add wave -noupdate -group {Fetch Stage 0} /system_tb/DUT/CPU/DP0/FSTAGE/fsif/pred_branch
add wave -noupdate -group {Fetch Stage 0} /system_tb/DUT/CPU/DP0/FSTAGE/fsif/out
add wave -noupdate -group {PC 0} /system_tb/DUT/CPU/DP0/FSTAGE/pcif/pc_control
add wave -noupdate -group {PC 0} /system_tb/DUT/CPU/DP0/FSTAGE/pcif/pc_en
add wave -noupdate -group {PC 0} /system_tb/DUT/CPU/DP0/FSTAGE/pcif/pred_control
add wave -noupdate -group {PC 0} /system_tb/DUT/CPU/DP0/FSTAGE/pcif/flush
add wave -noupdate -group {PC 0} /system_tb/DUT/CPU/DP0/FSTAGE/pcif/iaddr
add wave -noupdate -group {PC 0} /system_tb/DUT/CPU/DP0/FSTAGE/pcif/nxt_pc
add wave -noupdate -group {PC 0} /system_tb/DUT/CPU/DP0/FSTAGE/pcif/pred_branch
add wave -noupdate -group {Fetch Latch 0} /system_tb/DUT/CPU/DP0/FLATCH/flif/in
add wave -noupdate -group {Fetch Latch 0} /system_tb/DUT/CPU/DP0/FLATCH/flif/out
add wave -noupdate -group {Fetch Latch 0} /system_tb/DUT/CPU/DP0/FLATCH/flif/stall
add wave -noupdate -group {Fetch Latch 0} /system_tb/DUT/CPU/DP0/FLATCH/flif/flush
add wave -noupdate -group {Fetch Latch 0} /system_tb/DUT/CPU/DP0/flif/track_out
add wave -noupdate -group {Fetch Latch 0} /system_tb/DUT/CPU/DP0/FLATCH/flif/track_in
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/in
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/track_in
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/track_out
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/stall
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/RegWr
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/pred_taken
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/PCSrc
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/wsel
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/wdat
add wave -noupdate -group {Decode Stage 0} /system_tb/DUT/CPU/DP0/DSTAGE/dsif/out
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/opcode
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/funct
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/PCSrc
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/ALUOp
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/WrLinkReg
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/ShiftUp
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/MemRd
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/ExtOp
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/ALUSrc
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/MemToReg
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/MemWr
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/RegWr
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/RegDst
add wave -noupdate -group {Control Unit 0} /system_tb/DUT/CPU/DP0/DSTAGE/cuif/halt
add wave -noupdate -group {Reg File 0} /system_tb/DUT/CPU/DP0/DSTAGE/rfif/WEN
add wave -noupdate -group {Reg File 0} /system_tb/DUT/CPU/DP0/DSTAGE/reg_file/registers
add wave -noupdate -group {Reg File 0} /system_tb/DUT/CPU/DP0/DSTAGE/rfif/wsel
add wave -noupdate -group {Reg File 0} /system_tb/DUT/CPU/DP0/DSTAGE/rfif/rsel1
add wave -noupdate -group {Reg File 0} /system_tb/DUT/CPU/DP0/DSTAGE/rfif/rsel2
add wave -noupdate -group {Reg File 0} /system_tb/DUT/CPU/DP0/DSTAGE/rfif/wdat
add wave -noupdate -group {Reg File 0} /system_tb/DUT/CPU/DP0/DSTAGE/rfif/rdat1
add wave -noupdate -group {Reg File 0} /system_tb/DUT/CPU/DP0/DSTAGE/rfif/rdat2
add wave -noupdate -group {Pred Unit 0} /system_tb/DUT/CPU/DP0/PRED_UNIT/puif/pred_branch
add wave -noupdate -group {Pred Unit 0} /system_tb/DUT/CPU/DP0/PRED_UNIT/puif/pc_decode
add wave -noupdate -group {Pred Unit 0} /system_tb/DUT/CPU/DP0/PRED_UNIT/puif/pc_mem
add wave -noupdate -group {Pred Unit 0} /system_tb/DUT/CPU/DP0/PRED_UNIT/puif/b_offset
add wave -noupdate -group {Pred Unit 0} /system_tb/DUT/CPU/DP0/PRED_UNIT/puif/pred_control
add wave -noupdate -group {Pred Unit 0} /system_tb/DUT/CPU/DP0/PRED_UNIT/puif/pred_result
add wave -noupdate -group {Pred Unit 0} /system_tb/DUT/CPU/DP0/PRED_UNIT/puif/PCSrc
add wave -noupdate -group {Decode Latch 0} /system_tb/DUT/CPU/DP0/DLATCH/dlif/in
add wave -noupdate -group {Decode Latch 0} /system_tb/DUT/CPU/DP0/DLATCH/dlif/out
add wave -noupdate -group {Decode Latch 0} /system_tb/DUT/CPU/DP0/DLATCH/dlif/track_in
add wave -noupdate -group {Decode Latch 0} /system_tb/DUT/CPU/DP0/DLATCH/dlif/track_out
add wave -noupdate -group {Decode Latch 0} /system_tb/DUT/CPU/DP0/DLATCH/dlif/stall
add wave -noupdate -group {Decode Latch 0} /system_tb/DUT/CPU/DP0/DLATCH/dlif/flush
add wave -noupdate -group {Exec Stage 0} /system_tb/DUT/CPU/DP0/ESTAGE/esif/in
add wave -noupdate -group {Exec Stage 0} /system_tb/DUT/CPU/DP0/ESTAGE/esif/out
add wave -noupdate -group {Exec Stage 0} /system_tb/DUT/CPU/DP0/ESTAGE/esif/track_in
add wave -noupdate -group {Exec Stage 0} /system_tb/DUT/CPU/DP0/ESTAGE/esif/track_out
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/new_rdat1
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/new_rdat2
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/aluOut
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/writeback
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/rs
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/rt
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/mem_wsel
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/wr_wsel
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/override_rdat1
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/override_rdat2
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/mem_RegWr
add wave -noupdate -group {Forward 0} /system_tb/DUT/CPU/DP0/ONWARD/fuif/wr_RegWr
add wave -noupdate -group {ALU 0} /system_tb/DUT/CPU/DP0/ESTAGE/ALU/aluif/aluop
add wave -noupdate -group {ALU 0} /system_tb/DUT/CPU/DP0/ESTAGE/ALU/aluif/ra
add wave -noupdate -group {ALU 0} /system_tb/DUT/CPU/DP0/ESTAGE/ALU/aluif/rb
add wave -noupdate -group {ALU 0} /system_tb/DUT/CPU/DP0/ESTAGE/ALU/aluif/out
add wave -noupdate -group {ALU 0} /system_tb/DUT/CPU/DP0/ESTAGE/ALU/aluif/negative
add wave -noupdate -group {ALU 0} /system_tb/DUT/CPU/DP0/ESTAGE/ALU/aluif/overflow
add wave -noupdate -group {ALU 0} /system_tb/DUT/CPU/DP0/ESTAGE/ALU/aluif/zero
add wave -noupdate -group {Exec Latch 0} /system_tb/DUT/CPU/DP0/ELATCH/elif/in
add wave -noupdate -group {Exec Latch 0} /system_tb/DUT/CPU/DP0/ELATCH/elif/out
add wave -noupdate -group {Exec Latch 0} /system_tb/DUT/CPU/DP0/ELATCH/elif/track_in
add wave -noupdate -group {Exec Latch 0} /system_tb/DUT/CPU/DP0/ELATCH/elif/track_out
add wave -noupdate -group {Exec Latch 0} /system_tb/DUT/CPU/DP0/ELATCH/elif/stall
add wave -noupdate -group {Exec Latch 0} /system_tb/DUT/CPU/DP0/ELATCH/elif/flush
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/in
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/out
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/track_in
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/track_out
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/dcache_store
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/dcache_daddr
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/nxt_pc
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/dmemload
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/dcache_dREN
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/dcache_dWEN
add wave -noupdate -group {Mem Stage 0} /system_tb/DUT/CPU/DP0/MSTAGE/msif/pc_control
add wave -noupdate -group {Nxt PC 0} /system_tb/DUT/CPU/DP0/MSTAGE/NXT_PC/npcif/PCSrc
add wave -noupdate -group {Nxt PC 0} /system_tb/DUT/CPU/DP0/MSTAGE/NXT_PC/npcif/zero
add wave -noupdate -group {Nxt PC 0} /system_tb/DUT/CPU/DP0/MSTAGE/NXT_PC/npcif/pc_control
add wave -noupdate -group {Nxt PC 0} /system_tb/DUT/CPU/DP0/MSTAGE/NXT_PC/npcif/pc_4
add wave -noupdate -group {Nxt PC 0} /system_tb/DUT/CPU/DP0/MSTAGE/NXT_PC/npcif/nxt_pc
add wave -noupdate -group {Nxt PC 0} /system_tb/DUT/CPU/DP0/MSTAGE/NXT_PC/npcif/j_addr
add wave -noupdate -group {Nxt PC 0} /system_tb/DUT/CPU/DP0/MSTAGE/NXT_PC/npcif/b_addr
add wave -noupdate -group {Nxt PC 0} /system_tb/DUT/CPU/DP0/MSTAGE/NXT_PC/npcif/jr_addr
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/PCSrc
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/rs
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/rt
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/exec_wsel
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/br_pred_result
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/zero
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/flush
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/pred_taken
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/insert_nop
add wave -noupdate -group {Hazard 0} /system_tb/DUT/CPU/DP0/HAZARD_UNIT/huif/exec_MemRd
add wave -noupdate -group {Mem Latch 0} /system_tb/DUT/CPU/DP0/MLATCH/mlif/in
add wave -noupdate -group {Mem Latch 0} /system_tb/DUT/CPU/DP0/MLATCH/mlif/out
add wave -noupdate -group {Mem Latch 0} /system_tb/DUT/CPU/DP0/MLATCH/mlif/track_in
add wave -noupdate -group {Mem Latch 0} /system_tb/DUT/CPU/DP0/MLATCH/mlif/track_out
add wave -noupdate -group {Mem Latch 0} /system_tb/DUT/CPU/DP0/MLATCH/mlif/stall
add wave -noupdate -group {Frame 0} -label {Frame 0} -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/FRAME0/frames[0]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/FRAME0/frames
add wave -noupdate -group {Frame 0} -label {Frame 1} /system_tb/DUT/CPU/CM0/DCACHE/FRAME1/frames
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/addr
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/snoopaddr
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/clear_valid
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/set_valid
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/clear_dirty
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/set_dirty
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/write_tag
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/wen
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/wdat
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/hit
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/snoophit
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/hitframe
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/snoopframe
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/mem_ready
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/dmemaddr
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/nxt_state
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/nxt_snoopstate
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/valid_hitting
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/nxt_valid_hitting
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/hitting
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/nxt_hitting
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/evicting
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/nxt_evicting
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/snooping
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/nxt_snooping
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/busrdx_changing
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/flush_counter
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/nxt_flush_counter
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/LRU
add wave -noupdate -expand -group {Dcache Control 0} /system_tb/DUT/CPU/CM0/DCACHE/nxt_LRU
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/halt
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/ihit
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/imemREN
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/imemload
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/imemaddr
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/dhit
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/datomic
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/dmemREN
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/dmemWEN
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/flushed
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/dmemload
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/dmemstore
add wave -noupdate -group {Datapath 0} /system_tb/DUT/CPU/CM0/dcif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/DP1/CLK
add wave -noupdate /system_tb/DUT/CLK
add wave -noupdate /system_tb/DUT/CPU/DP1/nRST
add wave -noupdate /system_tb/DUT/CPU/DP1/mem_wait
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/out
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/pc_control
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/ihit
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/pred_control
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/flush
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/nxt_pc
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/instr
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/pred_branch
add wave -noupdate -group {Fetch Stage 1} /system_tb/DUT/CPU/DP1/FSTAGE/fsif/track_out
add wave -noupdate -group {PC 1} /system_tb/DUT/CPU/DP1/FSTAGE/PC/pcif/pc_control
add wave -noupdate -group {PC 1} /system_tb/DUT/CPU/DP1/FSTAGE/PC/pcif/pc_en
add wave -noupdate -group {PC 1} /system_tb/DUT/CPU/DP1/FSTAGE/PC/pcif/pred_control
add wave -noupdate -group {PC 1} /system_tb/DUT/CPU/DP1/FSTAGE/PC/pcif/flush
add wave -noupdate -group {PC 1} /system_tb/DUT/CPU/DP1/FSTAGE/PC/pcif/iaddr
add wave -noupdate -group {PC 1} /system_tb/DUT/CPU/DP1/FSTAGE/PC/pcif/nxt_pc
add wave -noupdate -group {PC 1} /system_tb/DUT/CPU/DP1/FSTAGE/PC/pcif/pred_branch
add wave -noupdate -group {Fetch Latch 1} /system_tb/DUT/CPU/DP1/FLATCH/flif/in
add wave -noupdate -group {Fetch Latch 1} /system_tb/DUT/CPU/DP1/FLATCH/flif/out
add wave -noupdate -group {Fetch Latch 1} /system_tb/DUT/CPU/DP1/FLATCH/flif/stall
add wave -noupdate -group {Fetch Latch 1} /system_tb/DUT/CPU/DP1/FLATCH/flif/flush
add wave -noupdate -group {Fetch Latch 1} /system_tb/DUT/CPU/DP1/FLATCH/flif/track_in
add wave -noupdate -group {Fetch Latch 1} /system_tb/DUT/CPU/DP1/FLATCH/flif/track_out
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/in
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/track_in
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/track_out
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/stall
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/RegWr
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/pred_taken
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/PCSrc
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/wsel
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/wdat
add wave -noupdate -group {Decode Stage 1} /system_tb/DUT/CPU/DP1/DSTAGE/dsif/out
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/opcode
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/funct
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/PCSrc
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/ALUOp
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/WrLinkReg
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/ShiftUp
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/MemRd
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/ExtOp
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/ALUSrc
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/MemToReg
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/MemWr
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/RegWr
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/RegDst
add wave -noupdate -group {Control Unit 1} /system_tb/DUT/CPU/DP1/DSTAGE/cuif/halt
add wave -noupdate -group {Reg File 1} /system_tb/DUT/CPU/DP1/DSTAGE/rfif/WEN
add wave -noupdate -group {Reg File 1} /system_tb/DUT/CPU/DP1/DSTAGE/reg_file/registers
add wave -noupdate -group {Reg File 1} /system_tb/DUT/CPU/DP1/DSTAGE/rfif/wsel
add wave -noupdate -group {Reg File 1} /system_tb/DUT/CPU/DP1/DSTAGE/rfif/rsel1
add wave -noupdate -group {Reg File 1} /system_tb/DUT/CPU/DP1/DSTAGE/rfif/rsel2
add wave -noupdate -group {Reg File 1} /system_tb/DUT/CPU/DP1/DSTAGE/rfif/wdat
add wave -noupdate -group {Reg File 1} /system_tb/DUT/CPU/DP1/DSTAGE/rfif/rdat1
add wave -noupdate -group {Reg File 1} /system_tb/DUT/CPU/DP1/DSTAGE/rfif/rdat2
add wave -noupdate -group {Pred Unit 1} /system_tb/DUT/CPU/DP1/PRED_UNIT/puif/pred_branch
add wave -noupdate -group {Pred Unit 1} /system_tb/DUT/CPU/DP1/PRED_UNIT/puif/pc_decode
add wave -noupdate -group {Pred Unit 1} /system_tb/DUT/CPU/DP1/PRED_UNIT/puif/pc_mem
add wave -noupdate -group {Pred Unit 1} /system_tb/DUT/CPU/DP1/PRED_UNIT/puif/b_offset
add wave -noupdate -group {Pred Unit 1} /system_tb/DUT/CPU/DP1/PRED_UNIT/puif/pred_control
add wave -noupdate -group {Pred Unit 1} /system_tb/DUT/CPU/DP1/PRED_UNIT/puif/pred_result
add wave -noupdate -group {Pred Unit 1} /system_tb/DUT/CPU/DP1/PRED_UNIT/puif/PCSrc
add wave -noupdate -group {Decode Latch 1} /system_tb/DUT/CPU/DP1/DLATCH/dlif/in
add wave -noupdate -group {Decode Latch 1} /system_tb/DUT/CPU/DP1/DLATCH/dlif/out
add wave -noupdate -group {Decode Latch 1} /system_tb/DUT/CPU/DP1/DLATCH/dlif/track_in
add wave -noupdate -group {Decode Latch 1} /system_tb/DUT/CPU/DP1/DLATCH/dlif/track_out
add wave -noupdate -group {Decode Latch 1} /system_tb/DUT/CPU/DP1/DLATCH/dlif/stall
add wave -noupdate -group {Decode Latch 1} /system_tb/DUT/CPU/DP1/DLATCH/dlif/flush
add wave -noupdate -group {Exec Stage 1} /system_tb/DUT/CPU/DP1/ESTAGE/esif/in
add wave -noupdate -group {Exec Stage 1} /system_tb/DUT/CPU/DP1/ESTAGE/esif/out
add wave -noupdate -group {Exec Stage 1} /system_tb/DUT/CPU/DP1/ESTAGE/esif/track_in
add wave -noupdate -group {Exec Stage 1} /system_tb/DUT/CPU/DP1/ESTAGE/esif/track_out
add wave -noupdate -group {ALU 1} /system_tb/DUT/CPU/DP1/ESTAGE/ALU/aluif/aluop
add wave -noupdate -group {ALU 1} /system_tb/DUT/CPU/DP1/ESTAGE/ALU/aluif/ra
add wave -noupdate -group {ALU 1} /system_tb/DUT/CPU/DP1/ESTAGE/ALU/aluif/rb
add wave -noupdate -group {ALU 1} /system_tb/DUT/CPU/DP1/ESTAGE/ALU/aluif/out
add wave -noupdate -group {ALU 1} /system_tb/DUT/CPU/DP1/ESTAGE/ALU/aluif/negative
add wave -noupdate -group {ALU 1} /system_tb/DUT/CPU/DP1/ESTAGE/ALU/aluif/overflow
add wave -noupdate -group {ALU 1} /system_tb/DUT/CPU/DP1/ESTAGE/ALU/aluif/zero
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/new_rdat1
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/new_rdat2
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/aluOut
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/writeback
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/rs
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/rt
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/mem_wsel
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/wr_wsel
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/override_rdat1
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/override_rdat2
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/mem_RegWr
add wave -noupdate -group {Forward 1} /system_tb/DUT/CPU/DP1/ONWARD/fuif/wr_RegWr
add wave -noupdate -group {Exec Latch 1} /system_tb/DUT/CPU/DP1/ELATCH/elif/in
add wave -noupdate -group {Exec Latch 1} /system_tb/DUT/CPU/DP1/ELATCH/elif/out
add wave -noupdate -group {Exec Latch 1} /system_tb/DUT/CPU/DP1/ELATCH/elif/track_in
add wave -noupdate -group {Exec Latch 1} /system_tb/DUT/CPU/DP1/ELATCH/elif/track_out
add wave -noupdate -group {Exec Latch 1} /system_tb/DUT/CPU/DP1/ELATCH/elif/stall
add wave -noupdate -group {Exec Latch 1} /system_tb/DUT/CPU/DP1/ELATCH/elif/flush
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/in
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/out
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/track_in
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/track_out
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/dcache_store
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/dcache_daddr
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/nxt_pc
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/dmemload
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/dcache_dREN
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/dcache_dWEN
add wave -noupdate -group {Mem Stage 1} /system_tb/DUT/CPU/DP1/MSTAGE/msif/pc_control
add wave -noupdate -group {Nxt PC 1} /system_tb/DUT/CPU/DP1/MSTAGE/npcif/PCSrc
add wave -noupdate -group {Nxt PC 1} /system_tb/DUT/CPU/DP1/MSTAGE/npcif/zero
add wave -noupdate -group {Nxt PC 1} /system_tb/DUT/CPU/DP1/MSTAGE/npcif/pc_control
add wave -noupdate -group {Nxt PC 1} /system_tb/DUT/CPU/DP1/MSTAGE/npcif/pc_4
add wave -noupdate -group {Nxt PC 1} /system_tb/DUT/CPU/DP1/MSTAGE/npcif/nxt_pc
add wave -noupdate -group {Nxt PC 1} /system_tb/DUT/CPU/DP1/MSTAGE/npcif/j_addr
add wave -noupdate -group {Nxt PC 1} /system_tb/DUT/CPU/DP1/MSTAGE/npcif/b_addr
add wave -noupdate -group {Nxt PC 1} /system_tb/DUT/CPU/DP1/MSTAGE/npcif/jr_addr
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/PCSrc
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/rs
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/rt
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/exec_wsel
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/br_pred_result
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/zero
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/flush
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/pred_taken
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/insert_nop
add wave -noupdate -group {Hazard 1} /system_tb/DUT/CPU/DP1/HAZARD_UNIT/huif/exec_MemRd
add wave -noupdate -group {Mem Latch 1} /system_tb/DUT/CPU/DP1/MLATCH/mlif/in
add wave -noupdate -group {Mem Latch 1} /system_tb/DUT/CPU/DP1/MLATCH/mlif/out
add wave -noupdate -group {Mem Latch 1} /system_tb/DUT/CPU/DP1/MLATCH/mlif/track_in
add wave -noupdate -group {Mem Latch 1} /system_tb/DUT/CPU/DP1/MLATCH/mlif/track_out
add wave -noupdate -group {Mem Latch 1} /system_tb/DUT/CPU/DP1/MLATCH/mlif/stall
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/halt
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/ihit
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/imemREN
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/imemload
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/imemaddr
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/dhit
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/datomic
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/dmemREN
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/dmemWEN
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/flushed
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/dmemload
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/dmemstore
add wave -noupdate -group {Datapath 1} /system_tb/DUT/CPU/CM1/dcif/dmemaddr
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/addr
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/snoopaddr
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/clear_valid
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/set_valid
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/clear_dirty
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/set_dirty
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/write_tag
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/wen
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/wdat
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/hit
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/snoophit
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/hitframe
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/snoopframe
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/mem_ready
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/dmemaddr
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/nxt_state
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/nxt_snoopstate
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/valid_hitting
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/nxt_valid_hitting
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/hitting
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/nxt_hitting
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/evicting
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/nxt_evicting
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/snooping
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/nxt_snooping
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/busrdx_changing
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/flush_counter
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/nxt_flush_counter
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/LRU
add wave -noupdate -group {Dcache Control 1} /system_tb/DUT/CPU/CM1/DCACHE/nxt_LRU
add wave -noupdate -group {Frame 1} -label {Frame 0} -expand /system_tb/DUT/CPU/CM1/DCACHE/FRAME0/frames
add wave -noupdate -group {Frame 1} -label {Frame 1} /system_tb/DUT/CPU/CM1/DCACHE/FRAME1/frames
add wave -noupdate -group {Frame 1} /system_tb/DUT/CPU/CM1/DCACHE/FRAME0/dfaif/set_valid
add wave -noupdate -group {Frame 1} /system_tb/DUT/CPU/CM1/DCACHE/FRAME0/dfaif/clear_valid
add wave -noupdate -group {Frame 1} /system_tb/DUT/CPU/CM1/DCACHE/FRAME0/dfaif/clear_dirty
add wave -noupdate -group {Frame 1} /system_tb/DUT/CPU/CM1/DCACHE/FRAME0/dfaif/write_tag
add wave -noupdate -group {Frame 1} /system_tb/DUT/CPU/CM1/DCACHE/FRAME0/dfaif/addr
add wave -noupdate -group {Frame 1} /system_tb/DUT/CPU/CM1/DCACHE/FRAME0/dfaif/hit
add wave -noupdate -group {Mem Control} /system_tb/DUT/CPU/CC/state
add wave -noupdate -group {Mem Control} /system_tb/DUT/CPU/CC/nxt_state
add wave -noupdate -group {Mem Control} /system_tb/DUT/CPU/CC/snooping
add wave -noupdate -group {Mem Control} /system_tb/DUT/CPU/CC/nxt_snooping
add wave -noupdate -group {Mem Control} /system_tb/DUT/CPU/CC/working
add wave -noupdate -group {Mem Control} /system_tb/DUT/CPU/CC/nxt_working
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramREN
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramWEN
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramaddr
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramstore
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramload
add wave -noupdate -expand -group Memory /system_tb/DUT/prif/ramstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {542648 ps} 0}
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
WaveRestoreZoom {1311915349 ps} {1313099192 ps}
