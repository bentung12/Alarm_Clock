module counter #( parameter int m=13, 
					   parameter int b=$clog2(m) ) 
				(
				input logic inc,
				input logic dec,
				input logic clk,
				input logic rst,
				output logic [b-1:0]cnt
				);
	
	
	logic [b - 1:0] nextCount;
	
	always_comb begin
		unique case (1'b1)
			inc && !dec : nextCount = (cnt == (m[b-1:0] - 1'b1)) ? '0 : (cnt + 1'b1);
			!inc && dec : nextCount = (cnt == '0) ? (m[b-1:0] - 1'b1) : (cnt - 1'b1);
			default : nextCount = cnt;
		endcase
	end
	
	
	
	ourDff #(b) dff1 (.rst, .clk, .en(1'b1), .q(cnt), .d(nextCount));

	
	
	
endmodule