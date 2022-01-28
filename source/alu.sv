`include "cpu_types_pkg.vh"
`include "alu_if.vh"

import cpu_types_pkg::*;

module alu (
    alu_if.alu aluif
);

word_t ra, rb;

always_comb
begin
    ra = aluif.ra;
    rb = aluif.rb;
    if (aluif.aluop == ALU_SUB)
        rb = ~rb + 1;
end

always_comb
begin
    case (aluif.aluop)
        ALU_SLL : aluif.out = aluif.rb << aluif.ra[4:0];
        ALU_SRL : aluif.out = aluif.rb >> aluif.ra[4:0];
        ALU_ADD,
        ALU_SUB : aluif.out = ra + rb;
        ALU_AND : aluif.out = aluif.ra & aluif.rb;
        ALU_OR  : aluif.out = aluif.ra | aluif.rb;
        ALU_XOR : aluif.out = aluif.ra ^ aluif.rb;
        ALU_NOR : aluif.out = ~(aluif.ra | aluif.rb);
        ALU_SLT : aluif.out = $signed(aluif.ra) < $signed(aluif.rb);
        ALU_SLTU: aluif.out = aluif.ra < aluif.rb;
        default : aluif.out = '0;
    endcase
end

always_comb
begin
    aluif.overflow = 1'b0;
    if (aluif.aluop == ALU_ADD || aluif.aluop == ALU_SUB)
        aluif.overflow = (ra[WORD_W-1] == rb[WORD_W-1]) && 
                         (aluif.out[WORD_W-1] != ra[WORD_W-1]);
end

assign aluif.negative = aluif.out[WORD_W-1] == 1'b1;
assign aluif.zero = aluif.out == '0;

endmodule
