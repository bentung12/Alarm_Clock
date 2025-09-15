module ourDff #(size = 1)
		(input logic clk, input logic rst, input logic [size-1:0]d, input logic en, output logic [size-1:0]q);
		
		always_ff @(posedge clk) begin
			unique case(1'b1) //active high
				rst : q[size-1:0] <= '0;
				en && ~rst : q[size-1:0] <= d[size-1:0];
				default : q[size-1:0] <= q[size-1:0];
			endcase
		end
endmodule