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
  parameter CPUS = 2;

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
	FETCH,
	ARB,
	SNOOP,
	REACT2SNOOP,
	WB1,
	WB2,
	MEM2CACHE_W1,
	MEM2CACHE_W2,
	CACHE2CACHE_W1,
	CACHE2CACHE_W2
} state_t;

state_t state, nxt_state;
logic snooping, nxt_snooping, working, nxt_working;

always_ff @(posedge CLK, negedge nRST) 
begin
	if(nRST == 0) 
	begin
		state <= IDLE;
		snooping <= 1;
		working <= 0;
	end 
	else 
	begin
		state <= nxt_state;
		snooping <= nxt_snooping;
		working <= nxt_working;
	end
end

always_comb 
begin
	nxt_state = state;
	nxt_snooping = snooping;
	case(state)
		IDLE: 
		begin
			if(ccif.cctrans[0] || ccif.cctrans[1])
			begin
				nxt_state = ARB;
			end
			else if (ccif.iREN[0] || ccif.iREN[1]) 
			begin
				nxt_state = FETCH;
			end
		end
		FETCH: 
		begin
			if (ccif.ramstate == ACCESS)
			begin
				nxt_state = (ccif.cctrans == 0) ? IDLE : ARB;
			end
		end
		ARB:
		begin
			if (ccif.cctrans[snooping])
			begin
				nxt_state = SNOOP;
				nxt_snooping = ~snooping;
			end
			else if (ccif.cctrans[~snooping])
			begin
				nxt_state = SNOOP;
			end
		end
		SNOOP:
		begin
			if (ccif.dWEN[~snooping])
			begin
				nxt_state = WB1;
			end
			else if (ccif.dREN[~snooping])
			begin
				nxt_state = REACT2SNOOP;
			end
		end
		REACT2SNOOP:
		begin
			if (ccif.cctrans[snooping])
			begin
				nxt_state = CACHE2CACHE_W1;
			end
			else
			begin
				nxt_state = MEM2CACHE_W1;
			end
		end
		CACHE2CACHE_W1: 
		begin
			if (ccif.ccwrite[snooping] && ccif.ramstate == ACCESS) 
			begin
				nxt_state = CACHE2CACHE_W2;
			end
			else if (!ccif.ccwrite[snooping])
			begin
				nxt_state = CACHE2CACHE_W2;
			end
		end
		CACHE2CACHE_W2: 
		begin
			if (ccif.ccwrite[snooping] && ccif.ramstate == ACCESS) 
			begin
				nxt_state = IDLE;
			end
			else if (!ccif.ccwrite[snooping])
			begin
				nxt_state = IDLE;
			end
		end
		MEM2CACHE_W1: 
		begin
			if (ccif.ramstate == ACCESS) 
			begin 
				nxt_state = MEM2CACHE_W2;
			end
		end 
		MEM2CACHE_W2: 
		begin
			if (ccif.ramstate == ACCESS)
			begin 
				nxt_state = IDLE;
			end
		end
		WB1: 
		begin
			if (ccif.ramstate == ACCESS) 
			begin
				nxt_state = WB2;
			end
		end
		WB2: 
		begin
			if (ccif.ramstate == ACCESS) 
			begin
				nxt_state = IDLE;
			end
		end
	endcase
end

always_comb 
begin
	ccif.ccwait[0] = 0;
	ccif.ccwait[1] = 0;
	case(state)
		SNOOP,
		REACT2SNOOP,
		MEM2CACHE_W1,
		MEM2CACHE_W2,
		CACHE2CACHE_W1,
		CACHE2CACHE_W2: 
			ccif.ccwait[snooping] = 1;
	endcase
end

always_comb 
begin

	ccif.dwait[0] = 1; 
	ccif.dwait[1] = 1;
	ccif.dload[0] = 0; 
	ccif.dload[1] = 0;

	ccif.iwait[0] = 1; 
	ccif.iwait[1] = 1;
	ccif.iload[0] = 0; 
	ccif.iload[1] = 0;

	ccif.ramREN = 0;
	ccif.ramWEN = 0;
	ccif.ramaddr = 0;
	ccif.ramstore = 0;

	nxt_working = working;

	case(state)
		FETCH: 
		begin
			ccif.iwait[working] = ccif.ramstate != ACCESS;
			ccif.iload[working] = ccif.ramload;
			ccif.ramREN = ccif.iREN[working];
			ccif.ramaddr = ccif.iaddr[working];
			nxt_working = ccif.ramstate == ACCESS ? ~working : working;
		end
		MEM2CACHE_W1,
		MEM2CACHE_W2:
		begin
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
			ccif.dload[~snooping] = ccif.ramload;
			ccif.ramREN = ccif.dREN[~snooping];
			ccif.ramaddr = ccif.daddr[~snooping];
		end
		CACHE2CACHE_W1,
		CACHE2CACHE_W2:
		begin
			ccif.dload[~snooping] = ccif.dstore[snooping];

			ccif.dwait[snooping] = 1'b0;
			ccif.dwait[~snooping] = 1'b0;
			if(ccif.ccwrite[snooping])
			begin
				ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
				ccif.dwait[snooping] = ccif.ramstate != ACCESS;

				ccif.ramWEN = 1;
				ccif.ramaddr = ccif.daddr[snooping];
				ccif.ramstore = ccif.dstore[snooping];
			end
		end
		WB1,
		WB2:
		begin
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
			ccif.ramWEN = 1'b1;
			ccif.ramaddr = ccif.daddr[~snooping];
			ccif.ramstore = ccif.dstore[~snooping];
		end
	endcase
end

assign ccif.ccsnoopaddr[0] = ccif.daddr[1];
assign ccif.ccsnoopaddr[1] = ccif.daddr[0];
assign ccif.ccinv[0] = ccif.ccwrite[1];
assign ccif.ccinv[1] = ccif.ccwrite[0];

endmodule
