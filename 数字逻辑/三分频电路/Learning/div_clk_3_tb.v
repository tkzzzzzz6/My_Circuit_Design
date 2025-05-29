`timescale 1ns/1ps

module div_clk_3_tb;

reg sys_clk; //50MHZ
reg sys_rst_n; 

wire clk_out; //

div_clk_3 u_div_inst(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .clk_out(clk_out)
);

initial sys_clk = 1'b1;
always #10 sys_clk = ~sys_clk;

initial begin 
    sys_rst_n = 1'b0;
    #200.1
    sys_rst_n = 1'b1;
end

endmodule