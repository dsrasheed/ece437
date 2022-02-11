// memory types
`include "cpu_types_pkg.vh"
`include "pc_if.vh"

import cpu_types_pkg::*;

module nxt_pc (
  input logic CLK, nRST, 
  pc_if.pc pcif
);

// pc_src 0, 1: pc+4
//        2: jump
//        3: jr
//        4, 5: bne
//        6, 7: beq

always_comb
pc_control = 0;
nxt_pc = '0;
begin
	if(pcSRC[2] == 1)
	begin
		if(pcSRC[1] == 1)
		begin
			if(zero == 1)
			begin
				pc_control = 1;
				nxt_pc = b_addr;
			end
		end
		else
		begin
			if(zero == 0)
			begin
				pc_control = 1;
				nxt_pc = b_addr;
			end
		end
	end
	else if(pcSRC[1] == 1)
	begin
		pc_control = 1;
		if(pcSRC[0] == 1)
		begin
			nxt_pc = jr_addr;
		end
		else
		begin
			nxt_pc = j_addr;
		end
	end
	else
	begin
		pc_control = 0;
	end
end

endmodule
