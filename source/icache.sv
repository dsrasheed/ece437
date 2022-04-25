`include "caches_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"

module icache (
	input logic CLK, nRST,
	caches_if.icache cif,
	datapath_cache_if dcif
);

import cpu_types_pkg::*;

typedef enum logic {
	HIT, MISS
} state_t;

state_t state, nxt_state;

icache_frame [15:0] cache, nxt_cache;
icachef_t addr;

icachef_t stored_addr, nxt_stored_addr;

logic hit;

assign addr = dcif.imemaddr;

always_ff @(posedge CLK, negedge nRST) 
begin
	if(nRST == 0)
	begin
		cache <= '0;
		state <= HIT;
		stored_addr <= '0;
	end
	else
	begin
		cache <= nxt_cache;
		state <= nxt_state;
		stored_addr <= nxt_stored_addr;
	end
end

assign hit = cache[addr.idx].tag == addr.tag && cache[addr.idx].valid;

always_comb begin // Next State Logic
	nxt_state = state;
	case (state)
		HIT: if (!hit && dcif.imemREN) nxt_state = MISS;
		MISS: if (!cif.iwait) nxt_state = HIT;
	endcase
end

always_comb 
begin
	dcif.ihit = 0;
	dcif.imemload = '0;
	nxt_cache = cache;
	nxt_stored_addr = stored_addr;
	cif.iREN = 1'b0;
	cif.iaddr = '0;
	case (state)
		HIT:
		begin
			if (hit && dcif.imemREN) begin
				dcif.ihit = 1'b1;
				dcif.imemload = cache[addr.idx].data;
			end
			else if (!hit && dcif.imemREN)
				nxt_stored_addr = addr;
		end
		MISS:
		begin
			cif.iREN = 1'b1;
			cif.iaddr = stored_addr;
			if (!cif.iwait) begin
				nxt_cache[stored_addr.idx].tag = stored_addr.tag;
				nxt_cache[stored_addr.idx].data = cif.iload;
				nxt_cache[stored_addr.idx].valid = 1'b1;
			end
		end
	endcase
end

endmodule
