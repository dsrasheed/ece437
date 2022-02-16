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

logic [1:0] state, nxt_state;

parameter TAKE1    = 2'b00,
	      TAKE2    = 2'b01,
	      NO_TAKE1 = 2'b10,
	      NO_TAKE2 = 2'b11;
	  

always_ff @(posedge CLK, negedge nRST)
begin
	if(nRST == 0)
	begin
		state <= TAKE1;
	end
	else
	begin
		state <= nxt_state;
	end
end

always_comb
begin
	nxt_state = state;
	case(state)
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

assign puif.pred_branch = (puif.pc + 4) + puif.b_offset;

always_comb
begin
	puif.pred_control = 0;
	case(state)
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

endmodule	
