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
  test PROG (CLK, nRST, cc0, syif);

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

program test(input logic CLK, output logic nRST, caches_if.caches ccif, system_if.tb syif);

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
    ccif.dWEN = 1'b0;
    ccif.dREN = 1'b0;
    ccif.iREN = 1'b0;
    ccif.dstore = '0;
    ccif.iaddr = '0;
    ccif.daddr = '0;
  end
  endtask

  task write_data;
    input word_t addr;
    input word_t data;
  begin
    ccif.dWEN = 1'b1;
    ccif.daddr = addr;
    ccif.dstore = data;

    @(negedge ccif.dwait);
    @(posedge CLK);

    ccif.dWEN = 1'b0;

    @(negedge CLK);
  end
  endtask

  task read_data;
    input word_t addr;
    input word_t expected_load;
  begin
    ccif.dREN = 1'b1;
    ccif.daddr = addr;
    @(negedge ccif.dwait);
    @(posedge CLK);
    check_ramload(expected_load);
    ccif.dREN = 1'b0;
    @(negedge CLK);
  end
  endtask

  task read_instr;
    input word_t addr;
    input word_t expected_load;
  begin
    ccif.iREN = 1'b1;
    ccif.iaddr = addr;
    @(negedge ccif.iwait);
    @(posedge CLK);
    @(posedge CLK);
    check_ramload(expected_load);
    ccif.iREN = 1'b0;
    @(negedge CLK);
  end
  endtask

  task check_ramload;
    input word_t expected_load;
  begin
    if (ccif.dload != expected_load)
      $display("%s: Incorrect dload: %x: %x", testcase, ccif.ramaddr, ccif.ramload);
    if (ccif.iload != expected_load)
      $display("%s: Incorrect iload: %x: %x", testcase, ccif.ramaddr, ccif.ramload);
  end
  endtask

  initial
  begin
    syif.tbCTRL = 1'b0;
    reset();
    nRST = 0;

    @(posedge CLK);
    @(posedge CLK);
    nRST = 1;
    @(posedge CLK);
    @(posedge CLK);

    testcase = "Write then Read Data";
    reset();
    read_data(0, 32'h341DFFFC);
    write_data(4, 4);
    write_data(8, 8);
    write_data(12, 12);
    read_data(4, 4);
    read_data(8, 8);
    read_data(12, 12);
    read_instr(4, 4);
    read_instr(8, 8);
    read_instr(12, 12);

    testcase = "Data Read over Instruction Read Priortity";
    fork
      read_data(4, 4);
      read_instr(8, 8);
    join

    testcase = "Data Write over Instruction Read Priority";
    fork
      write_data(4, 437);
      read_instr(4, 437);
    join

    testcase = "Keep iREN high";
    ccif.iREN = 1'b1;
    ccif.iaddr = '0;
    for (int i = 0; i < 16; i += 4)
    begin
      ccif.iaddr = i;
      
    end

    testcase = "Dump Memory";
    dump_memory();

    $finish;
  end
endprogram
