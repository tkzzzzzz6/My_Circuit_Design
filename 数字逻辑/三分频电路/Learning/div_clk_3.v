// 3分频电路(50MHZ~5MHZ):duty=33.3%,(尖峰脉冲)

module div_clk_3(
    input sys_clk, //50MHZ
    input sys_rst_n,
    output reg clk_out //3分频,50MHZ/3=16.67MHZ
);

reg [31:0] cnt; //计数器

parameter CNT_MAX = 3;

// 计数器计数3个50MHZ的时钟周期
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n == 1'b0) 
        cnt <= 32'd0;
    else if(cnt < CNT_MAX - 1'b1)
        cnt <= cnt + 1'b1;
    else 
        cnt <= 32'd0;
    end

// 产生输出的50MHZ/3=16.67MHZ的时钟信号(尖峰脉冲)
assign clk_out = (CNT_MAX - 1'b1) ? 1'b1 : 1'b0; 
endmodule

