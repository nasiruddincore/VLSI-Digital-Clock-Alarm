`timescale 1ns / 1ps

module clk_divider #(
    parameter BOARD_CLK = 50_000_000
)(
    input wire clk,
    input wire rst_n,
    output reg tick_1hz,
    output reg tick_1k
);
    reg [31:0] cnt_1hz;
    reg [15:0] cnt_1k;

    // 1 Hz Tick Generation (Timekeeping)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_1hz <= 0;
            tick_1hz <= 0;
        end else begin
            if (cnt_1hz >= BOARD_CLK - 1) begin
                cnt_1hz <= 0;
                tick_1hz <= 1'b1;
            end else begin
                cnt_1hz <= cnt_1hz + 1;
                tick_1hz <= 1'b0;
            end
        end
    end

    // 1 kHz Tick Generation (SPI & UI Processing)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_1k <= 0;
            tick_1k <= 0;
        end else begin
            if (cnt_1k >= (BOARD_CLK/1000) - 1) begin
                cnt_1k <= 0;
                tick_1k <= 1'b1;
            end else begin
                cnt_1k <= cnt_1k + 1;
                tick_1k <= 1'b0;
            end
        end
    end
endmodule