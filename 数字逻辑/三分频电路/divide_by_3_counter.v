// File: divide_by_3_counter.v
// 基于 74LS112 J-K 触发器的 3 分频电路模块
// 状态序列: 00 -> 01 -> 10 -> (检测到11并清零) -> 00

module divide_by_3_counter (
    input clk_in,   // 输入时钟 (用于第一个触发器)
    input rst_n,    // 外部异步复位 (低电平有效，优先级最高)
    output q_out    // 3 分频输出 (通常是 Q2 的输出)
);

    // 内部信号声明
    wire q1_out;      // 第一个 J-K 触发器 (FF1) 的 Q 输出
    wire q2_out;      // 第二个 J-K 触发器 (FF2) 的 Q 输出
    wire clear_signal; // 用于异步清零 J-K 触发器的信号 (低电平有效)

    // 清零逻辑 (检测状态 11)
    // 当 q1_out 和 q2_out 都为 1 时，clear_signal 变为 0 (低电平有效，触发清零)
    assign clear_signal = !(q1_out & q2_out);

    // 实例化第一个 J-K 触发器 (FF1)
    // FF1 的 J 和 K 都接 1，使其在时钟上升沿翻转
    jk_ff_74ls112_simplified ff1_inst (
        .clk(clk_in),         // 时钟输入：外部输入时钟
        .j(1'b1),             // J 输入：高电平 (翻转模式)
        .k(1'b1),             // K 输入：高电平 (翻转模式)
        // 清零输入：如果 clear_signal 为低 (检测到 11) 或 rst_n 为低 (外部复位)，则清零
        .clr_n(clear_signal & rst_n),
        .q(q1_out)            // Q 输出：连接到 q1_out
    );

    // 实例化第二个 J-K 触发器 (FF2)
    // FF2 的 J 和 K 也接 1，使其在时钟上升沿翻转
    jk_ff_74ls112_simplified ff2_inst (
        .clk(q1_out),         // 时钟输入：第一个触发器的 Q 输出 (级联)
        .j(1'b1),             // J 输入：高电平 (翻转模式)
        .k(1'b1),             // K 输入：高电平 (翻转模式)
        // 清零输入：与 FF1 共享相同的清零逻辑
        .clr_n(clear_signal & rst_n),
        .q(q2_out)            // Q 输出：连接到 q2_out
    );

    // 将第二个触发器 (FF2) 的 Q 输出作为 3 分频的最终输出
    assign q_out = q2_out;

endmodule