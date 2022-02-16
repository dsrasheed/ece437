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
	forwarding_unit_if fuif ();
	// test program
	test PROG (CLK, nRST, fuif);
	// DUT
	`ifndef MAPPED
	forwarding_unit DUT(CLK, nRST, fuif);
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
	input word_t mem_wsel_tb;
	input word_t wr_wsel_tb;
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

		if(expected_override1 == tbru.override_rdat1)
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

		if(expected_override2 == tbru.override_rdat2)
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
	
	
$finish;
end

endprogram
