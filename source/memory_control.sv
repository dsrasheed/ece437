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
`include "caches_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;
  import caches_pkg::*;

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

typedef enum logic[4:0] {
  IDLE,
	FETCH,
	ARB,
	SNOOP,
	SNOOP_BUFFER1,
	SNOOP_BUFFER2,
	REACT2SNOOP,
	WB1,
	WB2,
	MEM2CACHE_W1,
	MEM2CACHE_BUFFER1,
	MEM2CACHE_BUFFER2,
	MEM2CACHE_W2,
	CACHE2CACHE_W1,
	CACHE2CACHE_BUFFER1,
	CACHE2CACHE_BUFFER2,
	CACHE2CACHE_W2,
	SNOOP_BUFFER3,
	SNOOP_BUFFER4,
	SNOOP_BUFFER5,
	WBBUFFER1,
	WBBUFFER2
} state_t;

state_t state, nxt_state;
logic snooping, nxt_snooping, working, nxt_working;

RUN_t latched_ccif;
/*
assign latched_ccif.ccwrite = ccif.ccwrite;
assign latched_ccif.cctrans = ccif.cctrans;
assign ccif.ccinv = latched_ccif.ccinv;
assign ccif.ccwait = latched_ccif.ccwait;
assign ccif.ccsnoopaddr = latched_ccif.ccsnoopaddr;
assign latched_ccif.ramload = ccif.ramload;
assign latched_ccif.ramstate = ccif.ramstate;
assign ccif.ramstore = latched_ccif.ramstore;
assign ccif.ramaddr = latched_ccif.ramaddr;
assign ccif.ramREN = latched_ccif.ramREN;
assign ccif.ramWEN = latched_ccif.ramWEN;
assign latched_ccif.iREN = ccif.iREN;
assign latched_ccif.dWEN = ccif.dWEN;
assign latched_ccif.dREN = ccif.dREN;
assign ccif.iwait = latched_ccif.iwait;
assign ccif.iload = latched_ccif.iload;
assign latched_ccif.iaddr = ccif.iaddr;
assign ccif.dwait = latched_ccif.dwait;
assign ccif.dload = latched_ccif.dload;
assign latched_ccif.dstore = ccif.dstore;
assign latched_ccif.daddr = ccif.daddr;
*/


always_ff @ (posedge CLK, negedge nRST)
begin
	if (nRST == 0)
	begin
		ccif.iwait <= '1;
		ccif.iload <= '0;
		ccif.ccinv <= '0;
		ccif.ccwait <= '0;
		ccif.dwait <= '1;
		ccif.dload <= '0;
		ccif.ccsnoopaddr <= '0;
		ccif.ramstore <= '0;
		ccif.ramaddr <= '0;
		ccif.ramREN <= '0;
		ccif.ramWEN <= '0;
		latched_ccif.ccwrite <= '0;
		latched_ccif.cctrans <= '0;
		latched_ccif.ramload <= '0;
		latched_ccif.ramstate <= FREE;
		latched_ccif.iREN <= '0;
		latched_ccif.dWEN <= '0;
		latched_ccif.dREN <= '0;
		latched_ccif.iaddr <= '0;
		latched_ccif.dstore <= '0;
		latched_ccif.daddr <= '0;
	end
	else
	begin
		ccif.iwait <= latched_ccif.iwait;
		ccif.iload <= latched_ccif.iload;
		ccif.ccinv <= latched_ccif.ccinv;
		ccif.ccwait <= latched_ccif.ccwait;
		ccif.dwait <= latched_ccif.dwait;
		ccif.dload <= latched_ccif.dload;
		ccif.ccsnoopaddr <= latched_ccif.ccsnoopaddr;
		ccif.ramstore <= latched_ccif.ramstore;
		ccif.ramaddr <= latched_ccif.ramaddr;
		ccif.ramREN <= latched_ccif.ramREN;
		ccif.ramWEN <= latched_ccif.ramWEN;
		latched_ccif.ccwrite <= ccif.ccwrite;
		latched_ccif.cctrans <= ccif.cctrans;
		latched_ccif.ramload <= ccif.ramload;
		latched_ccif.ramstate <= ccif.ramstate;
		latched_ccif.iREN <= ccif.iREN;
		latched_ccif.dWEN <= ccif.dWEN;
		latched_ccif.dREN <= ccif.dREN;
		latched_ccif.iaddr <= ccif.iaddr;
		latched_ccif.dstore <= ccif.dstore;
		latched_ccif.daddr <= ccif.daddr;
	end
end

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
			if(latched_ccif.cctrans[0] || latched_ccif.cctrans[1])
			begin
				nxt_state = ARB;
			end
			else if (latched_ccif.iREN[0] || latched_ccif.iREN[1]) 
			begin
				nxt_state = FETCH;
			end
		end
		FETCH: 
		begin
			if (latched_ccif.ramstate == ACCESS)
			begin
				nxt_state = (latched_ccif.cctrans == 0) ? SNOOP_BUFFER4 : ARB;
			end
		end
		ARB:
		begin
			if (latched_ccif.cctrans[snooping])
			begin
				nxt_state = SNOOP;
				nxt_snooping = ~snooping;
			end
			else if (latched_ccif.cctrans[~snooping])
			begin
				nxt_state = SNOOP;
			end
		end
		SNOOP:
		begin
			if (latched_ccif.dWEN[~snooping])
			begin
				nxt_state = WB1;
			end
			else if (latched_ccif.dREN[~snooping])
			begin
				nxt_state = SNOOP_BUFFER1;
			end
		end
		SNOOP_BUFFER1:
		begin
			nxt_state = SNOOP_BUFFER2;
		end
		SNOOP_BUFFER2:
		begin
			nxt_state = REACT2SNOOP;
		end
		REACT2SNOOP:
		begin
			if (latched_ccif.cctrans[snooping])
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
			if (latched_ccif.ccwrite[snooping] && latched_ccif.ramstate == ACCESS) 
			begin
				nxt_state = CACHE2CACHE_BUFFER1;
			end
			else if (!latched_ccif.ccwrite[snooping])
			begin
				nxt_state = CACHE2CACHE_BUFFER1;
			end
		end
		CACHE2CACHE_BUFFER1:
		begin
			nxt_state = CACHE2CACHE_BUFFER2;
		end
		CACHE2CACHE_BUFFER2:
		begin
			nxt_state = CACHE2CACHE_W2;
		end
		CACHE2CACHE_W2: 
		begin
			if (latched_ccif.ccwrite[snooping] && latched_ccif.ramstate == ACCESS) 
			begin
				nxt_state = SNOOP_BUFFER3;
			end
			else if (!latched_ccif.ccwrite[snooping])
			begin
				nxt_state = SNOOP_BUFFER3;
			end
		end
		MEM2CACHE_W1: 
		begin
			if (latched_ccif.ramstate == ACCESS) 
			begin 
				nxt_state = MEM2CACHE_BUFFER1;
			end
		end
		MEM2CACHE_BUFFER1:
		begin
			nxt_state = MEM2CACHE_BUFFER2;
		end
		MEM2CACHE_BUFFER2:
		begin
			nxt_state = MEM2CACHE_W2;
		end
		MEM2CACHE_W2: 
		begin
			if (latched_ccif.ramstate == ACCESS)
			begin
				nxt_state = SNOOP_BUFFER3;
			end
		end
		WB1: 
		begin
			if (latched_ccif.ramstate == ACCESS) 
			begin
				nxt_state = WBBUFFER1;
			end
		end
		WBBUFFER1:
		begin
			nxt_state = WBBUFFER2;
		end
		WBBUFFER2:
		begin
			nxt_state = WB2;
		end
		WB2: 
		begin
			if (latched_ccif.ramstate == ACCESS) 
			begin
				nxt_state = SNOOP_BUFFER3;
			end
		end
		SNOOP_BUFFER3:
		begin
			nxt_state = SNOOP_BUFFER4;
		end
		SNOOP_BUFFER4:
		begin
			nxt_state = IDLE;
		end
		SNOOP_BUFFER5:
		begin
			nxt_state = IDLE;
		end
	endcase
end

always_comb 
begin
	latched_ccif.ccwait[0] = 0;
	latched_ccif.ccwait[1] = 0;
	case(state)
		SNOOP,
		REACT2SNOOP,
		/*MEM2CACHE_W1,
		MEM2CACHE_W2,*/
		CACHE2CACHE_W1,
		CACHE2CACHE_BUFFER1,
		CACHE2CACHE_BUFFER2,
		CACHE2CACHE_W2,
		SNOOP_BUFFER1,
		SNOOP_BUFFER2:
			latched_ccif.ccwait[snooping] = 1;
	endcase
end

always_comb 
begin

	latched_ccif.dwait[0] = 1; 
	latched_ccif.dwait[1] = 1;
	latched_ccif.dload[0] = 0; 
	latched_ccif.dload[1] = 0;

	latched_ccif.iwait[0] = 1; 
	latched_ccif.iwait[1] = 1;
	latched_ccif.iload[0] = 0; 
	latched_ccif.iload[1] = 0;

	latched_ccif.ramREN = 0;
	latched_ccif.ramWEN = 0;
	latched_ccif.ramaddr = 0;
	latched_ccif.ramstore = 0;

	nxt_working = working;

	case(state)
		FETCH: 
		begin
			latched_ccif.iwait[working] = latched_ccif.ramstate != ACCESS;
			latched_ccif.iload[working] = latched_ccif.ramload;
			latched_ccif.ramREN = latched_ccif.iREN[working];
			latched_ccif.ramaddr = latched_ccif.iaddr[working];
			nxt_working = latched_ccif.ramstate == ACCESS ? ~working : working;
		end
		MEM2CACHE_W1,
		MEM2CACHE_W2:
		begin
			latched_ccif.dwait[~snooping] = latched_ccif.ramstate != ACCESS;
			latched_ccif.dload[~snooping] = latched_ccif.ramload;
			latched_ccif.ramREN = latched_ccif.dREN[~snooping];
			latched_ccif.ramaddr = latched_ccif.daddr[~snooping];
		end
		CACHE2CACHE_W1,
		CACHE2CACHE_W2:
		begin
			latched_ccif.dload[~snooping] = latched_ccif.dstore[snooping];

			latched_ccif.dwait[snooping] = 1'b0;
			latched_ccif.dwait[~snooping] = 1'b0;
			if(latched_ccif.ccwrite[snooping])
			begin
				latched_ccif.dwait[~snooping] = latched_ccif.ramstate != ACCESS;
				latched_ccif.dwait[snooping] = latched_ccif.ramstate != ACCESS;

				latched_ccif.ramWEN = 1;
				latched_ccif.ramaddr = latched_ccif.daddr[snooping];
				latched_ccif.ramstore = latched_ccif.dstore[snooping];
			end
		end
		WB1,
		WB2:
		begin
			latched_ccif.dwait[~snooping] = latched_ccif.ramstate != ACCESS;
			latched_ccif.ramWEN = 1'b1;
			latched_ccif.ramaddr = latched_ccif.daddr[~snooping];
			latched_ccif.ramstore = latched_ccif.dstore[~snooping];
		end
	endcase
end

assign latched_ccif.ccsnoopaddr[0] = latched_ccif.daddr[1];
assign latched_ccif.ccsnoopaddr[1] = latched_ccif.daddr[0];
assign latched_ccif.ccinv[0] = latched_ccif.ccwrite[1];
assign latched_ccif.ccinv[1] = latched_ccif.ccwrite[0];

endmodule
