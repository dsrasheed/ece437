// interface include
`include "prediction_unit_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module prediction_unit (
  input CLK, nRST,
  predicition_unit_if.pu puif
);

import cpu_types_pkg::*;

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
		if(puif.pred_success)
		nxt_state = TAKE1;
		else if(puif.pred_fail)
		nxt_state = TAKE2;
	TAKE2:
		if(puif.pred_success)
		nxt_state = TAKE1;
		else if(puif.pred_fail)
		nxt_state = NO_TAKE1;
	NO_TAKE1:
		if(puif.pred_success)
		nxt_state = NO_TAKE1;
		else if(puif.pred_fail)
		nxt_state = NO_TAKE2;
	NO_TAKE2:
		if(puif.pred_success)
		nxt_state = NO_TAKE1;
		else if(puif.pred_fail)
		nxt_state = TAKE1;
	default:
		nxt_state = TAKE1;
	endcase
end

assign puif.pred_branch = (puif.pc + 4) + puif.b_offset;

always_comb
begin
	puif.pred_control = 0;
	case(state)
	TAKE1:
		if(puif.PCSrc == BREQ || puif.PCSrc == BRNE)
			puif.pred_control = 1;
	TAKE2:
		if(puif.PCSrc == BREQ || puif.PCSrc == BRNE)
			puif.pred_control = 1;
	NO_TAKE1:
		puif.pred_control = 0;
	NO_TAKE2:
		puif.pred_control = 0;
	endcase
end

		
