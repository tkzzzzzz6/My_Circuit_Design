// File: tb_divide_by_3_counter.v
// 3 分频电路的测试平台

`timescale 1ns / 1ps // 定义时间单位和精度

module tb_divide_by_3_counter;

    // Testbench 信号声明 (对应 DUT 的输入输出)
    reg clk_in;   // 输入时钟
    reg rst_n;    // 外部复位信号
    wire q_out;   // 3 分频输出

    // 内部信号，用于观察计数器的状态
    wire tb_q1_out;
    wire tb_q2_out;
    wire tb_clear_signal;

    // 实例化待测试模块 (DUT - Device Under Test)
    // 连接 DUT 的输入输出端口到 Testbench 的信号
    divide_by_3_counter dut (
        .clk_in(clk_in),
        .rst_n(rst_n),
        .q_out(q_out)
    );

    // 为了在测试平台中观察 DUT 内部的 q1_out, q2_out 和 clear_signal，
    // 我们可以使用 SystemVerilog 的 dot-notation 访问 (一些仿真器支持)
    // 或者更通用地，在 DUT 模块中将它们声明为 output，以便在顶层测试平台中连接
    // 但在 Verilog-2001+ 中，`assign` 可以直接连接到内部 wire/reg
    // 推荐的方法是在 DUT 模块中添加这些输出端口，或者通过层次化引用 ($dumpvars)
    // 这里我们使用层次化引用来方便波形查看
    assign tb_q1_out = dut.q1_out;         // 访问 FF1 的 Q 输出
    assign tb_q2_out = dut.q2_out;         // 访问 FF2 的 Q 输出
    assign tb_clear_signal = dut.clear_signal; // 访问清零信号

    // 时钟生成块
    initial begin
        clk_in = 0; // 初始化时钟为 0
        forever #10 clk_in = ~clk_in; // 每 10ns 翻转一次，周期为 20ns (50MHz)
    end

    // 仿真激励块
    initial begin
        // 1. 初始化复位
        rst_n = 0; // 强制复位为低电平
        $display("Time=%0t: Applying Reset (rst_n = %b)", $time, rst_n);
        #30;      // 保持复位 30ns (确保触发器完全复位)
        rst_n = 1; // 释放复位
        $display("Time=%0t: Releasing Reset (rst_n = %b)", $time, rst_n);

        // 2. 运行仿真，观察计数器行为
        #200;     // 运行 200ns，观察多个分频周期

        // 3. 结束仿真
        $display("Time=%0t: Simulation finished.", $time);
        $stop; // 停止仿真 (在某些仿真器中比 $finish 更好用)
        // $finish; // 或者使用 $finish 终止仿真
    end

    // 波形文件输出 (VCD - Value Change Dump)
    initial begin
        $dumpfile("divide_by_3_counter.vcd"); // 指定 VCD 文件名
        $dumpvars(0, tb_divide_by_3_counter); // 捕获 tb_divide_by_3_counter 模块内的所有信号
    end

endmodule