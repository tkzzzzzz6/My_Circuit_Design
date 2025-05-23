// File: jk_ff_74ls112_simplified.v
// 74LS112 简化版 J-K 触发器模块
// 模拟单个 J-K 触发器，带异步低电平有效清零 (clr_n)

module jk_ff_74ls112_simplified (
    input clk,    // 时钟输入 (上升沿触发)
    input j,      // J 输入
    input k,      // K 输入
    input clr_n,  // 异步清零输入 (低电平有效，优先级高于时钟)
    output reg q   // Q 输出
);

    // 组合逻辑，决定 J-K 触发器在下一个时钟沿的潜在行为
    // 注意：这不是实际的组合逻辑门，而是Verilog行为建模
    // 异步清零逻辑优先
    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) begin // 如果清零信号 clr_n 是低电平，则异步清零
            q <= 1'b0; // Q 被强制清零为 0
        end else begin // 否则，在时钟上升沿同步工作
            // J-K 触发器的状态转换表
            case ({j, k}) // 根据 J 和 K 的组合来决定 Q 的下一个状态
                2'b00: begin // J=0, K=0: 保持状态 (No Change)
                    // q 保持不变
                end
                2'b01: begin // J=0, K=1: 复位 (Reset, Q = 0)
                    q <= 1'b0;
                end
                2'b10: begin // J=1, K=0: 置位 (Set, Q = 1)
                    q <= 1'b1;
                end
                2'b11: begin // J=1, K=1: 翻转 (Toggle, Q = ~Q)
                    q <= ~q;
                end
                default: begin
                    // 默认情况，通常不会发生，但为了完整性可以添加
                    // 或者使用 `q <= 1'bx;` 警告不确定状态
                end
            endcase
        end
    end

endmodule