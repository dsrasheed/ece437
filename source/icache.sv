`include "caches_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"

module icache (
	input logic CLK, nRST,
	caches_if.icache cif,
	datapath_cache_if dcif
);

import cpu_types_pkg::*;

icache_frame [15:0] cache;
icachef_t addr;

logic miss, nxt_valid;
logic [25:0] nxt_tag;
logic [31:0] nxt_data; 


assign addr.tag = dcif.imemaddr[31:6];
assign addr.idx = dcif.imemaddr[5:2];
assign addr.bytoff = dcif.imemaddr[1:0];

always_ff @(posedge CLK, negedge nRST) 
begin
	if(nRST == 0) 
	begin
		cache <= '0;
	end 
	else 
	begin
		cache[addr.idx].tag <= nxt_tag;
		cache[addr.idx].data <= nxt_data;
		cache[addr.idx].valid <= nxt_valid;
	end
end

always_comb 
begin
	miss = 0;
	dcif.ihit = 0;
	dcif.imemload = 0;
	if(dcif.imemREN == 1 && dcif.dmemREN == 0 && dcif.dmemWEN == 0) 
	begin
		if(cache[addr.idx].tag == addr.tag && cache[addr.idx].valid == 1) 
		begin
			dcif.ihit = 1;
			dcif.imemload = cache[addr.idx].data;
		end 
		else 
		begin
			miss = 1;
			dcif.ihit = ~cif.iwait;
			dcif.imemload = cif.iload;
		end
	end 
end

always_comb
begin
	nxt_data = cache[addr.idx].data;
	nxt_tag = cif.iload;
	nxt_valid = cache[addr.idx].valid;
	if(cif.iwait == 0)
	begin 
		nxt_data = cif.iload;
		nxt_tag = dcif.imemaddr[31:6];
		nxt_valid = 1;
	end
end

assign cif.iREN = miss ? dcif.imemREN : 0;
assign cif.iaddr = miss ? dcif.imemaddr : '0;

endmodule
