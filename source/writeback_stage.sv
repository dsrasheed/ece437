// interface include
`include "writeback_stage_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module writeback_stage (
  input CLK, nRST,
  witeback_stage_if.ws wsif
);

import cpu_types_pkg::*;

word_t mux_out;



always_comb
begin
	if(wbsif.MemToReg == 1)
	begin
		mux_out = wsif.dmemload;
	end
	else
	begin
		mux_out = wsif.aluOut;
	end
	
	if(wbsif.WriteLinkReg == 1)
	begin
		wsif.out = wsif.pc + 4;
	end
	else
	begin
		wsif.out = mux_out;
	end

endmodule
