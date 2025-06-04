module div_3#(
	parameter NUM =3)
	(
	input clk_in,
	input rst,
	output reg clk_out 
	);
	
	parameter WIDTH = $clog2(NUM);
	parameter CNT_END =NUM/2-1;
	reg [WIDTH - 1:0] cnt;
	
	always@(posedge clk_in or negedge rst)begin
		if(!rst)
			cnt <= 'b0;
		else if(cnt == CNT_END)
			cnt <= 'b0;
		else 
			cnt <= cnt+1'b1;
	end
	
endmodule