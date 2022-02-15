`include "cpu_types_pkg.vh"
`include "register_file_if.vh"

import cpu_types_pkg::*;

module register_file (
    input CLK, nRST,
    register_file_if.rf rfif
);

word_t registers[2**REG_W];
word_t nxt_registers[2**REG_W];

always_ff @ (negedge CLK, negedge nRST) 
begin
    if (nRST == 1'b0)
        for (int i = 0; i < 2**REG_W; i++)
        begin
            registers[i] <= '0;
        end
    else
        registers <= nxt_registers;
end

always_comb
begin
    nxt_registers = registers;
    if (rfif.WEN && rfif.wsel != '0)
            nxt_registers[rfif.wsel] = rfif.wdat;
end

assign rfif.rdat1 = registers[rfif.rsel1];
assign rfif.rdat2 = registers[rfif.rsel2];

endmodule
