// memory types
`include "cpu_types_pkg.vh"
`include "nxt_pc_if.vh"

import cpu_types_pkg::*;

module nxt_pc (
  nxt_pc_if.npc npcif
);

// pc_src 0, 1: pc+4
//        2: jump
//        3: jr
//        4, 5: bne
//        6, 7: beq

always_comb
begin
	npcif.pc_control = 0;
	npcif.nxt_pc = '0;
	if(npcif.PCSrc == BREQ)
	begin
		if(npcif.zero == 1)
		begin
			npcif.pc_control = 1;
			npcif.nxt_pc = npcif.b_addr;
		end
	end
	else if(npcif.PCSrc == BRNE)
	begin
		if(npcif.zero == 0)
		begin
			npcif.pc_control = 1;
			npcif.nxt_pc = npcif.b_addr;
		end
	end
	else if(npcif.PCSrc == JUMPR)
	begin
		npcif.pc_control = 1;
		npcif.nxt_pc = npcif.jr_addr;
	end
	else if(npcif.PCSrc == JUMP)
	begin
		npcif.pc_control = 1;
		npcif.nxt_pc = npcif.j_addr;
	end
	else
	begin
		npcif.pc_control = 0;
	end
end

endmodule
