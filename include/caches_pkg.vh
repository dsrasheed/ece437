`ifndef CACHES_PKG_VH
`define CACHES_PKG_VH

`include "cpu_types_pkg.vh"

package caches_pkg;
  // import types
  import cpu_types_pkg::*;

  typedef struct packed {
        logic [2-1:0] iREN, dREN, dWEN, iwait, dwait, ccwrite, cctrans, ccwait, ccinv;
        word_t [2-1:0] iaddr, daddr, iload, dload, dstore, ccsnoopaddr;
        ramstate_t ramstate;
        logic ramWEN, ramREN;
        word_t ramload, ramstore, ramaddr;
  } RUN_t;

endpackage
`endif