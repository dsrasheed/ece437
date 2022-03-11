`include "prediction_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`include "datapath_types_pkg.vh"
import datapath_types_pkg::*;

`timescale 1 ns / 1 ns

module prediction_unit_tb;

	parameter PERIOD = 10;

	logic CLK = 0, nRST;

	// clock
	always #(PERIOD/2) CLK++;

	// interface
	prediction_unit_if puif ();
	// test program
	test PROG (CLK, nRST, puif);
	// DUT
	`ifndef MAPPED
	prediction_unit DUT(CLK, nRST, puif);
	`else
	predicition_unit DUT(
	    	.\puif.pc_decode (puif.pc_decode),
			.\puif.pc_mem (puif.pc_mem),
			.\puif.PCSrc (puif.PCSrc),
			.\puif.pred_result (puif.pred_result),
			.\puif.b_offset (puif.b_offset),
			.\puif.pred_result (puif.pred_result),
			.\puif.pred_control (puif.pred_control),
	    	.\nRST (nRST),
	    	.\CLK (CLK)
	  	);
	`endif

endmodule

program test
(
    input logic CLK,
    output logic nRST,
    prediction_unit_if.tb tbpu
);
parameter PERIOD = 10;
integer test_case_num = 0;


	task set_values;
	input pcsrc_t pcsrc_tb;
	input pred_t pred_result_tb;
	begin
		tbpu.PCSrc = pcsrc_tb;
		tbpu.pred_result = pred_result_tb;
	end
	endtask

	task set_values_branch;
	input word_t pc_tb;
	input word_t b_offset_tb;
	begin
		tbpu.pc_decode = pc_tb;
		tbpu.pc_mem = pc_tb;
		tbpu.b_offset = b_offset_tb;
	end
	endtask

	task check_values;
	input logic expected_control;
	begin
		if(expected_control == tbpu.pred_control)
		begin
			$display("Test Case #%0d, Control Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d Control ERROR", test_case_num);
		end
	end
	endtask

	task check_values_branch;
	input word_t expected_branch;
	begin
		if(expected_branch == tbpu.pred_branch)
		begin		
			$display("Test Case #%0d, Branch Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d Branch ERROR", test_case_num);
		end
	end
	endtask

initial begin
	
	nRST = 0;
	set_values(NEXT, NA);
	set_values_branch(32'd0, 32'd0);
	#(PERIOD);
	nRST = 1;

	@(posedge CLK);
	@(posedge CLK);
	set_values_branch(32'd0, 32'd82);
	//Take2
	set_values(NEXT, WRONG_PRED);
	@(posedge CLK);
	check_values(0);

	//NoTake1
	set_values(BREQ, WRONG_PRED);
	@(posedge CLK);
	check_values(0);

	//NoTake1
	set_values(BRNE, RIGHT_PRED);
	@(posedge CLK);
	check_values(0);

	//NoTake2
	set_values(BREQ, WRONG_PRED);
	@(posedge CLK);
	check_values(0);

	//NoTake1
	set_values(NEXT, RIGHT_PRED);
	@(posedge CLK);
	check_values(0);

	//NoTake2
	set_values(BRNE, WRONG_PRED);
	@(posedge CLK);
	check_values(0);

	//Take1
	set_values(NEXT, WRONG_PRED);
	@(posedge CLK);
	check_values(0);

	//Take1
	set_values(BREQ, RIGHT_PRED);
	@(posedge CLK);
	check_values(1);

	//Take2
	set_values(BRNE, WRONG_PRED);
	@(posedge CLK);
	check_values(1);

	//Take1
	set_values(BRNE, RIGHT_PRED);
	@(posedge CLK);
	check_values(1);

	//Take2
	set_values(BREQ, WRONG_PRED);
	@(posedge CLK);
	check_values(1);
	#(PERIOD);
	
$finish;
end

endprogram
