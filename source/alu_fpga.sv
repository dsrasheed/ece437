/*
  Eric Villasenor
  evillase@gmail.com

  register file fpga wrapper
*/

// interface
`include "alu_if.vh"

module alu_fpga (
  input logic CLOCK_50,
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [17:0] LEDR
);

  // interface
  alu_if aluif();
  // rf
  alu a(aluif);

  logic [7:0] ra;
  logic [7:0] rb;

  always_latch
  begin
    if (KEY[3] == 1'b0)
      ra = SW[17:10];
    else if (KEY[2] == 1'b0)
      rb = SW[17:10];
  end

  assign aluif.aluop = aluop_t'(SW[3:0]);
  assign aluif.ra = {'0, ra};
  assign aluif.rb = {'0, rb};

  assign LEDR[7:0] = aluif.out[7:0];
  assign LEDR[17:15] = {aluif.negative, aluif.zero, aluif.overflow};

endmodule
