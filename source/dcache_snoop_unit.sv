`include "cpu_types_pkg.vh"
`include "dcache_snoop_unit_if.vh"

module dcache_snoop_unit (
    input CLK, nRST,
    dcache_snoop_unit_if.dsu dsuif
);

import cpu_types_pkg::*;

typedef enum logic[3:0] {
    IDLE, WAIT,
    HIT_M_W1, HIT_M_W2,
    HIT_S_W1, HIT_S_W2,
    TRANS_I_STATE, TRANS_S_STATE
} control_state;

control_state state, nxt_state;

always_ff @ (posedge CLK, negedge nRST)
begin
    if (nRST == 1'b0)
        state <= IDLE;
    else
        state <= nxt_state;
end

always_comb
begin
    nxt_state = state;
    case (state) // synthesis full_case
        IDLE:
        begin
            if (dsuif.ccwait & dsuif.snoop_hit & dsuif.snoop_frame.dirty)
                nxt_state = HIT_M_W1;
            else if (dsuif.ccwait & dsuif.snoop_hit)
                nxt_state = HIT_S_W1;
            else if (dsuif.ccwait)
                nxt_state = WAIT;
        end
        WAIT:
        begin
            if (!dsuif.ccwait) nxt_state = IDLE;
        end
        HIT_M_W1:
        begin
            if (dsuif.mem_ready) nxt_state = HIT_M_W2;
        end
        HIT_S_W1:
        begin
            if (dsuif.mem_ready) nxt_state = HIT_S_W2;
        end
        HIT_M_W2,
        HIT_S_W2:
        begin
            if (dsuif.mem_ready && dsuif.ccinv)
                nxt_state = TRANS_I_STATE;
            else if (dsuif.mem_ready && !dsuif.ccinv)
                nxt_state = TRANS_S_STATE;
        end
        TRANS_I_STATE,
        TRANS_S_STATE:
        begin
            if (!dsuif.ccwait) nxt_state = IDLE;
        end
        default:
        begin
            nxt_state = IDLE;
        end
    endcase
end

always_comb
begin
    dsuif.daddr = '0;
    dsuif.dstore = '0;
    case (state)
        HIT_M_W1,
        HIT_M_W2:
        begin
            dsuif.daddr = {dsuif.ccsnoopaddr.tag, dsuif.ccsnoopaddr.idx, 3'b000};
            dsuif.dstore = dsuif.snoop_frame.data[0];
        end
        HIT_S_W1,
        HIT_S_W2:
        begin
            dsuif.daddr = {dsuif.ccsnoopaddr.tag, dsuif.ccsnoopaddr.idx, 3'b100};
            dsuif.dstore = dsuif.snoop_frame.data[1];
        end
        default:
        begin
            dsuif.daddr = '0;
            dsuif.dstore = '0;
        end
    endcase
end

assign dsuif.cctrans = state != IDLE && state != WAIT;
assign dsuif.ccwrite = state == HIT_M_W1 || state == HIT_M_W2;

assign dsuif.clear_dirty = state == TRANS_I_STATE || state == TRANS_S_STATE;
assign dsuif.clear_valid = state == TRANS_I_STATE;

assign dsuif.pr_stall = dsuif.cctrans;

endmodule
