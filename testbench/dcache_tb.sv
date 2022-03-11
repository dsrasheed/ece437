`include "caches_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module dcache_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;

  always #(PERIOD/2) CLK++;

  // interface delcaration
  caches_if cif ();
  datapath_cache_if dcif ();
  // test program setup
  test PROG (CLK, nRST, cif, dcif);

`ifndef MAPPED
  dcache DUT(CLK, nRST, cif, dcif);

`else
  dcache DUT(
    .\CLK(CLK),
    .\nRST(nRST),
    .\dcif.dmemREN(dcif.dmemREN),
    .\dcif.dmemWEN(dcif.dmemWEN),
    .\dcif.imemREN(dcif.imemREN),
    .\dcif.dmemaddr(dcif.dmemaddr),
    .\dcif.dmemstore(dcif.dmemstore),
    .\dcif.datomic(dcif.datomic),
    .\dcif.imemaddr(dcif.imemaddr),
    .\dcif.halt(dcif.halt),
    .\cif.dwait(cif.dwait),
    .\cif.dload(cif.dload),
    .\cif.dstore(cif.dstore),
    .\cif.daddr(cif.daddr),
    .\cif.dREN(cif.dREN),
    .\cif.dWEN(cif.dWEN),
    .\cif.iwait(cif.iwait),
    .\cif.iload(cif.iload),
    .\cif.iaddr(cif.iaddr),
    .\cif.iREN(cif.iREN),
    .\cif.ccwait(cif.ccwait),
    .\cif.ccinv(cif.ccinv),
    .\cif.ccsnoopaddr(cif.ccsnoopaddr)
  );
`endif

endmodule

program test
(
    input logic CLK,
    output logic nRST,
    caches_if.tb tbc,
    datapath_cache_if.tb tbdc
);
parameter PERIOD = 10;
integer test_case_num = 0;
integer instr_num = 0;

task set_dp_values;
	input logic dmemren_tb, dmemwen_tb;
	input word_t dmemaddr_tb, dmemstore_tb;
	input logic halt_tb;
	begin
		tbdc.dmemaddr = dmemaddr_tb;
		tbdc.dmemstore = dmemstore_tb;
		tbdc.dmemREN = dmemren_tb;
		tbdc.dmemWEN = dmemwen_tb;
		tbdc.halt = halt_tb;
	end
endtask

task set_mc_values;
	input logic dwait_tb;
	input word_t dload_tb;
	begin
		tbc.dload = dload_tb;
		tbc.dwait = dwait_tb;
	end
endtask

task check_values1;
	input logic expected_dren, expected_dwen;
	input word_t expected_daddr, expected_dstore;
	begin		
		if(expected_daddr == tbc.daddr)
		begin
			$display("Test Case #%0d Instr #%0d, Addr Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, Addr ERROR", test_case_num, instr_num);
		end

		if(expected_dstore == tbc.dstore)
		begin
			$display("Test Case #%0d Instr #%0d, Store Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, Store ERROR", test_case_num, instr_num);
		end

		if(expected_dren == tbc.dREN)
		begin
			$display("Test Case #%0d Instr #%0d, REN Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, REN ERROR", test_case_num, instr_num);
		end

		if(expected_dwen == tbc.dWEN)
		begin
			$display("Test Case #%0d Instr #%0d, WEN Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, WEN ERROR", test_case_num, instr_num);
		end
	end
endtask

task check_values2;
	input logic expected_dhit;
	input word_t expected_dmemload;
	begin
		if(expected_dmemload == tbdc.dmemload)
		begin
			$display("Test Case #%0d Instr #%0d, Memload Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, Memload ERROR", test_case_num, instr_num);
		end
		
		if(expected_dhit == tbdc.dhit)
		begin
			$display("Test Case #%0d Instr #%0d, Hit Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, Hit ERROR", test_case_num, instr_num);
		end
	end
endtask


initial begin

	nRST = 1;
	tbdc.imemaddr = '0;
	tbdc.imemREN = 1;
	tbdc.datomic = 0;
	tbdc.imemaddr = 0;
	tbc.ccwait = 0;
	tbc.ccinv = 0;
	tbc.ccsnoopaddr = 0;
	tbc.iwait = 1;
	tbc.iload = 0;
	set_dp_values(0, 0, 32'h0, 32'h0, 0);
	set_mc_values(1, 32'h0);

	nRST = 0;
	#(PERIOD);
	nRST = 1;

	//load from 0x80 miss
	set_dp_values(1, 0, {30'h80, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'h12345678);
	#(PERIOD);
	set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//load from 0x81 hit
	set_dp_values(1, 0, {30'h81, 2'b00}, 32'h0, 0);
	#(PERIOD);
	//store into 0x80 dirty hit
	set_dp_values(0, 1, {30'h80, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(PERIOD);
	//load from 0x80 hit
	set_dp_values(1, 0, {30'h80, 2'b00}, 32'h0, 0);
	#(PERIOD);
	//load from 0x81 hit
	set_dp_values(1, 0, {30'h81, 2'b00}, 32'h0, 0);
	#(PERIOD);
	//store to 0x81 dirty hit 
	set_dp_values(0, 1, {30'h81 2'b00}, 32'ha5a55a5a, 0);
	#(PERIOD);
	//load from 0x581 miss
	set_dp_values(1, 0, {30'h581, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hbad1bad1);
	#(PERIOD);
	set_mc_values(1, 32'hbad1bad1);
	#(PERIOD);
	set_mc_values(1, 32'h0);
	//save to 0x580 dirty hit
	set_dp_values(0, 1, {30'h580, 2'b00}, 32'hFEEDBEAF, 0);
	#(PERIOD);
	//load from 0x3fffff00 miss
	set_dp_values(1, 0, {30'h3fffff00, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(PERIOD);
	set_mc_values(1, 32'h0);
	#(PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	#(PERIOD);
	set_mc_values(0, 32'hDEADBED0);
	#(PERIOD);
	//halt
	set_mc_values(1, 32'h0);
	set_dp_values(0, 0, 32'h0, 32'h0, 1);

	#(PERIOD*10);
end





endprogram