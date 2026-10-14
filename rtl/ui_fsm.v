`timescale 1ns / 1ps

module ui_fsm (
    input wire clk,
    input wire rst_n,
    input wire btn_time,    // "Time" button
    input wire btn_wakeup,  // "Wake up" button
    input wire btn_plus,    // "+" button
    input wire btn_minus,   // "-" button
    input wire tick_1hz,    
    output reg [4:0] current_hr,
    output reg [5:0] current_min,
    output reg [4:0] alarm_hr,
    output reg [5:0] alarm_min
);
    localparam RUN = 2'd0;
    localparam SET_TIME = 2'd1;
    localparam SET_ALARM = 2'd2;
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RUN;
            current_hr <= 5'd0; 
            current_min <= 6'd0;
            alarm_hr <= 5'd0;
            alarm_min <= 6'd0;
        end else begin
            // State Transitions
            if (btn_time) state <= SET_TIME;
            else if (btn_wakeup) state <= SET_ALARM;
            else if (!btn_time && !btn_wakeup && (btn_plus || btn_minus)) begin
                // Hold state while editing
            end else begin
                state <= RUN;
            end

            // Time & Alarm Logic
            case (state)
                RUN: begin
                    if (tick_1hz) begin
                        if (current_min == 59) begin
                            current_min <= 0;
                            current_hr <= (current_hr == 23) ? 0 : current_hr + 1;
                        end else begin
                            current_min <= current_min + 1;
                        end
                    end
                end
                
                SET_TIME: begin
                    if (btn_plus) current_min <= (current_min == 59) ? 0 : current_min + 1;
                    if (btn_minus) current_hr <= (current_hr == 23) ? 0 : current_hr + 1;
                end
                
                SET_ALARM: begin
                    if (btn_plus) alarm_min <= (alarm_min == 59) ? 0 : alarm_min + 1;
                    if (btn_minus) alarm_hr <= (alarm_hr == 23) ? 0 : alarm_hr + 1;
                end
            endcase
        end
    end
endmodule