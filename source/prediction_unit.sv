// interface include
`include "prediction_unit_if.vh"

// memory types
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

module prediction_unit (
  input CLK, nRST,
  prediction_unit_if.pu puif
);

import cpu_types_pkg::*;
import datapath_types_pkg::*;

logic [8:0] hash_in, hash_out;
logic [1:0] nxt_state;
//word_t BTB [511:0];
logic [1:0] BTS [511:0];
word_t nxt_branch;

parameter NO_TAKE1    = 2'b00,
	      NO_TAKE2    = 2'b01,
	      TAKE1 	  = 2'b10,
	      TAKE2 	  = 2'b11;
	  

assign hash_out = 9'h1ff & (puif.pc_decode >> 2);
assign hash_in = 9'h1ff & (puif.pc_mem >> 2);

always_ff @(posedge CLK, negedge nRST)
begin
	if(nRST == 0)
	begin
		BTS <= '{default: NO_TAKE1};
		//BTB <= '{default: '0};
		//state <= NO_TAKE1;
	end
	else
	begin
		BTS[hash_in] <= nxt_state;
		//BTB[hash_out] <= nxt_branch;
		//state <= nxt_state;
	end
end

always_comb
begin
	nxt_state = BTS[hash_in];
	case(BTS[hash_in])
	TAKE1:
	begin
		if(puif.pred_result == RIGHT_PRED)
		nxt_state = TAKE1;
		else if(puif.pred_result == WRONG_PRED)
		nxt_state = TAKE2;
	end
	TAKE2:
	begin
		if(puif.pred_result == RIGHT_PRED)
		nxt_state = TAKE1;
		else if(puif.pred_result == WRONG_PRED)
		nxt_state = NO_TAKE1;
	end
	NO_TAKE1:
	begin
		if(puif.pred_result == RIGHT_PRED)
		nxt_state = NO_TAKE1;
		else if(puif.pred_result == WRONG_PRED)
		nxt_state = NO_TAKE2;
	end
	NO_TAKE2:
	begin
		if(puif.pred_result == RIGHT_PRED)
		nxt_state = NO_TAKE1;
		else if(puif.pred_result == WRONG_PRED)
		nxt_state = TAKE1;
	end
	default:
	begin
		nxt_state = TAKE1;
	end
	endcase
end

assign puif.pred_branch = (puif.pc_decode + 4) + (puif.b_offset << 2);

always_comb
begin
	puif.pred_control = 0;
	case(BTS[hash_out])
	TAKE1:
	begin
		if(puif.PCSrc == BREQ || puif.PCSrc == BRNE)
			puif.pred_control = 1;
	end
	TAKE2:
	begin
		if(puif.PCSrc == BREQ || puif.PCSrc == BRNE)
			puif.pred_control = 1;
	end
	NO_TAKE1:
	begin
		puif.pred_control = 0;
	end
	NO_TAKE2:
	begin
		puif.pred_control = 0;
	end
	endcase
end

/*always_comb
begin
	nxt_branch = BTB[hash_out];
	if(puif.PCSrc == BREQ || puif.PCSrc == BRNE)
		nxt_branch = (puif.pc_decode + 4) + (puif.b_offset << 2);
	puif.pred_branch = BTB[hash_out];
end*/


endmodule	
