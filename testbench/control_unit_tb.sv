// mapped needs this
`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

  control_unit_if cuif ();

  control_unit_if exp_cuif ();

  // test program
  test PROG (cuif.tb, exp_cuif.cu);

  // DUT
`ifndef MAPPED
  control_unit DUT(cuif.cu);
`else
  control_unit DUT(
    .\cuif.opcode (cuif,opcode),
    .\cuif.funct (cuif.funct),
    .\cuif.PCSrc (cuif.PCSrc),
    .\cuif.equal (cuif.equal),
    .\cuif.WrLinkReg (cuif.WrLinkReg),
    .\cuif.ShiftUp (cuif.ShiftUp),
    .\cuif.MemRd (cuif.MemRd),
    .\cuif.ExtOp (cuif.ExtOp),
    .\cuif.ALUSrc (cuif.ALUSrc),
    .\cuif.MemToReg (cuif.MemToReg),
    .\cuif.MemWr (cuif.MemWr),
    .\cuif.RegWr (cuif.RegWr),
    .\cuif.RegDst (cuif.RegDst),
    .\cuif.halt (cuif.halt)
  );
`endif

endmodule

program test(control_unit_if.tb cuif, control_unit_if.cu exp_cuif);

  parameter CHECK_DELAY = 5ns;

  task reset_expected;
  begin
    exp_cuif.RegDst = 1'b0;
    exp_cuif.RegWr = 1'b0;
    exp_cuif.MemWr = 1'b0;
    exp_cuif.MemRd = 1'b0;
    exp_cuif.MemToReg = 1'b0;
    exp_cuif.ALUSrc = 1'b0;
    exp_cuif.ExtOp = 1'b0;
    exp_cuif.ShiftUp = 1'b0;
    exp_cuif.WrLinkReg = 1'b0;
    exp_cuif.halt = 1'b0;
    exp_cuif.PCSrc = NEXT;
    exp_cuif.ALUOp = ALU_SUB;
    exp_cuif.stall = 1'b0;
  end
  endtask

  task check_outputs;
    input opcode_t opcode;
    input funct_t funct;
  begin
    if (cuif.WrLinkReg != exp_cuif.WrLinkReg)
      $display("%s %s: Incorrect WrLinkReg %d, should be %d", opcode.name(), funct.name(), cuif.WrLinkReg, exp_cuif.WrLinkReg);
    if (cuif.ShiftUp != exp_cuif.ShiftUp)
      $display("%s %s: Incorrect ShiftUp %d, should be %d", opcode.name(), funct.name(), cuif.ShiftUp, exp_cuif.ShiftUp);
    if (cuif.MemRd != exp_cuif.MemRd)
      $display("%s %s: Incorrect MemRd %d, should be %d", opcode.name(), funct.name(), cuif.MemRd, exp_cuif.MemRd);
    if (cuif.ExtOp != exp_cuif.ExtOp)
      $display("%s %s: Incorrect ExtOp %d, should be %d", opcode.name(), funct.name(), cuif.ExtOp, exp_cuif.ExtOp);
    if (cuif.PCSrc != exp_cuif.PCSrc)
      $display("%s %s: Incorrect PCSrc %s, should be %s", opcode.name(), funct.name(), cuif.PCSrc.name(), exp_cuif.PCSrc.name());
    if (cuif.ALUSrc != exp_cuif.ALUSrc)
      $display("%s %s: Incorrect ALUSrc %d, should be %d", opcode.name(), funct.name(), cuif.ALUSrc, exp_cuif.ALUSrc);
    if (cuif.MemToReg != exp_cuif.MemToReg)
      $display("%s %s: Incorrect MemToReg %d, should be %d", opcode.name(), funct.name(), cuif.MemToReg, exp_cuif.MemToReg);
    if (cuif.MemWr != exp_cuif.MemWr)
      $display("%s %s: Incorrect MemWr %d, should be %d", opcode.name(), funct.name(), cuif.MemWr, exp_cuif.MemWr);
    if (cuif.RegWr != exp_cuif.RegWr)
      $display("%s %s: Incorrect RegWr %d, should be %d", opcode.name(), funct.name(), cuif.RegWr, exp_cuif.RegWr);
    if (cuif.RegDst != exp_cuif.RegDst)
      $display("%s %s: Incorrect RegDst %d, should be %d", opcode.name(), funct.name(), cuif.RegDst, exp_cuif.RegDst);
    if (cuif.halt != exp_cuif.halt)
      $display("%s %s: Incorrect halt %d, should be %d", opcode.name(), funct.name(), cuif.halt, exp_cuif.halt);
    if (cuif.ALUOp != exp_cuif.ALUOp)
      $display("%s %s: Incorrect ALUOp %s, should be %s", opcode.name(), funct.name(), cuif.ALUOp.name(), exp_cuif.ALUOp.name());
  end
  endtask

  task tst;
    input opcode_t opcode;
    input funct_t funct;
    input logic equal;
    input logic reset;
  begin
    pcsrc_t saved_PCSrc;
    logic saved_RegWr;

    cuif.opcode = opcode;
    cuif.funct = funct;
    cuif.equal = equal;

    cuif.stall = 1'b0;
    #(CHECK_DELAY);
    check_outputs(opcode, funct);
    
    saved_PCSrc = exp_cuif.PCSrc;
    saved_RegWr = exp_cuif.RegWr;
    exp_cuif.PCSrc = KEEP;
    exp_cuif.RegWr = 1'b0;

    cuif.stall = 1'b1;
    #(CHECK_DELAY);
    check_outputs(opcode, funct);
    cuif.stall = 1'b0;

    exp_cuif.PCSrc = saved_PCSrc;
    exp_cuif.RegWr = saved_RegWr;

    #(1);
    if (reset)
      reset_expected();
    #(1);
  end
  endtask

  task tst_rtype;
    input opcode_t opcode;
    input funct_t funct;
  begin
    tst(opcode, funct, 1'b1, 1'b0);
    tst(opcode, funct, 1'b0, 1'b0);
  end
  endtask

  task tst_ignore_funct;
    input opcode_t opcode;
    input logic equal;
  begin
    for (int i = 0; i < 2**(FUNC_W); i++) begin
      tst(opcode, funct_t'(i), equal, 1'b0);
    end
  end
  endtask

  task tst_jitype;
    input opcode_t opcode;
  begin
    for (int eq = 0; eq < 2; eq++) begin
      tst_ignore_funct(opcode, eq);
    end
  end
  endtask

  initial
  begin
    
    // RTYPE
    reset_expected();
    exp_cuif.RegDst = 1'b1;
    exp_cuif.RegWr = 1'b1;
    exp_cuif.ALUOp = ALU_SLL;
    tst_rtype(RTYPE, SLLV);
    exp_cuif.ALUOp = ALU_SRL;
    tst_rtype(RTYPE, SRLV);
    exp_cuif.ALUOp = ALU_ADD;
    tst_rtype(RTYPE, ADD);
    tst_rtype(RTYPE, ADDU);
    exp_cuif.ALUOp = ALU_SUB;
    tst_rtype(RTYPE, SUB);
    tst_rtype(RTYPE, SUBU);
    exp_cuif.ALUOp = ALU_AND;
    tst_rtype(RTYPE, AND);
    exp_cuif.ALUOp = ALU_OR;
    tst_rtype(RTYPE, OR);
    exp_cuif.ALUOp = ALU_XOR;
    tst_rtype(RTYPE, XOR);
    exp_cuif.ALUOp = ALU_NOR;
    tst_rtype(RTYPE, NOR);
    exp_cuif.ALUOp = ALU_SLT;
    tst_rtype(RTYPE, SLT);
    exp_cuif.ALUOp = ALU_SLTU;
    tst_rtype(RTYPE, SLTU);
    reset_expected();
    exp_cuif.PCSrc = JUMPR;
    tst_rtype(RTYPE, JR);

    // JTYPE
    reset_expected();
    exp_cuif.PCSrc = JUMP;
    tst_jitype(J);
    exp_cuif.WrLinkReg = 1'b1;
    exp_cuif.RegWr = 1'b1;
    tst_jitype(JAL);

    // ITYPE - BRANCH
    reset_expected();
    exp_cuif.ALUOp = ALU_SUB;
    exp_cuif.PCSrc = BRANCH;
    tst_ignore_funct(BEQ, 1'b1);
    tst_ignore_funct(BNE, 1'b0);
    exp_cuif.PCSrc = NEXT;
    tst_ignore_funct(BEQ, 1'b0);
    tst_ignore_funct(BNE, 1'b1);

    // ITYPE - ARITHMETIC AND LOGICAL
    reset_expected();
    exp_cuif.ALUOp = ALU_ADD;
    exp_cuif.RegWr = 1'b1;
    exp_cuif.ALUSrc = 1'b1;
    exp_cuif.ExtOp = 1'b1;
    tst_jitype(ADDI);
    tst_jitype(ADDIU);
    exp_cuif.ALUOp = ALU_SLT;
    tst_jitype(SLTI);
    exp_cuif.ALUOp = ALU_SLTU;
    tst_jitype(SLTIU);
    exp_cuif.ALUOp = ALU_AND;
    exp_cuif.ExtOp = 1'b0;
    tst_jitype(ANDI);
    exp_cuif.ALUOp = ALU_OR;
    tst_jitype(ORI);
    exp_cuif.ALUOp = ALU_XOR;
    tst_jitype(XORI);
    exp_cuif.ALUOp = ALU_OR;
    exp_cuif.ShiftUp = 1'b1;
    tst_jitype(LUI);

    // ITYPE - LW
    reset_expected();
    exp_cuif.ALUOp = ALU_ADD;
    exp_cuif.MemRd = 1'b1;
    exp_cuif.RegWr = 1'b1;
    exp_cuif.ALUSrc = 1'b1;
    exp_cuif.MemToReg = 1'b1;
    exp_cuif.ExtOp = 1'b1;
    tst_jitype(LW);

    // ITYPE - SW
    reset_expected();
    exp_cuif.ALUOp = ALU_ADD;
    exp_cuif.MemWr = 1'b1;
    exp_cuif.ALUSrc = 1'b1;
    exp_cuif.ExtOp = 1'b1;
    tst_jitype(SW);

    // Halt
    reset_expected();
    exp_cuif.halt = 1'b1;
    exp_cuif.PCSrc = KEEP;
    tst_jitype(HALT);

  end
endprogram
