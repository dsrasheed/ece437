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
  cache_control_if #(.CPUS(2)) ccif (cc0, cc1);
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

task set_dp_values0;
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

task check_values0;
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

task set_dp_values1;
	input logic dmemren_tb, dmemwen_tb;
	input word_t dmemaddr_tb, dmemstore_tb;
	input logic halt_tb;
	begin
		dcif1.dmemaddr = dmemaddr_tb;
		dcif1.dmemstore = dmemstore_tb;
		dcif1.dmemREN = dmemren_tb;
		dcif1.dmemWEN = dmemwen_tb;
		dcif1.halt = halt_tb;
	end
endtask

task check_values1;
	input logic expected_dhit;
	input word_t expected_dmemload;
	begin
		if(expected_dmemload == dcif1.dmemload)
		begin
			$display("Test Case #%0d Instr #%0d, Memload Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, Memload ERROR", test_case_num, instr_num);
		end
		
		if(expected_dhit == dcif1.dhit)
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
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	//set_dp_values1(0, 0, 32'h0, 32'h0, 0);

	nRST = 0;
	#(3*PERIOD);
	nRST = 1;
	#(3*PERIOD);

	//init with some stores
	#(3*PERIOD);
	//store 12345678 to 0x400
	set_dp_values0(0, 1, {26'h10, 3'd0, 1'b0, 2'b00}, 32'h12345678, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 87654321 to 0x408
	set_dp_values0(0, 1, {26'h10, 3'd1, 1'b0, 2'b00}, 32'h87654321, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 12345678 to 0x410
	set_dp_values0(0, 1, {26'h10, 3'd2, 1'b0, 2'b00}, 32'h12345678, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 87654321 to 0x418
	set_dp_values0(0, 1, {26'h10, 3'd3, 1'b0, 2'b00}, 32'h87654321, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 12345678 to 0x420
	set_dp_values0(0, 1, {26'h10, 3'd4, 1'b0, 2'b00}, 32'h12345678, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 87654321 to 0x428
	set_dp_values0(0, 1, {26'h10, 3'd5, 1'b0, 2'b00}, 32'h87654321, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 12345678 to 0x430
	set_dp_values0(0, 1, {26'h10, 3'd6, 1'b0, 2'b00}, 32'h12345678, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 87654321 to 0x438
	set_dp_values0(0, 1, {26'h10, 3'd7, 1'b0, 2'b00}, 32'h87654321, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store FEEDBEEF to 0x800
	set_dp_values0(0, 1, {26'h20, 3'd0, 1'b0, 2'b00}, 32'hFEEDBEEF, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store BEEFDEAD to 0x808
	set_dp_values0(0, 1, {26'h20, 3'd1, 1'b0, 2'b00}, 32'hBEEFDEAD, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 20224404 to 0xC00
	set_dp_values0(0, 1, {26'h30, 3'd0, 1'b0, 2'b00}, 32'h20224404, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 5055aa0a to 0xC08
	set_dp_values0(0, 1, {26'h30, 3'd1, 1'b0, 2'b00}, 32'h5055aa0a, 0);
	@(posedge dcif0.dhit);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	
	//store 12345678 to 0x400
	set_dp_values1(0, 1, {26'h10, 3'd0, 1'b0, 2'b00}, 32'habcdefff, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 87654321 to 0x408
	set_dp_values1(0, 1, {26'h10, 3'd1, 1'b0, 2'b00}, 32'hfedcbaa, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 12345678 to 0x410
	set_dp_values1(0, 1, {26'h10, 3'd2, 1'b1, 2'b00}, 32'habcdefff, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 87654321 to 0x418
	set_dp_values1(0, 1, {26'h10, 3'd3, 1'b1, 2'b00}, 32'hfedcbaa, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 12345678 to 0x420
	set_dp_values1(0, 1, {26'h10, 3'd4, 1'b1, 2'b00}, 32'habcdefff, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 87654321 to 0x428
	set_dp_values1(0, 1, {26'h10, 3'd5, 1'b1, 2'b00}, 32'hfedcbaa, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 12345678 to 0x430
	set_dp_values1(0, 1, {26'h10, 3'd6, 1'b1, 2'b00}, 32'habcdefff, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 87654321 to 0x438
	set_dp_values1(0, 1, {26'h10, 3'd7, 1'b1, 2'b00}, 32'hfedcbaa, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store FEEDBEEF to 0x800
	set_dp_values1(0, 1, {26'h20, 3'd0, 1'b1, 2'b00}, 32'hDEADBEAD, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store BEEFDEAD to 0x808
	set_dp_values1(0, 1, {26'h20, 3'd1, 1'b1, 2'b00}, 32'hDEADABE1, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 20224404 to 0xC00
	set_dp_values1(0, 1, {26'h30, 3'd0, 1'b1, 2'b00}, 32'h30337707, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//store 5055aa0a to 0xC08
	set_dp_values1(0, 1, {26'h30, 3'd1, 1'b1, 2'b00}, 32'h60669909, 0);
	@(posedge dcif1.dhit);
	#(PERIOD);
	set_dp_values1(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);

	//load to all in frame0
	//load from  miss
	#(3*PERIOD); 
	instr_num += 1;
	set_dp_values0(1, 0, {26'h10, 3'd0, 1'b0, 2'b00}, 32'h0, 0);
	@(posedge dcif0.dhit);
	check_values0(1, 32'h12345678);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//load from 0xA2 miss
	instr_num += 1;
	set_dp_values1(1, 0, {26'h20, 3'd1, 1'b0, 2'b00}, 32'h0, 0);
	@(posedge dcif0.dhit);
	check_values0(1, 32'hBEEFDEAD);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//load from 0xC4 miss
	instr_num += 1;
	set_dp_values0(1, 0, {26'h10, 3'd4, 1'b0, 2'b00}, 32'h0, 0);
	@(posedge dcif0.dhit);
	check_values0(1, 32'h12345678);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//load from 0x106 miss
	instr_num += 1;
	set_dp_values1(1, 0, {26'h30, 3'd0, 1'b0, 2'b00}, 32'h0, 0);
	@(posedge dcif0.dhit);
	check_values0(1, 32'h20224404);
	#(PERIOD);
	set_dp_values0(0, 0, 32'h0, 32'h0, 0);
	#(PERIOD);
	//load from 0x148 miss
	
	#(PERIOD*10);
end

endprogram
