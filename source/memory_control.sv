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

always_ff @(posedge CLK, negedge nRST) 
begin
	if(nRST == 0) 
	begin
		state <= IDLE;
		snooping <= 1;
		rw_arb <= 1;
	end 
	else 
	begin
		state <= nxt_state;
		snooping <= nxt_snooping;
		rw_arb <= nxt_rw_arb;
	end
end

always_comb 
begin
	nxt_state = state;
	nxt_snooping = snooping;
	nxt_rw_arb = rw_arb;
	case(state)
		IDLE: 
		begin
			if(ccif.cctrans[0] || ccif.cctrans[1])
			begin
				nxt_state = SNOOP;
			end
			else if (ccif.iREN[0] || ccif.iREN[1]) 
			begin
				nxt_state = FETCH;
			end
			/*if(rw_arb)
			begin
				if (ccif.dWEN[0] || ccif.dWEN[1]) 
				begin
					nxt_state = WB1;
				end
				else if (ccif.dREN[0] || ccif.dREN[1]) 
				begin
					nxt_state = ARB;
				end
				else if (ccif.iREN[0] || ccif.iREN[1]) 
				begin
					nxt_state = FETCH;
				end
				nxt_rw_arb = ~rw_arb;
			end
			else
			begin
				if (ccif.dREN[0] || ccif.dREN[1]) 
				begin
					nxt_state = ARB;
				end
				else if (ccif.dWEN[0] || ccif.dWEN[1]) 
				begin
					nxt_state = WB1;
				end
				else if (ccif.iREN[0] || ccif.iREN[1]) 
				begin
					nxt_state = FETCH;
				end
				nxt_rw_arb = ~rw_arb;
			end*/
		end
		FETCH: 
		begin
			if (ccif.ramstate == ACCESS)
			begin
				nxt_state = (ccif.cctrans == 0)? IDLE:ARB;
			end
			/*if (ccif.dWEN[1] || ccif.dWEN[0]) 
			begin
				nxt_state = WB1;
			end*/
		end
		SNOOP: 
		begin
			if(ccif.cctrans[snooping])
			begin
				nxt_state = ARB;
				nxt_snooping = ~snooping;
			end
			else if(ccif.cctrans[~snooping)
			begin
				nxt_state = ARB;
			end
		end
		ARB: 
		begin	
			if(ccif.dWEN[~snooping])
			begin
				if(ccif.ccwrite[~snooping])
				begin
					nxt_state = WB1;
				end
				else if(ccif.cctrans[snooping] && ccif.ccwrite[snooping])
				nxt_state = WB1;
			end
			else if(ccif.dREN[~snooping])
			begin
				if(ccif.cctrans[snooping])
				begin
					nxt_state = CACHE2CACHE;
				end
				else
				begin
					nxt_state = MEM2CACHE;
				end
			end
			/*else if(ccif.dREN[~snooping] && ccif.dWEN[snooping])
			begin
				nxt_state = CACHE2CACHE;
			end
			else if(ccif.dREN[~snooping])
			begin
				nxt_state = MEM2CACHE;
			end*/
		end
		CACHE2CACHE: 
		begin
			if (ccif.ramstate == ACCESS && ccif.ccwrite[snooping]) 
			begin
				nxt_state = WRITE;
			end
			else if (ccif.ramstate == ACCESS) 
			begin
				nxt_state = READ;
			end
		end
		READ: 
		begin
			if (ccif.ramstate == ACCESS) 
			begin 
				nxt_state = IDLE;
			end
		end
		WRITE: 
		begin
			if (ccif.ramstate == ACCESS) 
			begin 
				nxt_state = IDLE;
			end
		end
		MEM2CACHE: 
		begin
			if (ccif.ramstate == ACCESS) 
			begin 
				nxt_state = WAIT;
			end
		end
		WAIT: 
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
		SNOOP: 
		begin
			ccif.ccwait[snooping] = 1;
			ccif.ccwait[~snooping] = 1;
		end
		ARB: 
		begin
			ccif.ccwait[nxt_snooping] = 1;
			ccif.ccwait[~nxt_snooping] = 1;
		end
		MEM2CACHE: 
		begin
			ccif.ccwait[snooping] = 1;
		end
		WAIT: 
		begin
			ccif.ccwait[snooping] = 1;
		end
		CACHE2CACHE: 
		begin
			ccif.ccwait[snooping] = 1;
			end
		end
		READ: 
		begin
			ccif.ccwait[snooping] = 1;
		end
		WRITE: 
		begin
			ccif.ccwait[snooping] = 1;
		end
		WB1: 
		begin
			if(ccif.dWEN[snooping]) 
			begin
				ccif.ccwait[~snooping] = 1;
			end 
			else if (ccif.dWEN[~snooping]) 
			begin
				ccif.ccwait[snooping] = 1;
			end
		end
		WB2: 
		begin
			if(ccif.dWEN[snooping]) 
			begin
				ccif.ccwait[~snooping] = 1;
			end 
			else if (ccif.dWEN[~snooping]) 
			begin
				ccif.ccwait[snooping] = 1;
			end
		end
	endcase
end

always_comb 
begin

	ccif.dwait[0] = 1; 
	ccif.dwait[1] = 1;
	ccif.dload[0] = 0; 
	ccif.dload[1] = 0;

	ccif.ramREN = 0;
	ccif.ramWEN = 0;
	ccif.ramaddr = 0;
	ccif.ramstore = 0;

  case(state)
		MEM2CACHE: 
		begin
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
			ccif.dload[~snooping] = ccif.ramload;
			ccif.ramREN = ccif.dREN[~snooping];
			ccif.ramaddr = ccif.daddr[~snooping];
		end
		WAIT: 
		begin
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
			ccif.dload[~snooping] = ccif.ramload;
			ccif.ramREN = ccif.dREN[~snooping];
			ccif.ramaddr = ccif.daddr[~snooping];
		end
	  C2C_RD0: begin	    
	      ccif.ccwait[1] = 1;
	      if(ccif.cctrans[1] && ccif.ccwrite[1]) begin		 
		    ccif.ramWEN = 1;
		    daddr_m = ccif.ccsnoopaddr[1];
		    ccif.ramstore = ccif.dstore[1];
		    if(!dwait_m) begin		      
			 n_state = WRITECA0;
			 ccif.dwait[0] = 0;
			 ccif.dload[0] = ccif.dstore[1];
			 ccif.dwait[1] = 0;
		   end
	       end 
	       else begin		 
		    ccif.dwait[0] = 0;
		    ccif.dload[0] = ccif.dstore[1];
		    n_state = READCA0;
	       end
	  end
	  WRITECA0: begin	    
	       ccif.ccwait[1] = 1;
	       ccif.ramWEN = 1;
	       daddr_m = ccif.ccsnoopaddr[1];
	       ccif.ramstore = ccif.dstore[1];
	       if(!dwait_m) begin		 
		    n_state = IDLE;
		    ccif.dwait[1] = 0;
		    ccif.dwait[0] = 0;
		    ccif.dload[0] = ccif.dstore[1];
	       end
	  end 
	  READCA0:begin 
	       ccif.ccwait[1] = 1;
	       ccif.dwait[0] = 0;
	       ccif.dload[0] = ccif.dstore[1];
	       n_state = IDLE;
	       ccif.ccwait[1] = 0;
	  end
		CACHE2CACHE: 
		begin
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
			ccif.dload[~snooping] = ccif.dstore[snooping];
			if(ccif.ccwrite[snooping])
			begin
				ccif.dwait[snooping] = ccif.ramstate != ACCESS;

				ccif.ramWEN = 1;
				ccif.ramaddr = ccif.daddr[snooping];
				ccif.ramstore = ccif.dstore[snooping];
			end
		end
		READ: 
		begin
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
			ccif.dload[~snooping] = ccif.dstore[snooping];
		end
		WRITE: 
		begin
			ccif.dwait[snooping] = ccif.ramstate != ACCESS;
			ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
			ccif.dload[~snooping] = ccif.dstore[snooping];

			ccif.ramWEN = 1;
			ccif.ramaddr = ccif.daddr[snooping];
			ccif.ramstore = ccif.dstore[snooping];
		end
		WB1: 
		begin
			if(ccif.dWEN[snooping]) 
			begin
				ccif.dwait[snooping] = ccif.ramstate != ACCESS;
				ccif.ramWEN = ccif.dWEN[snooping];
				ccif.ramaddr = ccif.daddr[snooping];
				ccif.ramstore = ccif.dstore[snooping];
			end 
			else if (ccif.dWEN[~snooping]) 
			begin
				ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
				ccif.ramWEN = ccif.dWEN[~snooping];
				ccif.ramaddr = ccif.daddr[~snooping];
				ccif.ramstore = ccif.dstore[~snooping];
			end
		end
		WB2: 
		begin
			if(ccif.dWEN[snooping]) 
			begin
				ccif.dwait[snooping] = ccif.ramstate != ACCESS;
				ccif.ramWEN = ccif.dWEN[snooping];
				ccif.ramaddr = ccif.daddr[snooping];
				ccif.ramstore = ccif.dstore[snooping];
			end 
			else if (ccif.dWEN[~snooping]) 
			begin
				ccif.dwait[~snooping] = ccif.ramstate != ACCESS;
				ccif.ramWEN = ccif.dWEN[~snooping];
				ccif.ramaddr = ccif.daddr[~snooping];
				ccif.ramstore = ccif.dstore[~snooping];
			end
		end
	endcase
end
	
always_comb
begin

	ccif.iwait[0] = 1; 
	ccif.iwait[1] = 1;
	ccif.iload[0] = 0; 
	ccif.iload[1] = 0;

	ccif.ramREN = 0;
	ccif.ramaddr = 0;

	case(state)
		FETCH: 
		begin
			if(ccif.iREN[1]) 
			begin
				ccif.iwait[1] = ccif.ramstate != ACCESS;
				ccif.iload[1] = ccif.ramload;
				ccif.ramREN = ccif.iREN[1];
				ccif.ramaddr = ccif.iaddr[1];
			end 
			else if (ccif.iREN[0]) 
			begin
				ccif.iwait[0] = ccif.ramstate != ACCESS;
				ccif.iload[0] = ccif.ramload;
				ccif.ramREN = ccif.iREN[0];
				ccif.ramaddr = ccif.iaddr[0];
			end
		end
	endcase
end

assign ccif.ccsnoopaddr[0] = ccif.daddr[1];
assign ccif.ccsnoopaddr[1] = ccif.daddr[0];
assign ccif.ccinv[0] = ccif.ccwrite[1];
assign ccif.ccinv[1] = ccif.ccwrite[0];
end

endmodule
