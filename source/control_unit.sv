// memory types
`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"

import cpu_types_pkg::*;

module control_unit (
  control_unit_if.cu cuif
);

typedef enum logic [2:0] {
    ALUG_SUB,
    ALUG_OR,
    ALUG_AND,
    ALUG_XOR,
    ALUG_RTYPE,
    ALUG_ADD,
    ALUG_SLT,
    ALUG_SLTU
} alug_t;

alug_t ALUg;

always_comb begin
    ALUg = ALUG_SUB;
    cuif.RegDst = 1'b0;
    cuif.RegWr = 1'b0;
    cuif.MemWr = 1'b0;
    cuif.MemRd = 1'b0;
    cuif.MemToReg = 1'b0;
    cuif.ALUSrc = 1'b0;
    cuif.ExtOp = 1'b0;
    cuif.ShiftUp = 1'b0;
    cuif.WrLinkReg = 1'b0;
    cuif.halt = 1'b0;
    cuif.PCSrc = NEXT;
    casez (cuif.opcode)
        RTYPE: begin
            ALUg = ALUG_RTYPE;
            if (cuif.funct != JR) begin
                cuif.RegDst = 1'b1;
                cuif.RegWr = 1'b1;
            end
            else begin
                cuif.PCSrc = JUMPR;
            end
        end
        J: begin
            cuif.PCSrc = JUMP;
        end
        JAL: begin
            cuif.WrLinkReg = 1'b1;
            cuif.RegWr = 1'b1;
            cuif.PCSrc = JUMP;
        end
        BEQ: begin
            ALUg = ALUG_SUB;
            cuif.PCSrc = BREQ;
        end
        BNE: begin
            ALUg = ALUG_SUB;
            cuif.PCSrc = BRNE;
        end
        ADDI,
        ADDIU: begin
            ALUg = ALUG_ADD;
            cuif.RegWr = 1'b1;
            cuif.ALUSrc = 1'b1;
            cuif.ExtOp = 1'b1;
        end
        SLTI: begin
            ALUg = ALUG_SLT;
            cuif.RegWr = 1'b1;
            cuif.ALUSrc = 1'b1;
            cuif.ExtOp = 1'b1;
        end
        SLTIU: begin
            ALUg = ALUG_SLTU;
            cuif.RegWr = 1'b1;
            cuif.ALUSrc = 1'b1;
            cuif.ExtOp = 1'b1;
        end
        ANDI: begin
            ALUg = ALUG_AND;
            cuif.RegWr = 1'b1;
            cuif.ALUSrc = 1'b1;
        end
        ORI: begin
            ALUg = ALUG_OR;
            cuif.RegWr = 1'b1;
            cuif.ALUSrc = 1'b1;
        end
        XORI: begin
            ALUg = ALUG_XOR;
            cuif.RegWr = 1'b1;
            cuif.ALUSrc = 1'b1;
        end
        LUI: begin
            ALUg = ALUG_OR;
            cuif.RegWr = 1'b1;
            cuif.ALUSrc = 1'b1;
            cuif.ShiftUp = 1'b1;
        end
        LW: begin
            ALUg = ALUG_ADD;
            cuif.MemRd = 1'b1;
            cuif.RegWr = 1'b1;
            cuif.ALUSrc = 1'b1;
            cuif.MemToReg = 1'b1;
            cuif.ExtOp = 1'b1;
        end
        SW: begin
            ALUg = ALUG_ADD;
            cuif.MemWr = 1'b1;
            cuif.ALUSrc = 1'b1;
            cuif.ExtOp = 1'b1;
        end
        HALT: begin
            cuif.halt = 1'b1;
            cuif.PCSrc = KEEP;
        end
    endcase
end

always_comb begin
    cuif.ALUOp = ALU_SUB;
    casez (ALUg)
        ALUG_SUB  : cuif.ALUOp = ALU_SUB;
        ALUG_OR   : cuif.ALUOp = ALU_OR;
        ALUG_AND  : cuif.ALUOp = ALU_AND;
        ALUG_XOR  : cuif.ALUOp = ALU_XOR;
        ALUG_ADD  : cuif.ALUOp = ALU_ADD;
        ALUG_SLT  : cuif.ALUOp = ALU_SLT;
        ALUG_SLTU : cuif.ALUOp = ALU_SLTU;
        ALUG_RTYPE:
        case (cuif.funct)
            SLLV: cuif.ALUOp = ALU_SLL;
            SRLV: cuif.ALUOp = ALU_SRL;
            ADD : cuif.ALUOp = ALU_ADD;
            ADDU: cuif.ALUOp = ALU_ADD;
            SUB : cuif.ALUOp = ALU_SUB;
            SUBU: cuif.ALUOp = ALU_SUB;
            AND : cuif.ALUOp = ALU_AND;
            OR  : cuif.ALUOp = ALU_OR;
            XOR : cuif.ALUOp = ALU_XOR;
            NOR : cuif.ALUOp = ALU_NOR;
            SLT : cuif.ALUOp = ALU_SLT;
            SLTU: cuif.ALUOp = ALU_SLTU;
        endcase
    endcase
end

endmodule