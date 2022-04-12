onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate -expand -group {Frame 0} /dcache_tb/DUT/FRAME0/frames
add wave -noupdate -expand -group {Frame 0} /dcache_tb/DUT/frame0if/hit
add wave -noupdate -expand -group {Frame 0} /dcache_tb/DUT/frame0if/out_frame
add wave -noupdate -expand -group {Frame 1} /dcache_tb/DUT/FRAME1/frames
add wave -noupdate -expand -group {Frame 1} /dcache_tb/DUT/frame1if/hit
add wave -noupdate -expand -group {Frame 1} /dcache_tb/DUT/frame1if/out_frame
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/state
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/selected_frame
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/frame_sel
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/hit
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dmemaddr
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/halt
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/load_data
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/set_valid
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/clear_dirty
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/write_tag
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/flushed
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/cache_addr
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dREN
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dWEN
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/daddr
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dstore
add wave -noupdate -expand -group LRU /dcache_tb/DUT/LRU
add wave -noupdate -expand -group {Hit Count} /dcache_tb/DUT/hit_count
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/dwait
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/dREN
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/dWEN
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/dload
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/dstore
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/daddr
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/ccwait
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/ccinv
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/ccwrite
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/cctrans
add wave -noupdate -expand -group {Cache Control} /dcache_tb/cc0/ccsnoopaddr
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/halt
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/dhit
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/datomic
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/dmemREN
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/dmemWEN
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/flushed
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/dmemload
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/dmemstore
add wave -noupdate -expand -group Datapath /dcache_tb/dcif0/dmemaddr
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/ramREN
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/ramWEN
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/ramaddr
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/ramstore
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/ramload
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/ramstate
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/memREN
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/memWEN
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/memaddr
add wave -noupdate -expand -group Ram /dcache_tb/RAM/ramif/memstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {33386 ps} 0}
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
WaveRestoreZoom {0 ps} {250 ns}
