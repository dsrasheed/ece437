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
    HALTED
} control_state;

control_state state, nxt_state;

logic counter_incr, just_inval, nxt_just_inval;
logic [3:0] counter_out;
logic counter_rollover;


flex_counter #(.NUM_CNT_BITS(4)) INDEX_COUNTER(
    .clk(CLK),
    .n_rst(nRST),
    .clear(1'b0),
    .count_enable(counter_incr),
    .count_out(counter_out),
    .rollover_val(4'd8),
    .rollover_flag(counter_rollover)
);

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
    begin
        state <= IDLE;
        just_inval <= 1'b1;
    end
    else
    begin
        state <= nxt_state;
        just_inval <= nxt_just_inval;
    end
end

dcache_frame selected_frame;
assign selected_frame = dcuif.frame_sel == 1 ? dcuif.frame1 : dcuif.frame0;

always_comb
begin
    nxt_state = state;
    nxt_just_inval = just_inval;
    case (state) // synthesis full_case
        IDLE:
        begin
            if (dcuif.halt)
                nxt_state = IS_FRAME0_DIRTY;
            else if (!dcuif.enable)
                nxt_state = IDLE;
            else if (!dcuif.hit && selected_frame.dirty)
            begin
                nxt_state = WRITE1;
                nxt_just_inval = 0;
            end
            else if (
                (!dcuif.hit) ||
                (dcuif.hit0 && !dcuif.frame0.dirty && dcuif.will_modify) ||
                (dcuif.hit1 && !dcuif.frame1.dirty && dcuif.will_modify)
            )
            begin
                nxt_state = LOAD1;
                nxt_just_inval = 0;
                if(dcuif.hit && dcuif.will_modify)
                begin
                    nxt_just_inval = 1;
                end
            end
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
                nxt_state = HALTED;
            else
                nxt_state = IS_FRAME0_DIRTY;
        end
        /*WRITE_HIT_COUNTER:
            if (dcuif.mem_ready) nxt_state = HALTED;*/
        HALTED:
            nxt_state = HALTED;
        default:
        begin
            nxt_state = IDLE;
        end
    endcase
end

// STATE MACHINE MEMORY CONTROL
always_comb
begin
    dcuif.daddr = '0;
    dcuif.dstore = '0;
    dcuif.dREN = 1'b0;
    dcuif.dWEN = 1'b0;
    dcuif.cctrans = 1'b0;
    dcuif.ccwrite = 1'b0;
    case (state) // synthesis full_case
        WRITE1:
        begin
            dcuif.daddr = {selected_frame.tag, dcuif.dmemaddr.idx, 3'b000};
            dcuif.dstore = selected_frame.data[0];
            dcuif.dWEN = 1'b1;
            dcuif.cctrans = 1'b1;
        end
        WRITE2:
        begin
            dcuif.daddr = {selected_frame.tag, dcuif.dmemaddr.idx, 3'b100};
            dcuif.dstore = selected_frame.data[1];
            dcuif.dWEN = 1'b1;
            dcuif.cctrans = 1'b1;
        end
        LOAD1:
        begin
            dcuif.daddr = {dcuif.dmemaddr.tag, dcuif.dmemaddr.idx, 3'b000};
            dcuif.dREN = 1'b1;
            dcuif.cctrans = 1'b1;
            dcuif.ccwrite = dcuif.will_modify;
        end
        LOAD2:
        begin
            dcuif.daddr = {dcuif.dmemaddr.tag, dcuif.dmemaddr.idx, 3'b100};
            dcuif.dREN = 1'b1;
            dcuif.cctrans = 1'b1;
            dcuif.ccwrite = dcuif.will_modify;
        end
        HALT_WRITE_F0_0:
        begin
            dcuif.daddr = {dcuif.frame0.tag, counter_out[2:0], 3'b000};
            dcuif.dstore = dcuif.frame0.data[0];
            dcuif.dWEN = 1'b1;
            dcuif.cctrans = 1'b1;
        end
        HALT_WRITE_F0_1:
        begin
            dcuif.daddr = {dcuif.frame0.tag, counter_out[2:0], 3'b100};
            dcuif.dstore = dcuif.frame0.data[1];
            dcuif.dWEN = 1'b1;
            dcuif.cctrans = 1'b1;
        end
        HALT_WRITE_F1_0:
        begin
            dcuif.daddr = {dcuif.frame1.tag, counter_out[2:0], 3'b000};
            dcuif.dstore = dcuif.frame1.data[0];
            dcuif.dWEN = 1'b1;
            dcuif.cctrans = 1'b1;
        end
        HALT_WRITE_F1_1:
        begin
            dcuif.daddr = {dcuif.frame1.tag, counter_out[2:0], 3'b100};
            dcuif.dstore = dcuif.frame1.data[1];
            dcuif.dWEN = 1'b1;
            dcuif.cctrans = 1'b1;
        end
        /*WRITE_HIT_COUNTER:
        begin
            dcuif.daddr = 32'h3100;
            dcuif.dstore = dcuif.hit_count;
            dcuif.dWEN = 1'b1;
            dcuif.cctrans = 1'b1;
        end*/
        default:
        begin
            dcuif.daddr = '0;
            dcuif.dstore = '0;
            dcuif.dREN = 1'b0;
            dcuif.dWEN = 1'b0;
            dcuif.cctrans = 1'b0;
            dcuif.ccwrite = 1'b0;
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
    dcuif.halt_frame0_ctrl = 1'b0;
    dcuif.halt_frame1_ctrl = 1'b0;
    dcuif.inv_complete = 1'b0;
    counter_incr = 0;
    case (state) // synthesis full_case
        WRITE2:
            dcuif.clear_dirty = 1'b1;
        LOAD1:
        begin
            dcuif.cache_addr.blkoff = 1'b0;
            dcuif.load_data = 1'b1;
            if(just_inval)
            begin
                dcuif.load_data = 1'b0;
            end
        end
        LOAD2:
        begin
            dcuif.cache_addr.blkoff = 1'b1;
            dcuif.load_data = 1'b1;
            dcuif.set_valid = 1'b1;
            dcuif.write_tag = 1'b1;
            if(just_inval)
            begin
                dcuif.load_data = 1'b0;
                dcuif.set_valid = 1'b0;
                dcuif.write_tag = 1'b0;
                dcuif.inv_complete = dcuif.mem_ready;
            end
        end
        IS_FRAME0_DIRTY:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
            dcuif.cache_addr.blkoff = 1'b0;
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
            dcuif.halt_frame0_ctrl = 1'b1;
            dcuif.clear_dirty = 1'b1;
        end
        IS_FRAME1_DIRTY:
        begin
            dcuif.cache_addr = '0;
            dcuif.cache_addr.idx = counter_out[2:0];
            dcuif.cache_addr.blkoff = 1'b0;
            if (!dcuif.frame1.dirty)
                counter_incr = 1'b1;
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
            counter_incr = dcuif.mem_ready;
            dcuif.halt_frame1_ctrl = 1'b1;
            dcuif.clear_dirty = 1'b1;
        end
        default:
        begin
            dcuif.load_data = 0;
            dcuif.set_valid = 0;
            dcuif.clear_dirty = 0;
            dcuif.write_tag = 0;
            dcuif.cache_addr = dcuif.dmemaddr;
            dcuif.halt_frame0_ctrl = 1'b0;
            dcuif.halt_frame1_ctrl = 1'b0;
            dcuif.inv_complete = 1'b0;
            counter_incr = 0;
        end
    endcase
end

// STATE MACHINE HIT COUNTER CONTROL
//assign dcuif.disable_hit_counter = state != IDLE;

// STATE MACHINE DATAPATH CONTROL
assign dcuif.flushed = (state == HALTED) ? 1 : 0;

endmodule
