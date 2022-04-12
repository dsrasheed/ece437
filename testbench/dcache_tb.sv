`include "caches_if.vh"
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module dcache_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;

  always #(PERIOD/2) CLK++;

  caches_if cc0 ();
	caches_if cc1 ();
  datapath_cache_if dcif0 ();
	datapath_cache_if dcif1 ();
  cpu_ram_if prif ();
  cache_control_if #(.CPUS(1)) ccif (cc0, cc1);
	system_if syif ();
  
  test PROG (CLK, nRST, cc0, dcif0, cc1, dcif1);

`ifndef MAPPED
  dcache DUT(CLK, nRST, cc0, dcif0);
	dcache DUT1(CLK, nRST, cc1, dcif1);

`else
  dcache DUT(
    .\CLK(CLK),
    .\nRST(nRST),
    .\dcif.dmemREN(dcif0.dmemREN),
    .\dcif.dmemWEN(dcif0.dmemWEN),
    .\dcif.imemREN(dcif0.imemREN),
    .\dcif.dmemaddr(dcif0.dmemaddr),
    .\dcif.dmemstore(dcif0.dmemstore),
    .\dcif.datomic(dcif0.datomic),
    .\dcif.imemaddr(dcif0.imemaddr),
    .\dcif.halt(dcif0.halt),
    .\cif.dwait(cc0.dwait),
    .\cif.dload(cc0.dload),
    .\cif.dstore(cc0.dstore),
    .\cif.daddr(cc0.daddr),
    .\cif.dREN(cc0.dREN),
    .\cif.dWEN(cc0.dWEN),
    .\cif.iwait(cc0.iwait),
    .\cif.iload(cc0.iload),
    .\cif.iaddr(cc0.iaddr),
    .\cif.iREN(cc0.iREN),
    .\cif.ccwait(cc0.ccwait),
    .\cif.ccinv(cc0.ccinv),
    .\cif.ccsnoopaddr(cc0.ccsnoopaddr)
  );
	dcache DUT1(
    .\CLK(CLK),
    .\nRST(nRST),
    .\dcif.dmemREN(dcif1.dmemREN),
    .\dcif.dmemWEN(dcif1.dmemWEN),
    .\dcif.imemREN(dcif1.imemREN),
    .\dcif.dmemaddr(dcif1.dmemaddr),
    .\dcif.dmemstore(dcif1.dmemstore),
    .\dcif.datomic(dcif1.datomic),
    .\dcif.imemaddr(dcif1.imemaddr),
    .\dcif.halt(dcif1.halt),
    .\cif.dwait(cc1.dwait),
    .\cif.dload(cc1.dload),
    .\cif.dstore(cc1.dstore),
    .\cif.daddr(cc1.daddr),
    .\cif.dREN(cc1.dREN),
    .\cif.dWEN(cc1.dWEN),
    .\cif.iwait(cc1.iwait),
    .\cif.iload(cc1.iload),
    .\cif.iaddr(cc1.iaddr),
    .\cif.iREN(cc1.iREN),
    .\cif.ccwait(cc1.ccwait),
    .\cif.ccinv(cc1.ccinv),
    .\cif.ccsnoopaddr(cc1.ccsnoopaddr)
  );
`endif

  ram RAM (CLK, nRST, prif);

  assign ccif.ramload = prif.ramload;
  assign ccif.ramstate = prif.ramstate;

  assign syif.load = prif.ramload;

  assign prif.ramREN = ccif.ramREN;
  assign prif.ramWEN = ccif.ramWEN;
  assign prif.ramaddr = ccif.ramaddr;
  assign prif.ramstore = ccif.ramstore;

  memory_control MEM (CLK, nRST, ccif);
	
	assign prif.memaddr = ccif.ramaddr;
	assign prif.memstore = ccif.ramstore;
	assign prif.memREN = ccif.ramREN;
	assign prif.memWEN = ccif.ramWEN;

endmodule

program test
(
    input logic CLK,
    output logic nRST,
    caches_if cc0,
    datapath_cache_if dcif0,
		caches_if cc1,
		datapath_cache_if dcif1
);
parameter PERIOD = 10;
integer test_case_num = 0;
integer instr_num = 0;

task set_dp_values;
	input logic dmemren_tb, dmemwen_tb;
	input word_t dmemaddr_tb, dmemstore_tb;
	input logic halt_tb;
	begin
		dcif0.dmemaddr = dmemaddr_tb;
		dcif0.dmemstore = dmemstore_tb;
		dcif0.dmemREN = dmemren_tb;
		dcif0.dmemWEN = dmemwen_tb;
		dcif0.halt = halt_tb;
	end
endtask

/*task set_mc_values;
	input logic dwait_tb;
	input word_t dload_tb;
	begin
		tbc.dload = dload_tb;
		tbc.dwait = dwait_tb;
	end
endtask*/

/*task check_values1;
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
endtask*/

