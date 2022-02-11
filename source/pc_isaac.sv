`include "cpu_types_pkg.vh"
`include "pc_if.vh"

module pc(
  input CLK, nRST,
  pc_if.pcb pcif
);

import cpu_types_pkg::*;

logic [31:0] nxt_pc;
assign pcif.return_addr = pcif.pc + 4;

always_ff @(posedge CLK, negedge nRST) begin

	if(nRST == 0) 
	begin
		pcif.pc <= '0; 
	end	
	else 
	begin
		if(pcif.pc_en)
		begin
			pcif.pc <= nxt_pc;
		end	
	end
end

always_comb
begin
	if(pcif.pc_src == 3)
	begin
		if((pcif.branch == 1 && pcif.zero == 1) || (pcif.branch == 0 && pcif.zero == 0))
		begin
			nxt_pc = (pcif.pc + 4) + (pcif.b_addr << 2);
		end
		else
		begin
			nxt_pc = pcif.pc + 4;
		end
	end
	else if(pcif.pc_src == 2)
	begin
		nxt_pc = pcif.jr_addr;
	end
	else if(pcif.pc_src == 1)
	begin
		nxt_pc = {pcif.pc[31:28],pcif.j_addr,2'b00};
	end
	else
	begin
		nxt_pc = pcif.pc + 4;
	end
end
endmodule
