`include "forwarding_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`include "datapath_types_pkg.vh"
import datapath_types_pkg::*;

`timescale 1 ns / 1 ns

module forwarding_unit_tb;

	parameter PERIOD = 10;

	logic CLK = 0, nRST;

	// clock
	always #(PERIOD/2) CLK++;

	// interface
	forwarding_unit_if fuif();
	// test program
	test PROG (CLK, nRST, fuif);
	// DUT
	`ifndef MAPPED
	forwarding_unit DUT(fuif);
	`else
	forwarding_unit DUT(
	    	.\fuif.new_rdat1 (fuif.new_rdat1),
		.\fuif.override_rdat1 (fuif.override_rdat1),
		.\fuif.new_rdat2 (fuif.new_rdat2),
		.\fuif.override_rdat2 (fuif.override_rdat2),
		.\fuif.aluOut (fuif.aluOut),
		.\fuif.writeback (fuif.writeback),
		.\fuif.mem_wsel (fuif.mem_wsel),
		.\fuif.mem_RegWr (fuif.mem_RegWr),
		.\fuif.wr_wsel (fuif.wr_wsel),
		.\fuif.wr_RegWr (fuif.wr_RegWr),
		.\fuif.rs (fuif.rs),
		.\fuif.rt (fuif.rt),
	    	.\nRST (nRST),
	    	.\CLK (CLK)
	  	);
	`endif

endmodule

program test
(
    input logic CLK,
    output logic nRST,
    forwarding_unit_if.tb tbfu
);
parameter PERIOD = 10;
integer test_case_num = 0;


	task set_values;
	input logic mem_regwr_tb;
	input logic wr_regwr_tb;
	input regbits_t mem_wsel_tb;
	input regbits_t wr_wsel_tb;
	input word_t writeback_tb;
	input word_t aluout_tb;
	input regbits_t rs_tb;
	input regbits_t rt_tb;
	begin
		tbfu.mem_wsel = mem_wsel_tb;
		tbfu.mem_RegWr = mem_regwr_tb;
		tbfu.wr_wsel = wr_wsel_tb;
		tbfu.wr_RegWr = wr_regwr_tb;
		tbfu.aluOut = aluout_tb;
		tbfu.writeback = writeback_tb;
		tbfu.rs = rs_tb;
		tbfu.rt = rt_tb;
	end
	endtask

	task check_values1;
	input word_t expected_new1;
	input logic expected_override1;
	begin
		if(expected_new1 == tbfu.new_rdat1)
		begin
			$display("Test Case #%0d, RDAT1 Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d RDAT1 ERROR", test_case_num);
		end

		if(expected_override1 == tbfu.override_rdat1)
		begin		
			$display("Test Case #%0d, Override1 Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d Override1 ERROR", test_case_num);
		end
	end
	endtask

	task check_values2;
	input word_t expected_new2;
	input logic expected_override2;
	begin
		if(expected_new2 == tbfu.new_rdat2)
		begin
			$display("Test Case #%0d, RDAT2 Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d RDAT2 ERROR", test_case_num);
		end

		if(expected_override2 == tbfu.override_rdat2)
		begin		
			$display("Test Case #%0d, Override2 Success", test_case_num);
		end
		else
		begin
			$display("Test Case #%0d Override2 ERROR", test_case_num);
		end
	end
	endtask

initial begin
	
	nRST = 0;
	set_values(0, 0, 5'd0, 5'd0, 32'd0, 32'd0, 5'd0, 5'd0);
	#(PERIOD);
	nRST = 1;

	@(posedge CLK);

	test_case_num += 1;
	set_values(0, 0, 5'd0, 5'd0, 32'd23, 32'd55, 5'd0, 5'd0);
	@(posedge CLK);
	check_values1(32'd0, 0);
	check_values2(32'd0, 0);

	#(PERIOD);

	test_case_num += 1;
	set_values(1, 1, 5'd5, 5'd6, 32'd12, 32'd62, 5'd5, 5'd6);
	@(posedge CLK);
	check_values1(32'd62, 1);
	check_values2(32'd12, 1);
	
	#(PERIOD);

	test_case_num += 1;
	set_values(1, 1, 5'd5, 5'd5, 32'd12, 32'd62, 5'd5, 5'd5);
	@(posedge CLK);
	check_values1(32'd62, 1);
	check_values2(32'd62, 1);

	#(PERIOD);

	test_case_num += 1;
	set_values(1, 1, 5'd3, 5'd4, 32'd12, 32'd62, 5'd7, 5'd8);
	@(posedge CLK);
	check_values1(32'd0, 0);
	check_values2(32'd0, 0);

	#(PERIOD);

	test_case_num += 1;
	set_values(1, 0, 5'd5, 5'd6, 32'd12, 32'd62, 5'd5, 5'd6);
	@(posedge CLK);
	check_values1(32'd62, 1);
	check_values2(32'd0, 0);

$finish;
end

endprogram
