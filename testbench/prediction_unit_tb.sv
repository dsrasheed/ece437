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
	    	.\puif.pc (puif.pc),
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
	input word_t pc_tb;
	input pcsrc_t pcsrc_tb;
	input pred_t pred_result_tb;
	input word_t b_offset_tb;
	begin
		tbpu.pc = pc_tb;
		tbpu.PCSrc = pcsrc_tb;
		tbpu.pred_result = pred_result_tb;
		tbpu.b_offset = b_offset_tb;
	end
	endtask

	task check_values;
	input logic expected_control;
	input word_t expected_branch;
	begin
		if(expected_control == tbpu.pred_control)
		begin
			$display("Test Case #%0d, Control Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d Control ERROR", test_case_num);
		end

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
	
	
$finish;
end

endprogram
