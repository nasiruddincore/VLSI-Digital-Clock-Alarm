`timescale 1ns / 1ps

module top_digital_clock #(
    parameter BOARD_CLK = 50_000_000
)(
    input wire clk,
    input wire rst_n,
    
    input wire btn_time,    
    input wire btn_wakeup,  
    input wire btn_plus,    
    input wire btn_minus,   
    input wire btn_snooze,  
    
    output wire spi_cs,
    output wire spi_clk,
    output wire spi_data,
    
    output wire trigger_radio,
    output wire trigger_buzzer
);
    wire tick_1hz, tick_1k;
    wire [5:0] min, alarm_min;
    wire [4:0] hr, alarm_hr;

    clk_divider #(.BOARD_CLK(BOARD_CLK)) clk_div (
        .clk(clk), .rst_n(rst_n),
        .tick_1hz(tick_1hz), .tick_1k(tick_1k)
    );

    ui_fsm user_interface (
        .clk(clk), .rst_n(rst_n),
        .btn_time(btn_time), .btn_wakeup(btn_wakeup),
        .btn_plus(btn_plus), .btn_minus(btn_minus),
        .tick_1hz(tick_1hz),
        .current_hr(hr), .current_min(min),
        .alarm_hr(alarm_hr), .alarm_min(alarm_min)
    );

    multi_alarm_controller alarm_logic (
        .clk(clk), .rst_n(rst_n),
        .current_hr(hr), .current_min(min),
        .alm1_hr(alarm_hr), .alm1_min(alarm_min), .alm1_en(1'b1), // Dynamic UI Alarm
        .alm2_hr(5'd9), .alm2_min(6'd0), .alm2_en(1'b1),          // Hardcoded Dashboard Alarm
        .alm3_hr(5'd12), .alm3_min(6'd30), .alm3_en(1'b1),        // Hardcoded Dashboard Alarm
        .trigger_light_relay(), // Floating output
        .trigger_radio_relay(trigger_radio),
        .trigger_buzzer(trigger_buzzer)
    );

    spi_dot_matrix display (
        .clk(clk), .rst_n(rst_n),
        .hr(hr), .min(min),
        .spi_cs(spi_cs), .spi_clk(spi_clk), .spi_data(spi_data)
    );
endmodule