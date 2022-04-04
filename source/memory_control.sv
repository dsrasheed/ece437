/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;

  /*always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 1'b0) begin
      ccif.iwait <= 1'b1;
      ccif.dwait <= 1'b0;
    end
    else begin
      if (ccif.iwait == 1'b0)
        ccif.iwait <= 1'b1;
      else if (ccif.dwait == 1'b0)
        ccif.dwait <= 1'b1;
      else begin
        ccif.iwait <= ccif.iREN & (ccif.ramstate != ACCESS | ccif.dWEN | ccif.dREN);
        ccif.dwait <= (ccif.dWEN | ccif.dREN) & ccif.ramstate != ACCESS;
      end
    end
  end*/

  /*assign ccif.ramREN = (ccif.iREN | ccif.dREN) & ~ccif.dWEN;
  assign ccif.ramWEN = ccif.dWEN;
  assign ccif.ramaddr = ccif.dREN | ccif.dWEN ? ccif.daddr : ccif.iaddr;
  assign ccif.ramstore = ccif.dstore;

  assign ccif.iwait = ccif.iREN & (ccif.ramstate != ACCESS | ccif.dWEN | ccif.dREN);
  assign ccif.dwait = (ccif.dWEN | ccif.dREN) & ccif.ramstate != ACCESS;
  assign ccif.iload = ccif.ramload;
  assign ccif.dload = ccif.ramload;*/

typedef enum logic[3:0] {
  IDLE, 
	ARB,
	SNOOP, 
	FETCH, 
	WB1, 
	WB2, 
	MEM2CACHE, 
	WAIT, 
	CACHE2CACHE, 
	WRITE, 
	READ
} state_t;

state_t state, nxt_state;
logic snooping, nxt_snooping, rw_arb, nxt_rw_arb;

always_ff @(posedge CLK or negedge nRST) begin
  if(~nRST) begin
     state <= IDLE;
     snooping <= 1;
		 rw_arb <= 1;
  end else begin
     state <= nxt_state;
     snooping <= nxt_snooping;
		 rw_arb <= nxt_rw_arb;
  end
end

always_comb begin : NEXT_STATE_LOGIC
  nxt_state = state;
  nxt_snooping = snooping;
	nxt_rw_arb = rw_arb;
  case(state)
    IDLE: 
		begin
			if(rw_arb)
			begin
				if (ccif.dWEN[0] || ccif.dWEN[1]) nxt_state = WB1;
      	else if (ccif.dREN[0] || ccif.dREN[1]) nxt_state = ARB;
      	else if (ccif.iREN[0] || ccif.iREN[1]) nxt_state = FETCH;
				nxt_rw_arb = ~rw_arb;
			end
			else
			begin
      	if (ccif.dREN[0] || ccif.dREN[1]) nxt_state = ARB;
      	else if (ccif.dWEN[0] || ccif.dWEN[1]) nxt_state = WB1;
      	else if (ccif.iREN[0] || ccif.iREN[1]) nxt_state = FETCH;
			end
    end
    ARB: 
		begin	
     	if (ccif.cctrans[snooping]) 
			begin
        nxt_state = CACHE2CACHE;
        nxt_snooping = ~snooping;
      end
			else if (ccif.cctrans[~snooping])
			begin
				nxt_state = CACHE2CACHE;
			end
			else 
			begin
        nxt_state = MEM2CACHE;
      end
    end
    SNOOP: begin
      if(ccif.cctrans[snooping])
        nxt_state = CACHE2CACHE;
      else
        nxt_state = MEM2CACHE;
    end
    CACHE2CACHE: begin
      if (ccif.ramstate == ACCESS && ccif.ccwrite[snooping]) nxt_state = WRITE;
			else if (ccif.ramstate == ACCESS) nxt_state = READ;
    end
		READ: begin
      if (ccif.ramstate == ACCESS) nxt_state = IDLE;
    end
    WRITE: begin
      if (ccif.ramstate == ACCESS) nxt_state = IDLE;
    end
    MEM2CACHE: begin
      if (ccif.ramstate == ACCESS) nxt_state = WAIT;
    end
    WAIT: begin
      if (ccif.ramstate == ACCESS) nxt_state = IDLE;
    end
    FETCH: begin
      if (ccif.ramstate == ACCESS)
        nxt_state = (ccif.dREN != 0)? ARB:IDLE;
      if (ccif.dWEN[1] || ccif.dWEN[0]) nxt_state = WB1;
    end
    WB1: begin
      if (ccif.ramstate == ACCESS) nxt_state = WB2;
    end
    WB2: begin
      if (ccif.ramstate == ACCESS) nxt_state = IDLE;
    end

  endcase
end

