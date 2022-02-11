// memory types
`include "cpu_types_pkg.vh"
`include "pc_if.vh"

import cpu_types_pkg::*;

module pc (
  input logic CLK, nRST, 
  pc_if.pc pcif
);

word_t nxt_iaddr;
word_t iaddrplus4;

parameter PC_INIT = 0;

always_ff @ (posedge CLK, negedge nRST)
begin
  if (nRST == 1'b0)
    pcif.iaddr <= PC_INIT;
  else
	pcif.iaddr <= nxt_iaddr;
end

//always_comb begin
//  nxt_iaddr = pcif.iaddr;
//  iaddrplus4 = pcif.iaddr + 4;
//  casez(pcif.PCSrc)
//    NEXT:   nxt_iaddr = iaddrplus4;
//    BRANCH: nxt_iaddr = iaddrplus4 + pcif.b_offset;
//    JUMP:   nxt_iaddr = {iaddrplus4[31:28], pcif.j_offset, 2'b0};
//    JUMPR:  nxt_iaddr = pcif.jr_addr;
//  endcase
//end

always_comb 
begin
	nxt_iaddr = pcif.iaddr;
	iaddrplus4 = pcif.iaddr + 4;
	if(pcif.pc_en == 1)
	begin	
		if(pcif.pc_control == 1)
		begin
			nxt_iaddr = pcif.nxt_pc;
		end	
		else
		begin
			nxt_addr = iaddrplus4;
		end
	end
end

endmodule
