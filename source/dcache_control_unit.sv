`include "cpu_types_pkg.vh"
`include "dcache_control_unit_if.vh"

module dcache_control_unit (
    input CLK, nRST,
    dcache_control_unit_if.dcu dcuif
);

import cpu_types_pkg::*;

typedef enum logic[3:0] {
    IDLE,
    WRITE1, WRITE2, LOAD1, LOAD2,
    WAIT_HIT,
    IS_FRAME0_DIRTY, IS_FRAME1_DIRTY,
    HALT_WRITE_F0_0, HALT_WRITE_F0_1, HALT_WRITE_F1_0, HALT_WRITE_F1_1,
    CHECK_FLUSH_DONE,
    WRITE_HIT_COUNTER,
    HALTED
} control_state;

control_state state, nxt_state;

logic counter_incr;
logic [3:0] counter_out;
logic counter_rollover;

flex_counter #(.NUM_CNT_BITS(4)) INDEX_COUNTER(
    .clk(CLK),
    .n_rst(nRST),
    .clear(1'b0),
    .count_enable(counter_incr && dcuif.mem_ready),
    .count_out(counter_out),
    .rollover_val(4'd8),
    .rollover_flag(counter_rollover)
);

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
        state <= IDLE;
    else
        state <= nxt_state;
end

dcache_frame selected_frame;
assign selected_frame = dcuif.frame_sel == 1 ? dcuif.frame1 : dcuif.frame0;

always_comb
begin
    nxt_state = state;
    casez (state) // synthesis full_case
        IDLE:
        begin
            if (dcuif.halt)
                nxt_state = IS_FRAME0_DIRTY;
            else if (!dcuif.hit && selected_frame.dirty)
                nxt_state = WRITE1;
            else if (!dcuif.hit && !selected_frame.dirty)
                nxt_state = LOAD1;
        end
        WRITE1:
            if (dcuif.mem_ready) nxt_state = WRITE2;
        WRITE2:
            if (dcuif.mem_ready) nxt_state = LOAD1;
        LOAD1: 
            if (dcuif.mem_ready) nxt_state = LOAD2;
        LOAD2:
            if (dcuif.mem_ready) nxt_state = WAIT_HIT;
        WAIT_HIT:
            if (dcuif.hit) nxt_state = IDLE;
        IS_FRAME0_DIRTY:
        begin
            if (dcuif.frame0.dirty) nxt_state = HALT_WRITE_F0_0;
            else nxt_state = IS_FRAME1_DIRTY;
        end
        HALT_WRITE_F0_0:
            if (dcuif.mem_ready) nxt_state = HALT_WRITE_F0_1;
        HALT_WRITE_F0_1:
            if (dcuif.mem_ready) nxt_state = IS_FRAME1_DIRTY;
        IS_FRAME1_DIRTY:
        begin
            if (dcuif.frame1.dirty) nxt_state = HALT_WRITE_F1_0;
            else nxt_state = CHECK_FLUSH_DONE;
        end 
        HALT_WRITE_F1_0:
            if (dcuif.mem_ready) nxt_state = HALT_WRITE_F1_1;
        HALT_WRITE_F1_1:
            if (dcuif.mem_ready) nxt_state = CHECK_FLUSH_DONE;
        CHECK_FLUSH_DONE:
        begin
            if (counter_rollover)
                nxt_state = WRITE_HIT_COUNTER;
            else
                nxt_state = IS_FRAME0_DIRTY;
        end
        WRITE_HIT_COUNTER:
            if (dcuif.mem_ready) nxt_state = HALTED;
    endcase
end

// STATE MACHINE MEMORY CONTROL
always_comb
begin
    dcuif.daddr = '0;
    dcuif.dstore = '0;
    dcuif.dREN = 1'b0;
    dcuif.dWEN = 1'b0;
    casez (state) // synthesis full_case
        WRITE1:
        begin
            dcuif.daddr = {selected_frame.tag, dcuif.dmemaddr.idx, 3'b000};
            dcuif.dstore = selected_frame.data[0];
            dcuif.dWEN = 1'b1;
        end
        WRITE2:
        begin
            dcuif.daddr = {selected_frame.tag, dcuif.dmemaddr.idx, 3'b100};
            dcuif.dstore = selected_frame.data[1];
            dcuif.dWEN = 1'b1;
        end
        LOAD1:
        begin
            dcuif.daddr = {dcuif.dmemaddr.tag, dcuif.dmemaddr.idx, 3'b000};
            dcuif.dREN = 1'b1;
        end
        LOAD2:
        begin
            dcuif.daddr = {dcuif.dmemaddr.tag, dcuif.dmemaddr.idx, 3'b000};
            dcuif.dREN = 1'b1;
        end
        HALT_WRITE_F0_0:
        begin
            dcuif.daddr = {dcuif.frame0.tag, counter_out, 3'b000};
            dcuif.dstore = dcuif.frame0.data[0];
            dcuif.dWEN = 1'b1;
        end
        HALT_WRITE_F0_1:
        begin
            dcuif.daddr = {dcuif.frame0.tag, counter_out, 3'b100};
            dcuif.dstore = dcuif.frame0.data[1];
            dcuif.dWEN = 1'b1;
        end
        HALT_WRITE_F1_0:
        begin
            dcuif.daddr = {dcuif.frame1.tag, counter_out, 3'b000};
            dcuif.dstore = dcuif.frame1.data[0];
            dcuif.dWEN = 1'b1;
        end
        HALT_WRITE_F1_1:
        begin
            dcuif.daddr = {dcuif.frame1.tag, counter_out, 3'b100};
            dcuif.dstore = dcuif.frame1.data[1];
            dcuif.dWEN = 1'b1;
        end
        WRITE_HIT_COUNTER:
        begin
            dcuif.daddr = 32'h3100;
            dcuif.dstore = dcuif.hit_count;
            dcuif.dWEN = 1'b1;
        end
    endcase
end

// STATE MACHINE DCACHE CONTROL
always_comb
begin
    dcuif.load_data = 0;
    dcuif.set_valid = 0;
    dcuif.clear_dirty = 0;
    dcuif.write_tag = 0;
    dcuif.cache_addr = dcuif.dmemaddr;
    counter_incr = 0;
    casez (state) // synthesis full_case
        WRITE2:
            dcuif.clear_dirty = 1'b1;
        LOAD1:
        begin
            dcuif.cache_addr.blkoff = 1'b0;
            dcuif.load_data = 1'b1;
        end
        LOAD2:
        begin
            dcuif.cache_addr.blkoff = 1'b1;
            dcuif.load_data = 1'b1;
            dcuif.set_valid = 1'b1;
            dcuif.write_tag = 1'b1;
        end
        HALT_WRITE_F0_0:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
            dcuif.cache_addr.blkoff = 1'b0;
        end
        HALT_WRITE_F0_1:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
            dcuif.cache_addr.blkoff = 1'b1;
            dcuif.clear_dirty = 1'b1;
        end
        HALT_WRITE_F1_0:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
            dcuif.cache_addr.blkoff = 1'b0;
        end
        HALT_WRITE_F1_1:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
            dcuif.cache_addr.blkoff = 1'b1;
            counter_incr = 1'b1;
        end
        IS_FRAME1_DIRTY:
        begin
            if (!dcuif.frame1.dirty)
                counter_incr = 1'b1;
        end
    endcase
end

// STATE MACHINE HIT COUNTER CONTROL
assign dcuif.disable_hit_counter = 
    state == WAIT_HIT |
    state == HALT_WRITE_F0_0 |
    state == HALT_WRITE_F0_1 |
    state == HALT_WRITE_F1_0 |
    state == HALT_WRITE_F1_1 |
    state == IS_FRAME0_DIRTY |
    state == IS_FRAME1_DIRTY ;

// STATE MACHINE DATAPATH CONTROL
assign dcuif.flushed = state == HALTED;

endmodule