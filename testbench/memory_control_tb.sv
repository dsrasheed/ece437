/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "cpu_types_pkg.vh"
`include "cache_control_if.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  // clock period
  parameter PERIOD = 20;

  // signals
  logic CLK = 1, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cc0 ();
  caches_if cc1 ();
  cache_control_if #(.CPUS(2)) ccif (cc0, cc1);
  cpu_ram_if prif ();
  system_if syif ();
 
  // test program
  test PROG (CLK, nRST, cc0, cc1, ccif, syif);

  // DUT
`ifndef MAPPED
  memory_control DUT(CLK, nRST, ccif);
`else
  memory_control DUT(
    .\ccif.iREN (ccif.iREN),
    .\ccif.dREN (ccif.dREN),
    .\ccif.dWEN (ccif.dWEN),
    .\ccif.daddr (ccif.daddr),
    .\ccif.iaddr (ccif.iaddr),
    .\ccif.dstore (ccif.dstore),
    .\ccif.ramstate (ccif.ramstate),
    .\ccif.ramload (ccif.ramload),
    .\ccif.ccwrite (ccif.ccwrite),
    .\ccif.cctrans (ccif.cctrans),
    .\ccif.iwait (ccif.iwait),
    .\ccif.dwait (ccif.dwait),
    .\ccif.iload (ccif.iload),
    .\ccif.dload (ccif.dload),
    .\ccif.ramREN (ccif.ramREN),
    .\ccif.ramWEN (ccif.ramWEN),
    .\ccif.ramaddr (ccif.ramaddr),
    .\ccif.ramstore (ccif.ramstore),
    .\ccif.ccwait (ccif.ccwait),
    .\ccif.ccinv (ccif.ccinv),
    .\ccif.ccsnoopaddr (ccif.ccsnoopaddr),
    .CLK(CLK), .nRST(nRST)
  );
`endif

  ram RAM (CLK, nRST, prif);

  assign ccif.ramload = prif.ramload;
  assign ccif.ramstate = prif.ramstate;

  assign syif.load = prif.ramload;

  assign prif.ramREN = syif.tbCTRL ? syif.REN : ccif.ramREN;
  assign prif.ramWEN = syif.tbCTRL ? syif.WEN : ccif.ramWEN;
  assign prif.ramaddr = syif.tbCTRL ? syif.addr : ccif.ramaddr;
  assign prif.ramstore = syif.tbCTRL ? syif.store : ccif.ramstore;

endmodule

