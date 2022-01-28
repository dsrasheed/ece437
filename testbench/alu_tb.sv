/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "cpu_types_pkg.vh"
`include "alu_if.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;

  // interface
  alu_if aluif ();
  // test program
  test PROG (aluif);
  // DUT
`ifndef MAPPED
  alu DUT(aluif);
`else
  alu DUT(
    .\aluif.aluop (aluif.aluop),
    .\aluif.ra (aluif.ra),
    .\aluif.rb (aluif.rb),
    .\aluif.out (aluif.out),
    .\aluif.negative (aluif.negative),
    .\aluif.overflow (aluif.overflow),
    .\aluif.zero (aluif.zero)
  );
`endif

endmodule

program test(alu_if.tb aluif);
  parameter CHECK_DELAY = 5ns;

  logic rdat1_success;
  logic rdat2_success;
  word_t expected_registers[2**REG_W];

  task test_alu;
    input aluop_t op;
    input word_t ra;
    input word_t rb;
    input word_t exp_out;
    input logic negative;
    input logic zero;
    input logic overflow;
  begin
    aluif.ra = ra;
    aluif.rb = rb;
    aluif.aluop = op;
    
    #(CHECK_DELAY);

    if (aluif.out != exp_out)
      $display("Incorrect output for ra = %0d, rb = %0d, op = %0s", ra, rb, op.name());
    else if (aluif.negative != negative)
      $display("Incorrect negative for ra = %0d, rb = %0d, op = %0s", ra, rb, op.name());
    else if (aluif.zero != zero)
      $display("Incorrect zero for ra = %0d, rb = %0d, op = %0s", ra, rb, op.name());
    else if (aluif.overflow != overflow)
      $display("Incorrect overflow for ra = %0d, rb = %0d, op = %0s", ra, rb, op.name());
  end
  endtask

  initial
  begin
    // SLL
    test_alu(ALU_SLL, 1, 1, 2, 0, 0, 0);
    test_alu(ALU_SLL, 31, 1, 1<<31, 1, 0, 0);
    test_alu(ALU_SLL, 32, 1, 1, 0, 0, 0);
    test_alu(ALU_SLL, 5, 5, 160, 0, 0, 0);
    test_alu(ALU_SLL, 10, 200, 204800, 0, 0, 0);

    // SRL
    test_alu(ALU_SRL, 5, 32'h000f0000, 32'h00007800, 0, 0, 0);
    test_alu(ALU_SRL, 31, 1<<31, 1, 0, 0, 0);
    test_alu(ALU_SRL, 32, 1<<31, 1<<31, 1, 0, 0);
    test_alu(ALU_SRL, 63, 1<<31, 1, 0, 0, 0);
    test_alu(ALU_SRL, 1, 1, 0, 0, 1, 0);

    // ADD
    test_alu(ALU_ADD, 5, 5, 10, 0, 0, 0);
    test_alu(ALU_ADD, -5, -4, -9, 1, 0, 0);
    test_alu(ALU_ADD, -5, 8, 3, 0, 0, 0);
    test_alu(ALU_ADD, 1758384, 385478, 2143862, 0, 0, 0);
    test_alu(ALU_ADD, 1758384, -385478, 1372906, 0, 0, 0);
    test_alu(ALU_ADD, -32'd1, -32'd1, -32'd2, 1, 0, 0);
    test_alu(ALU_ADD, -32'd1, 32'h80000001, 32'h80000000, 1, 0, 0);
    // overflow
    test_alu(ALU_ADD, 32'h7fffffff, 32'h00000001, 32'h80000000, 1, 0, 1);
    test_alu(ALU_ADD, 32'hffffffff, 32'h80000000, 32'h7fffffff, 0, 0, 1);

    // SUB
    test_alu(ALU_SUB, 5, 5, 0, 0, 1, 0);
    test_alu(ALU_SUB, -1, 1, -2, 1, 0, 0);
    test_alu(ALU_SUB, -1, 2**31-1, 2**31, 1, 0, 0);
    // overflow
    test_alu(ALU_SUB, 32'h7fffffff, -32'd1, 32'h80000000, 1, 0, 1);
    test_alu(ALU_SUB, 32'h80000000, 32'd1, 32'h7fffffff, 0, 0, 1);

    // AND
    test_alu(ALU_AND, 32'h3b56ab2c, 32'habc498fd, 32'h2b44882c, 0, 0, 0);

    // OR
    test_alu(ALU_OR, 32'h3b56ab2c, 32'habc498fd, 32'hbbd6bbfd, 1, 0, 0);
    
    // XOR
    test_alu(ALU_XOR, 32'h3b56ab2c, 32'habc498fd, 32'h909233d1, 1, 0, 0);

    // NOR
    test_alu(ALU_NOR, 32'h3b56ab2c, 32'habc498fd, ~32'hbbd6bbfd, 0, 0, 0);

    // SLT
    test_alu(ALU_SLT, -1, -2, 0, 0, 1, 0);
    test_alu(ALU_SLT, -2, -1, 1, 0, 0, 0);
    test_alu(ALU_SLT, 100, 200, 1, 0, 0, 0);
    test_alu(ALU_SLT, 200, 100, 0, 0, 1, 0);
    test_alu(ALU_SLT, 100, -1, 0, 0, 1, 0);
    test_alu(ALU_SLT, -1, 100, 1, 0, 0, 0);

    // SLTU
    test_alu(ALU_SLTU, -1, -2, 0, 0, 1, 0);
    test_alu(ALU_SLTU, -2, -1, 1, 0, 0, 0);
    test_alu(ALU_SLTU, 100, 200, 1, 0, 0, 0);
    test_alu(ALU_SLTU, 200, 100, 0, 0, 1, 0);
    test_alu(ALU_SLTU, -1, 1, 0, 0, 1, 0);
    test_alu(ALU_SLTU, 1, -1, 1, 0, 0, 0);
  end
endprogram
