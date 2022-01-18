/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "cpu_types_pkg.vh"
`include "register_file_if.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (CLK, nRST, rfif);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(input CLK, output logic nRST, register_file_if.tb rfif);
  parameter CHECK_DELAY = 5ns;

  logic rdat1_success;
  logic rdat2_success;
  word_t expected_registers[2**REG_W];

  task reset;
  begin
    rdat1_success = 1'b1;
    rdat2_success = 1'b1;

    rfif.rsel1 = '0;
    rfif.rsel2 = '0;
    rfif.wsel = '0;
    rfif.wdat = '0;
    rfif.WEN = 0;
    reset_expected_registers();

    @(negedge CLK);
    nRST = 1'b0;
    #(register_file_tb.PERIOD * 2);
    nRST = 1'b1;
    #(register_file_tb.PERIOD * 2);
  end
  endtask

  task reset_expected_registers;
  begin
    for (int i = 0; i < $size(expected_registers); i++)
    begin
      expected_registers[i] = '0;
    end
  end
  endtask

  task check_output;
  begin
    fork
      for (int i = 0; i < $size(expected_registers); i++)
      begin
        @(negedge CLK);
        rfif.rsel1 = i;
        @(posedge CLK);
        @(negedge CLK);
        if (rfif.rdat1 != expected_registers[i])
          rdat1_success = 1'b0;
      end

      for (int i = 0; i < $size(expected_registers); i++)
      begin
        @(negedge CLK);
        rfif.rsel2 = i;
        @(posedge CLK);
        @(negedge CLK);
        if (rfif.rdat2 != expected_registers[i])
          rdat2_success = 1'b0;
      end
    join
  end
  endtask

  task write_reg;
    input int i;
    input word_t data;
  begin
    if (i != 0)
      expected_registers[i] = data;
    
    @(negedge CLK);
    rfif.WEN = 1'b1;
    rfif.wsel = i;
    rfif.wdat = data;
    @(posedge CLK);
    @(negedge CLK);
    rfif.wsel = 1'b0;
    rfif.wsel = '0;
    rfif.wdat = '0;
  end
  endtask

  initial
  begin
    reset();
    check_output();

    // basic write and read
    reset();
    write_reg(1, 20);
    check_output();

    // write to 0 and read
    reset();
    write_reg(0, 20);
    check_output();

    // basic write to all and read
    reset();
    for (int i = 0; i < $size(expected_registers); i++)
    begin
      write_reg(i, i);
    end
    check_output();

    // complex
    reset();
    for (int i = 0; i < $size(expected_registers); i++)
    begin
      write_reg(i, 1234567*i);
    end
    check_output();
  end
endprogram