program test(input logic CLK, output logic nRST, caches_if.tb cc0, caches_if.tb cc1, cache_control_if.tb ccif, system_if.tb syif);

  string testcase;

  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    syif.tbCTRL = 1;
    syif.addr = 0;
    syif.WEN = 0;
    syif.REN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      syif.addr = i << 2;
      syif.REN = 1;
      repeat (4) @(posedge CLK);
      if (syif.load === 0)
        continue;
      values = {8'h04,16'(i),8'h00,syif.load};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),syif.load,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end // for
    if (memfd)
    begin
      syif.tbCTRL = 0;
      syif.REN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

  task reset;
  begin
    cc0.dWEN = 0;
    cc0.dREN = 0;
    cc0.iREN = 0;
		cc0.dstore = '0;
    cc0.iaddr = '0;
    cc0.daddr = '0;
		cc0.cctrans = '0;
		cc0.ccwrite = '0;
		cc1.dWEN = 0;
    cc1.dREN = 0;
		cc1.iREN = 0;
    cc1.dstore = '0;
    cc1.iaddr = '0;
    cc1.daddr = '0;
		cc1.cctrans = '0;
		cc1.ccwrite = '0;
  end
  endtask

  task write_data0;
    input word_t addr;
    input word_t data1;
		input word_t data2;
  begin
    cc0.dWEN = 1'b1;
    cc0.daddr = addr;
    cc0.dstore = data1;

    @(negedge cc0.dwait);
    @(posedge CLK);
		cc0.daddr = addr+4;
    cc0.dstore = data2;
		@(negedge cc0.dwait);
    @(posedge CLK);

    cc0.dWEN = 1'b0;

    @(negedge CLK);
  end
  endtask

  task read_data0;
    input word_t addr;
    input word_t expected_load1;
		input word_t expected_load2;
  begin
    cc0.dREN = 1'b1;
    cc0.daddr = addr;
    @(negedge cc0.dwait);
		@(negedge CLK);
		check_ramload0(1, expected_load1);
    @(posedge CLK);
		cc0.daddr = addr+4;
		@(negedge cc0.dwait);
    @(negedge CLK);
		check_ramload0(1, expected_load2);
    @(negedge CLK);
		cc0.dREN = 1'b0;
  end
  endtask

  task read_instr0;
    input word_t addr;
    input word_t expected_load1;
		input word_t expected_load2;
  begin
    cc0.iREN = 1'b1;
    cc0.iaddr = addr;
    @(negedge cc0.iwait);
    @(negedge CLK);
    check_ramload0(0, expected_load1);
		@(posedge CLK);
		cc0.iaddr = addr+4;
		@(negedge cc0.iwait);
    @(negedge CLK);
    check_ramload0(0, expected_load2);
    @(negedge CLK);
		cc0.iREN = 1'b0;
  end
  endtask

  task check_ramload0;
		input logic sel;
    input word_t expected_load;
  begin
		if(sel) begin
    if (cc0.dload != expected_load)
      $display("%s: Incorrect dload0: %x: %x %x", testcase, ccif.ramaddr, ccif.ramload, cc0.dload);
		end
		else begin
    if (cc0.iload != expected_load)
      $display("%s: Incorrect iload0: %x: %x %x", testcase, ccif.ramaddr, ccif.ramload,  cc0.iload);
		end
  end
  endtask

	task write_data1;
    input word_t addr;
    input word_t data1;
		input word_t data2;
  begin
    cc1.dWEN = 1'b1;
    cc1.daddr = addr;
    cc1.dstore = data1;

    @(negedge cc1.dwait);
    @(posedge CLK);
		cc1.daddr = addr+ 4;
    cc1.dstore = data2;

    @(negedge cc1.dwait);
    @(posedge CLK);

    cc1.dWEN = 1'b0;

    @(negedge CLK);
  end
  endtask

  task read_data1;
    input word_t addr;
    input word_t expected_load1;
		input word_t expected_load2;
  begin
    cc1.dREN = 1'b1;
    cc1.daddr = addr;
    @(negedge cc1.dwait);
    @(negedge CLK);
    check_ramload1(1, expected_load1);
		@(posedge CLK);
		cc1.daddr = addr+4;
		@(negedge cc1.dwait);
    @(negedge CLK);
    check_ramload1(1, expected_load2);
    @(negedge CLK);
		cc1.dREN = 1'b0;
  end
  endtask

  task read_instr1;
    input word_t addr;
    input word_t expected_load1;
		input word_t expected_load2;
  begin
    cc1.iREN = 1'b1;
    cc1.iaddr = addr;
    @(negedge cc1.iwait);
    @(negedge CLK);
    check_ramload1(0, expected_load1);
		@(negedge CLK);
		cc1.iaddr = addr+4;
		@(negedge cc1.iwait);
    @(negedge CLK);
    check_ramload1(0, expected_load2);
    @(negedge CLK);
		cc1.iREN = 1'b0;
  end
  endtask

  task check_ramload1;
		input logic sel;
    input word_t expected_load;
  begin
		if(sel) begin
    if (cc1.dload != expected_load)
      $display("%s: Incorrect dload1: %x: %x %x", testcase, ccif.ramaddr, ccif.ramload, cc1.dload);
		end
		else begin
    if (cc1.iload != expected_load)
      $display("%s: Incorrect iload1: %x: %x %x", testcase, ccif.ramaddr, ccif.ramload, cc1.iload);
		end
  end
  endtask

  initial
  begin
    syif.tbCTRL = 1'b0;
    reset();
    nRST = 0;
		reset();
    @(posedge CLK);
    @(posedge CLK);
    nRST = 1;
    @(posedge CLK);
		reset();
    @(posedge CLK);

    testcase = "Write then Read Data";
    reset();
		cc0.cctrans = 1;
		cc1.cctrans = 0;
    read_data0(0, 32'h37BDFFFC, 32'h23BDFFF8);
		cc0.cctrans = 0;
    write_data1(4, 4, 8);
    write_data0(8, 8, 12);
    write_data1(12, 12, 16);
		cc1.cctrans = 1;
		@(posedge CLK)
    read_data1(4, 4, 8);
    read_data0(8, 16, 16);
		cc0.cctrans = 1;
		@(posedge CLK)
    read_data1(12, 12, 12);
		cc1.cctrans = 0;
		cc0.cctrans = 0;
		@(posedge CLK)
    read_instr0(4, 4, 16);
    read_instr1(8, 16, 12);
    read_instr0(12, 12, 12);
		reset();
		$finish;

    //testcase = "Dump Memory";
    //dump_memory();

  end
endprogram
