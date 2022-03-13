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
    SET_CACHE_ADDR,
    HALT_WRITE1, HALT_WRITE2, HALT_WRITE3, HALT_WRITE4,
    CONTINUE_FLUSH,
    WRITE_HIT_COUNTER,
    HALTED
} control_state;

control_state state, nxt_state;

logic counter_incr;
logic [3:0] counter_out;
logic counter_rollover;

flex_counter #(.NUM_CNT_BITS(4)) INDEX_CNTER(
    .clk(CLK),
    .n_rst(nRST),
    .clear(1'b0),
    .count_enable(counter_incr && dcuif.latch_en),
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
                nxt_state = SET_CACHE_ADDR;
            else if (!dcuif.hit && selected_frame.dirty)
                nxt_state = WRITE1;
            else if (!dcuif.hit && !selected_frame.dirty)
                nxt_state = LOAD1;
        end
        WRITE1:
            if (dcuif.latch_en) nxt_state = WRITE2;
        WRITE2:
            if (dcuif.latch_en) nxt_state = LOAD1;
        LOAD1: 
            if (dcuif.latch_en) nxt_state = LOAD2;
        LOAD2:
            if (dcuif.latch_en) nxt_state = IDLE;
        SET_CACHE_ADDR:
            nxt_state = HALT_WRITE1;
        HALT_WRITE1:
            if (dcuif.latch_en) nxt_state = HALT_WRITE2;
        HALT_WRITE2:
            if (dcuif.latch_en) nxt_state = HALT_WRITE3;
        HALT_WRITE3:
            if (dcuif.latch_en) nxt_state = HALT_WRITE4;
        HALT_WRITE4:
            if (dcuif.latch_en) nxt_state = CONTINUE_FLUSH;
        CONTINUE_FLUSH:
        begin
            if (counter_rollover)
                nxt_state = WRITE_HIT_COUNTER;
            else
                nxt_state = SET_CACHE_ADDR;
        end
        WRITE_HIT_COUNTER:
            if (dcuif.latch_en) nxt_state = HALTED;
    endcase
end

// STATE MACHINE MEMORY CONTROL
assign dcuif.latch_en = ~dcuif.dwait;
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
        HALT_WRITE1:
        begin
            dcuif.daddr = {dcuif.frame0.tag, counter_out, 3'b000};
            dcuif.dstore = dcuif.frame0.data[0];
            dcuif.dWEN = 1'b1;
        end
        HALT_WRITE2:
        begin
            dcuif.daddr = {dcuif.frame0.tag, counter_out, 3'b100};
            dcuif.dstore = dcuif.frame0.data[1];
            dcuif.dWEN = 1'b1;
        end
        HALT_WRITE3:
        begin
            dcuif.daddr = {dcuif.frame1.tag, counter_out, 3'b000};
            dcuif.dstore = dcuif.frame1.data[0];
            dcuif.dWEN = 1'b1;
        end
        HALT_WRITE4:
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
    dcuif.write_offset = 0;
    dcuif.load_data = 0;
    dcuif.set_valid = 0;
    dcuif.clear_dirty = 0;
    dcuif.write_tag = 0;
    dcuif.cache_addr = dcuif.dmemaddr;
    dcuif.flushed = 0;
    dcuif.decr_counter = 0;
    counter_incr = 0;
    casez (state) // synthesis full_case
        WRITE2:
            dcuif.clear_dirty = 1'b1;
        LOAD1:
        begin
            dcuif.write_offset = 1'b0;
            dcuif.load_data = 1'b0;
            dcuif.decr_counter = 1'b1;
        end
        LOAD2:
        begin
            dcuif.write_offset = 1'b1;
            dcuif.load_data = 1'b1;
            dcuif.set_valid = 1'b1;
            dcuif.write_tag = 1'b1;
        end
        SET_CACHE_ADDR:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
        end
        HALT_WRITE1:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
        end
        HALT_WRITE2:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
        end
        HALT_WRITE3:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
        end
        HALT_WRITE4:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
            counter_incr = 1'b1;
        end
        HALTED:
        begin
            dcuif.flushed = 1'b1;
        end
    endcase
end


endmodule