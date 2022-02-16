`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`include "datapath_types_pkg.vh"
import datapath_types_pkg::*;

`timescale 1 ns / 1 ns

module hazard_unit_tb;

	parameter PERIOD = 10;

	logic CLK = 0, nRST;

	// clock
	always #(PERIOD/2) CLK++;

	// interface
	hazard_unit_if huif();
	// test program
	test PROG (CLK, nRST, huif);
	// DUT
	`ifndef MAPPED
	hazard_unit DUT(CLK, nRST, huif);
	`else
	hazard_unit DUT(
	    .\huif.exec_MemRd (huif.exec_MemRd),
		.\huif.exec_wsel (huif.exec_wsel),
		.\huif.rs (huif.rs),
		.\huif.rt (huif.rt),
		.\huif.PCSrc (huif.PCSrc),
		.\huif.zero (huif.zero),
		.\huif.pred_taken (huif.pred_taken),
		.\huif.flush (huif.flush),
		.\huif.insert_nop (huif.insert_nop),
		.\huif.br_pred_result (huif.br_pred_result),
	    	.\nRST (nRST),
	    	.\CLK (CLK)
	  	);
	`endif

endmodule

program test
(
    input logic CLK,
    output logic nRST,
    hazard_unit_if.tb tbhu
);
parameter PERIOD = 10;
integer test_case_num = 0;


	task set_values;
	input pcsrc_t pcsrc_tb;
	input logic zero_tb;
	input logic pred_taken_tb;
	input logic exec_memrd_tb;
	input word_t exec_wsel_tb;
	input regbits_t rs_tb;
	input regbits_t rt_tb;
	begin
		tbhu.PCSrc = pcsrc_tb;
		tbhu.zero = zero_tb;
		tbhu.pred_taken = pred_taken_tb;
		tbhu.exec_MemRd = exec_memrd_tb;
		tbhu.exec_wsel = exec_wsel_tb;
		tbhu.rs = rs_tb;
		tbhu.rt = rt_tb;
	end
	endtask

	task check_values;
	input logic expected_nop;
	input logic expected_flush;
	input pred_t expected_result;
	begin
		if(expected_nop == tbhu.insert_nop)
		begin
			$display("Test Case #%0d, NOP Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d NOP ERROR", test_case_num);
		end

		if(expected_flush == tbhu.flush)
		begin		
			$display("Test Case #%0d, Flush Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d Flush ERROR", test_case_num);
		end
		if(expected_result == tbhu.br_pred_result)
		begin		
			$display("Test Case #%0d, Result Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d Result ERROR", test_case_num);
		end
	end
	endtask

initial begin


	
	
$finish;
end

endprogram
