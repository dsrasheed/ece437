// interface include

// memory types
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

module forwarding_unit (
  forwarding_unit_if.fu fuif
);

import cpu_types_pkg::*;
import datapath_types_pkg::*;

always_comb begin
    fuif.new_rdat1 = '0;
    fuif.override_rdat1 = 1'b0;
    if (fuif.mem_RegWr && fuif.mem_wsel == fuif.rs) 
    begin
        fuif.new_rdat1 = fuif.aluOut;
        fuif.override_rdat1 = 1'b1;
    end
    else if (fuif.wr_RegWr && fuif.wr_wsel == fuif.rs) 
    begin
        fuif.new_rdat1 = fuif.writeback;
        fuif.override_rdat1 = 1'b1;
    end

    fuif.new_rdat2 = '0;
    fuif.override_rdat2 = 1'b0;
    if (fuif.wr_RegWr && fuif.mem_wsel == fuif.rt) 
    begin
        fuif.new_rdat2 = fuif.aluOut;
        fuif.override_rdat2 = 1'b1;
    end
    else if (fuif.wr_RegWr && fuif.wr_wsel == fuif.rt) 
    begin
        fuif.new_rdat2 = fuif.writeback;
        fuif.override_rdat2 = 1'b1;
    end
end

endmodule