task check_values2;
	input logic expected_dhit;
	input word_t expected_dmemload;
	begin
		if(expected_dmemload == dcif0.dmemload)
		begin
			$display("Test Case #%0d Instr #%0d, Memload Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, Memload ERROR", test_case_num, instr_num);
		end
		
		if(expected_dhit == dcif0.dhit)
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
	cc0.iaddr = '0;
	cc0.iREN = 1;
	dcif0.datomic = 0;
	set_dp_values(0, 0, 32'h0, 32'h0, 0);
	//set_mc_values(1, 32'h0);

	nRST = 0;
	#(2*PERIOD);
	nRST = 1;

	//load to all in frame0
	//load from 0x80 miss
	#(3*PERIOD);
	set_dp_values(1, 0, {26'h0, 3'd0, 1'b1, 2'b00}, 32'h0, 0);
	//set_mc_values(1, 32'h0);
	#(3*PERIOD);
	//set_mc_values(0, 32'h12345678);
	#(3*PERIOD);
	//set_mc_values(1, 32'h0);
	#(PERIOD);
	//set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//set_mc_values(1, 32'h0);
	//load from 0xA2 miss
	set_dp_values(1, 0, {30'hA2, 2'b00}, 32'h0, 0);
	//set_mc_values(0, 32'h12345678);
	#(2*PERIOD);
	//set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//load from 0xC4 miss
	set_dp_values(1, 0, {30'hC4, 2'b00}, 32'h0, 0);
	//set_mc_values(0, 32'h12345678);
	#(2*PERIOD);
	//set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//load from 0x106 miss
	set_dp_values(1, 0, {30'h106, 2'b00}, 32'h0, 0);
	//set_mc_values(0, 32'h12345678);
	#(2*PERIOD);
	//set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//load from 0x148 miss
	set_dp_values(1, 0, {30'h148, 2'b00}, 32'h0, 0);
	//set_mc_values(0, 32'h12345678);
	#(2*PERIOD);
	//set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//load from 0x18A miss
	set_dp_values(1, 0, {30'h18A, 2'b00}, 32'h0, 0);
	//set_mc_values(0, 32'h12345678);
	#(2*PERIOD);
	//set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//load from 0x1AC miss
	set_dp_values(1, 0, {30'h1AC, 2'b00}, 32'h0, 0);
	//set_mc_values(0, 32'h12345678);
	#(2*PERIOD);
	//set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//load from 0x24E miss
	set_dp_values(1, 0, {30'h24E, 2'b00}, 32'h0, 0);
	//set_mc_values(0, 32'h12345678);
	#(2*PERIOD);
	//set_mc_values(0, 32'h87654321);
	#(PERIOD);
	//load from 0x81 hit
	set_dp_values(1, 0, {30'h81, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0xA3 hit
	set_dp_values(1, 0, {30'hA3, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0xC5 hit
	set_dp_values(1, 0, {30'hC5, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0x107 hit
	set_dp_values(1, 0, {30'h107, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0x149 hit
	set_dp_values(1, 0, {30'h149, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0x18B hit
	set_dp_values(1, 0, {30'h18B, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0x1AD hit
	set_dp_values(1, 0, {30'h1AD, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0x24F hit
	set_dp_values(1, 0, {30'h24F, 2'b00}, 32'h0, 0);
	#(2*PERIOD);

	//store cases
	//store into 0x80 dirty hit
	set_dp_values(0, 1, {30'h80, 2'b00}, 32'h5a5aa5a5, 0);
	#(2*PERIOD);
	//store into 0x81 dirty hit
	set_dp_values(0, 1, {30'h81, 2'b00}, 32'ha5a55a5a, 0);
	#(2*PERIOD);
	//store into 0xA2 dirty hit
	set_dp_values(0, 1, {30'hA2, 2'b00}, 32'h5a5aa5a5, 0);
	#(2*PERIOD);
	//store into 0xA3 dirty hit
	set_dp_values(0, 1, {30'hA3, 2'b00}, 32'ha5a55a5a, 0);
	#(2*PERIOD);
	//store into 0xC4 dirty hit
	set_dp_values(0, 1, {30'hC4, 2'b00}, 32'h5a5aa5a5, 0);
	#(2*PERIOD);
	//store into 0xC5 dirty hit
	set_dp_values(0, 1, {30'hC5, 2'b00}, 32'ha5a55a5a, 0);
	#(2*PERIOD);
	//store into 0x106 dirty hit
	set_dp_values(0, 1, {30'h106, 2'b00}, 32'h5a5aa5a5, 0);
	#(2*PERIOD);
	//store into 0x107 dirty hit
	set_dp_values(0, 1, {30'h107, 2'b00}, 32'ha5a55a5a, 0);
	#(2*PERIOD);
	//store into 0x148 dirty hit
	set_dp_values(0, 1, {30'h148, 2'b00}, 32'h5a5aa5a5, 0);
	#(2*PERIOD);
	//store into 0x149 dirty hit
	set_dp_values(0, 1, {30'h149, 2'b00}, 32'ha5a55a5a, 0);
	#(2*PERIOD);
	//store into 0x18A dirty hit
	set_dp_values(0, 1, {30'h18A, 2'b00}, 32'h5a5aa5a5, 0);
	#(2*PERIOD);
	//store into 0x18B dirty hit
	set_dp_values(0, 1, {30'h18B, 2'b00}, 32'ha5a55a5a, 0);
	#(2*PERIOD);
	//store into 0x1AC dirty hit
	set_dp_values(0, 1, {30'h1AC, 2'b00}, 32'h5a5aa5a5, 0);
	#(2*PERIOD);
	//store into 0x1AD dirty hit
	set_dp_values(0, 1, {30'h1AD, 2'b00}, 32'ha5a55a5a, 0);
	#(2*PERIOD);
	//store into 0x24E dirty hit
	set_dp_values(0, 1, {30'h24E, 2'b00}, 32'h5a5aa5a5, 0);
	#(2*PERIOD);
	//store into 0x24F dirty hit
	set_dp_values(0, 1, {30'h24F, 2'b00}, 32'ha5a55a5a, 0);

	//load to all in frame1
	//load from 0x3fffffff miss
	/*set_dp_values(1, 0, {30'h3fffffff, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	//load from 0x3fffffed miss
	set_dp_values(1, 0, {30'h3fffffed, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	//load from 0x3fffffdb miss
	set_dp_values(1, 0, {30'h3fffffdb, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	//load from 0x3fffffc9 miss
	set_dp_values(1, 0, {30'h3fffffc9, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	//load from 0x3fffffb7 miss
	set_dp_values(1, 0, {30'h3fffffb7, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	//load from 0x3fffffa5 miss
	set_dp_values(1, 0, {30'h3fffffa5, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	//load from 0x3fffff93 miss
	set_dp_values(1, 0, {30'h3fffff93, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	//load from 0x3fffff81 miss
	set_dp_values(1, 0, {30'h3fffff81, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);
	//load from 0x3fffff00 miss
	set_dp_values(1, 0, {30'h3fffff00, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hDEAFBEEF);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	set_mc_values(0, 32'hFEEDBEEF);

	//store cases
	//store into 0x80 dirty hit
	set_dp_values(0, 1, {30'h80, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x81 dirty hit
	set_dp_values(0, 1, {30'h81, 2'b00}, 32'ha5a55a5a, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0xA2 dirty hit
	set_dp_values(0, 1, {30'hA2, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0xA3 dirty hit
	set_dp_values(0, 1, {30'hA3, 2'b00}, 32'ha5a55a5a, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0xC4 dirty hit
	set_dp_values(0, 1, {30'hC4, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0xC5 dirty hit
	set_dp_values(0, 1, {30'hC5, 2'b00}, 32'ha5a55a5a, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x106 dirty hit
	set_dp_values(0, 1, {30'h106, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x107 dirty hit
	set_dp_values(0, 1, {30'h107, 2'b00}, 32'ha5a55a5a, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x148 dirty hit
	set_dp_values(0, 1, {30'h148, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x149 dirty hit
	set_dp_values(0, 1, {30'h149, 2'b00}, 32'ha5a55a5a, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x18A dirty hit
	set_dp_values(0, 1, {30'h18A, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x18B dirty hit
	set_dp_values(0, 1, {30'h18B, 2'b00}, 32'ha5a55a5a, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x1AC dirty hit
	set_dp_values(0, 1, {30'h1AC, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x1AD dirty hit
	set_dp_values(0, 1, {30'h1AD, 2'b00}, 32'ha5a55a5a, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x24E dirty hit
	set_dp_values(0, 1, {30'h24E, 2'b00}, 32'h5a5aa5a5, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//store into 0x24F dirty hit
	set_dp_values(0, 1, {30'h24F, 2'b00}, 32'ha5a55a5a, 0);
	set_mc_values(1, 32'h0);
	#(2*PERIOD);
	//load from 0x80 hit
	set_dp_values(1, 0, {30'h80, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0x81 hit
	set_dp_values(1, 0, {30'h81, 2'b00}, 32'h0, 0);
	#(2*PERIOD);
	//load from 0x581 miss
	set_dp_values(1, 0, {30'h581, 2'b00}, 32'h0, 0);
	set_mc_values(0, 32'hbad1bad1);
	#(2*PERIOD);
	set_mc_values(1, 32'hbad1bad1);
	#(2*PERIOD);
	set_mc_values(1, 32'h0);
	//save to 0x580 dirty hit
	set_dp_values(0, 1, {30'h580, 2'b00}, 32'hFEEDBEAF, 0);
	#(PERIOD);
	//halt
	set_mc_values(1, 32'h0);
	set_dp_values(0, 0, 32'h0, 32'h0, 1);
	*/
	#(PERIOD*10);
end

endprogram
