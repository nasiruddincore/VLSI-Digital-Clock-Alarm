`timescale 1ns / 1ps

module multi_alarm_controller (
    input wire clk,
    input wire rst_n,
    input wire [4:0] current_hr,
    input wire [5:0] current_min,
    
    input wire [4:0] alm1_hr, input wire [5:0] alm1_min, input wire alm1_en,
    input wire [4:0] alm2_hr, input wire [5:0] alm2_min, input wire alm2_en,
    input wire [4:0] alm3_hr, input wire [5:0] alm3_min, input wire alm3_en,
    
    output reg trigger_light_relay,
    output reg trigger_radio_relay,
    output reg trigger_buzzer
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            trigger_light_relay <= 0;
            trigger_radio_relay <= 0;
            trigger_buzzer <= 0;
        end else begin
            if (alm1_en && (current_hr == alm1_hr) && (current_min == alm1_min))
                trigger_light_relay <= 1'b1;
            else trigger_light_relay <= 1'b0;

            if (alm2_en && (current_hr == alm2_hr) && (current_min == alm2_min))
                trigger_radio_relay <= 1'b1;
            else trigger_radio_relay <= 1'b0;

            if (alm3_en && (current_hr == alm3_hr) && (current_min == alm3_min))
                trigger_buzzer <= 1'b1;
            else trigger_buzzer <= 1'b0;
        end
    end
endmodule