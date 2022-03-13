onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/DUT/frame0if/dload
add wave -noupdate /dcache_tb/DUT/frame0if/dmemstore
add wave -noupdate /dcache_tb/DUT/frame0if/dmemWEN
add wave -noupdate /dcache_tb/DUT/hit
add wave -noupdate -expand -group {Frame 0} /dcache_tb/DUT/FRAME0/frames
add wave -noupdate -expand -group {Frame 0} /dcache_tb/DUT/frame0if/hit
add wave -noupdate -expand -group {Frame 0} -expand /dcache_tb/DUT/frame0if/out_frame
add wave -noupdate -expand -group {Frame 0} /dcache_tb/DUT/frame0if/replace
add wave -noupdate -expand -group {Frame 1} /dcache_tb/DUT/FRAME1/frames
add wave -noupdate -expand -group {Frame 1} /dcache_tb/DUT/frame1if/hit
add wave -noupdate -expand -group {Frame 1} /dcache_tb/DUT/frame1if/out_frame
add wave -noupdate -expand -group {Frame 1} /dcache_tb/DUT/frame1if/replace
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/state
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/selected_frame
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/frame_sel
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/hit
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dmemaddr
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/halt
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/write_offset
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/load_data
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/set_valid
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/clear_dirty
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/write_tag
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/decr_counter
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/latch_en
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/flushed
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/cache_addr
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dREN
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dWEN
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dwait
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/daddr
add wave -noupdate -expand -group {Control Unit} /dcache_tb/DUT/CONTROL_UNIT/dcuif/dstore
add wave -noupdate -expand -group LRU /dcache_tb/DUT/LRU
add wave -noupdate -expand -group {Hit Count} /dcache_tb/DUT/hit_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76 ns} 0}
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
WaveRestoreZoom {0 ns} {250 ns}
