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
	hazard_unit DUT(huif);
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
	input regbits_t exec_wsel_tb;
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

	task check_values_struct;
	input logic expected_nop;
	begin
		if(expected_nop == tbhu.insert_nop)
		begin
			$display("Test Case #%0d, NOP Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d NOP ERROR", test_case_num);
		end
	end
	endtask

	task check_values_control;
	input logic expected_flush;
	input pred_t expected_result;
	begin
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

	nRST = 0;
	set_values(NEXT, 0, 0, 0, 5'b0, 5'b0, 5'b0);
	#(PERIOD);
	nRST = 1;

    test_case_num += 1;
	set_values(BREQ, 1, 0, 0, 5'b0, 5'b0, 5'b0);
	@(posedge CLK);
	check_values_control(1, WRONG_PRED);
  
	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 0, 0, 0, 5'b0, 5'b0, 5'b0);
	@(posedge CLK);
	check_values_control(0, RIGHT_PRED);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 0, 1, 0, 5'b0, 5'b0, 5'b0);
	@(posedge CLK);
	check_values_control(1, WRONG_PRED);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 0, 5'b0, 5'b0, 5'b0);
	@(posedge CLK);
	check_values_control(0, RIGHT_PRED);

	#(PERIOD);

	test_case_num += 1;
	set_values(BRNE, 1, 0, 0, 5'b0, 5'b0, 5'b0);
	@(posedge CLK);
	check_values_control(0, RIGHT_PRED);
  
	#(PERIOD);

	test_case_num += 1;
	set_values(BRNE, 0, 0, 0, 5'b0, 5'b0, 5'b0);
	@(posedge CLK);
	check_values_control(1, WRONG_PRED);

	#(PERIOD);

	test_case_num += 1;
	set_values(BRNE, 0, 1, 0, 5'b0, 5'b0, 5'b0);
	@(posedge CLK);
	check_values_control(0, RIGHT_PRED);

	#(PERIOD);

	test_case_num += 1;
	set_values(BRNE, 1, 1, 0, 5'b0, 5'b0, 5'b0);
	@(posedge CLK);
	check_values_control(1, WRONG_PRED);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 1, 5'd12, 5'd0, 5'd0);
	@(posedge CLK);
	check_values_struct(0);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 1, 5'd12, 5'd12, 5'd0);
	@(posedge CLK);
	check_values_struct(1);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 1, 5'd6, 5'd0, 5'd6);
	@(posedge CLK);
	check_values_struct(1);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 1, 5'd16, 5'd16, 5'd16);
	@(posedge CLK);
	check_values_struct(1);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 0, 5'd31, 5'd31, 5'd0);
	@(posedge CLK);
	check_values_struct(0);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 0, 5'd23, 5'd0, 5'd23);
	@(posedge CLK);
	check_values_struct(0);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 0, 5'd20, 5'd20, 5'd20);
	@(posedge CLK);
	check_values_struct(0);

	#(PERIOD);

	test_case_num += 1;
	set_values(BREQ, 1, 1, 1, 5'd0, 5'd0, 5'd0);
	@(posedge CLK);
	check_values_struct(0);
	
$finish;
end

endprogram
