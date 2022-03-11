`include "caches_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module icache_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;

  always #(PERIOD/2) CLK++;

  // interface delcaration
  caches_if cif ();
  datapath_cache_if dcif ();
  // test program setup
  test PROG (CLK, nRST, cif, dcif);

`ifndef MAPPED
  icache DUT(CLK, nRST, cif, dcif);

`else
  icache DUT(
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
	input logic imemren_tb;
	input word_t imemaddr_tb;
	input logic halt_tb;
	begin
		tbdc.imemaddr = imemaddr_tb;
		tbdc.imemREN = imemren_tb;
		tbdc.halt = halt_tb;
	end
endtask

task set_mc_values;
	input logic iwait_tb;
	input word_t iload_tb;
	begin
		tbc.iload = iload_tb;
		tbc.iwait = iwait_tb;
	end
endtask

task check_values1;
	input logic expected_iren;
	input word_t expected_iaddr;
	begin
		if(expected_iaddr == tbc.iaddr)
		begin
			$display("Test Case #%0d Instr #%0d, Addr Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, Addr ERROR", test_case_num, instr_num);
		end

		if(expected_iren == tbc.iREN)
		begin
			$display("Test Case #%0d Instr #%0d, REN Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, REN ERROR", test_case_num, instr_num);
		end
	end
endtask

task check_values2;
	input logic expected_ihit;
	input word_t expected_imemload;
	begin
		if(expected_imemload == tbdc.imemload)
		begin
			$display("Test Case #%0d Instr #%0d, Memload Success", test_case_num, instr_num);
		end
		else
		begin
			$display("Test Case #%0d Instr #%0d, Memload ERROR", test_case_num, instr_num);
		end
		
		if(expected_ihit == tbdc.ihit)
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
	tbdc.dmemREN = 0;
	tbdc.dmemWEN = 0;
	tbdc.datomic = 0;
	tbdc.dmemstore = '0;
	tbdc.dmemaddr = '0;
	tbdc.imemaddr = '0;
	tbc.dwait = 0;
	tbc.dload = '0;
	tbc.ccwait = 0;
	tbc.ccinv = 0;
	tbc.ccsnoopaddr = 0;
	set_dp_values(0, 32'h0, 0);
	set_mc_values(1, 32'h0);

	nRST = 0;
	#(PERIOD);
	nRST = 1;
	//write ton idx1
	test_case_num += 1;
	set_dp_values(1, 32'hffffffc4, 0);
	#(PERIOD);
	set_mc_values(0, 32'h12345678);
	#(PERIOD);
	set_mc_values(1, 32'h0);
	//write to idx2
	set_dp_values(1, 32'hffffffc8, 0);
	#(PERIOD);
	set_mc_values(0, 32'h87654321);
	#(PERIOD);
	set_mc_values(1, 32'h0);
	//write to idx3
	set_dp_values(1, 32'hffffffcc, 0);
	set_mc_values(0, 32'ha5a55a5a);
	#(PERIOD);

	//fetch reg1 - match
	test_case_num += 1;
	set_dp_values(1, 32'hffffffc4, 0);
	set_mc_values(1, 32'h0);
	#(PERIOD);
	check_values2(1, 32'h12345678);

	//fetch reg2 - mismatch
	test_case_num += 1;
	set_dp_values(1, 32'hffffffc8, 0);
	set_mc_values(0, 32'hDEADFEED);
	#(PERIOD);
	check_values1(1, 32'hffffffc8);
	check_values2(1, 32'h87654321);

	//don't read
	test_case_num += 1;
	set_dp_values(0, 32'hffffffc4, 0);
	set_mc_values(1, 32'h0);
	#(PERIOD);
	check_values1(0, 32'h0);
	check_values2(0, 32'h0);

	#(PERIOD);
end  
endprogram
