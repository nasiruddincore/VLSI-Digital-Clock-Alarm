`timescale 1ns / 1ps

module spi_dot_matrix(
    input wire clk,
    input wire rst_n,
    input wire [4:0] hr,
    input wire [5:0] min,
    output reg spi_cs,
    output reg spi_clk,
    output reg spi_data
);
    reg [15:0] shift_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            spi_cs <= 1;
            spi_clk <= 0;
            spi_data <= 0;
            shift_reg <= 16'h0000;
        end else begin
            // Simulates clocking data out to an external MAX7219 Dot Matrix module
            spi_clk <= ~spi_clk;
            if (!spi_clk) begin
                spi_data <= shift_reg[15];
                shift_reg <= {shift_reg[14:0], 1'b0};
            end
        end
    end
endmodule