always_comb begin: OUTPUT_LOGIC

  ccif.iwait[1] = 1; ccif.iwait[0] = 1;
  ccif.iload[1] = 0; ccif.iload[0] = 0;
  ccif.dwait[1] = 1; ccif.dwait[0] = 1;
  ccif.dload[1] = 0; ccif.dload[0] = 0;

  ccif.ramaddr = 0;
  ccif.ramstore = 0;
  ccif.ramWEN = 0;
  ccif.ramREN = 0;

  ccif.ccwait[1] = 0; ccif.ccwait[0] = 0;
	ccif.ccsnoopaddr[0] = ccif.daddr[1];
	ccif.ccsnoopaddr[1] = ccif.daddr[0];
	ccif.ccinv[0] = ccif.ccwrite[1];
	ccif.ccinv[1] = ccif.ccwrite[0];

  case(state)
		FETCH: begin
      if(ccif.iREN[1]) begin
        ccif.iload[1] = ccif.ramload;
        ccif.iwait[1] = ccif.ramstate != ACCESS;
        ccif.ramaddr = ccif.iaddr[1];
        ccif.ramREN = ccif.iREN[1];
      end else if (ccif.iREN[0]) begin
        ccif.iload[0] = ccif.ramload;
        ccif.iwait[0] = ccif.ramstate != ACCESS;
        ccif.ramaddr = ccif.iaddr[0];
        ccif.ramREN = ccif.iREN[0];
      end
    end
    ARB: begin
      ccif.ccwait[nxt_snooping] = 1;
    end
    SNOOP: begin
      ccif.ccwait[snooping] = 1;
    end
    MEM2CACHE: begin
      ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
      ccif.dload[~snooping] = ccif.ramload;
      ccif.ramaddr = ccif.daddr[~snooping];
      ccif.ramREN = ccif.dREN[~snooping];

      ccif.ccwait[snooping] = 1;
    end
    WAIT: begin
      ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
      ccif.dload[~snooping] = ccif.ramload;
      ccif.ramaddr = ccif.daddr[~snooping];
      ccif.ramREN = ccif.dREN[~snooping];

      ccif.ccwait[snooping] = 1;
    end
    CACHE2CACHE: begin
      ccif.dwait[snooping] = ccif.ramstate != ACCESS;
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
      ccif.dload[~snooping] = ccif.ramload;
			ccif.ramaddr = ccif.daddr[~snooping];
      ccif.ramREN = ccif.dREN[~snooping];
			if(ccif.ccwrite[snooping])
			begin
				ccif.dwait[snooping] = ccif.ramstate != ACCESS;
		    ccif.dload[~snooping] = ccif.dstore[snooping];
	
				ccif.ramaddr = ccif.daddr[snooping];
		    ccif.ramstore = ccif.dstore[snooping];
		    ccif.ramWEN = 1;
				ccif.ramREN = 0;
			end

      ccif.ccwait[snooping] = 1;
    end
    READ: begin
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
      ccif.dload[~snooping] = ccif.ramload;
			ccif.ramaddr = ccif.daddr[~snooping];
      ccif.ramREN = ccif.dREN[~snooping];

      ccif.ccwait[snooping] = 1;
    end
		WRITE: begin
      ccif.dwait[snooping] = ccif.ramstate != ACCESS;
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
      ccif.dload[~snooping] = ccif.dstore[snooping];

      ccif.ramaddr = ccif.daddr[snooping];
      ccif.ramstore = ccif.dstore[snooping];
      ccif.ramWEN = 1;

      ccif.ccwait[snooping] = 1;
    end
    WB1: begin
      if(ccif.dWEN[snooping]) begin
        ccif.dwait[snooping] = ccif.ramstate != ACCESS;
        ccif.ramaddr = ccif.daddr[snooping];
        ccif.ramWEN = ccif.dWEN[snooping];
        ccif.ramstore = ccif.dstore[snooping];
        ccif.ccwait[~snooping] = 1;
      end else if (ccif.dWEN[~snooping]) begin
        ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
        ccif.ramaddr = ccif.daddr[~snooping];
        ccif.ramWEN = ccif.dWEN[~snooping];
        ccif.ramstore = ccif.dstore[~snooping];
        ccif.ccwait[snooping] = 1;
      end
    end
    WB2: begin
      if(ccif.dWEN[snooping]) begin
        ccif.dwait[snooping] = ccif.ramstate != ACCESS;
        ccif.ramaddr = ccif.daddr[snooping];
        ccif.ramWEN = ccif.dWEN[snooping];
        ccif.ramstore = ccif.dstore[snooping];
        ccif.ccwait[~snooping] = 1;
      end else if (ccif.dWEN[~snooping]) begin
        ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
        ccif.ramaddr = ccif.daddr[~snooping];
        ccif.ramWEN = ccif.dWEN[~snooping];
        ccif.ramstore = ccif.dstore[~snooping];
        ccif.ccwait[snooping] = 1;
      end
    end
  endcase

end

endmodule
