`timescale 1ns / 1ps

module tb_digital_clock;
    reg clk;
    reg rst_n;
    reg btn_time;
    reg btn_wakeup;
    reg btn_plus;
    reg btn_minus;
    reg btn_snooze;
    
    wire spi_cs, spi_clk, spi_data;
    wire trigger_radio, trigger_buzzer;

    // Fast simulation parameter (100 Hz instead of 50 MHz)
    top_digital_clock #( .BOARD_CLK(100) ) uut (
        .clk(clk), .rst_n(rst_n),
        .btn_time(btn_time), .btn_wakeup(btn_wakeup),
        .btn_plus(btn_plus), .btn_minus(btn_minus), .btn_snooze(btn_snooze),
        .spi_cs(spi_cs), .spi_clk(spi_clk), .spi_data(spi_data),
        .trigger_radio(trigger_radio), .trigger_buzzer(trigger_buzzer)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("clock_waves.vcd");
        $dumpvars(0, tb_digital_clock);
        
        clk = 0; rst_n = 0; 
        btn_time = 0; btn_wakeup = 0; btn_plus = 0; btn_minus = 0; btn_snooze = 0;
        #20 rst_n = 1;
        
        // --- 1. SET CURRENT TIME to 07:24 ---
        btn_time = 1; #10; // Enter SET_TIME mode
        repeat(7) begin btn_minus = 1; #10; btn_minus = 0; #10; end // Set 07 Hrs
        repeat(24) begin btn_plus = 1; #10; btn_plus = 0; #10; end  // Set 24 Mins
        btn_time = 0; #20; // Exit SET_TIME mode
        
        // --- 2. SET ALARM to 07:25 ---
        btn_wakeup = 1; #10; // Enter SET_ALARM mode
        repeat(7) begin btn_minus = 1; #10; btn_minus = 0; #10; end // Set 07 Hrs
        repeat(25) begin btn_plus = 1; #10; btn_plus = 0; #10; end  // Set 25 Mins
        btn_wakeup = 0; #20; // Exit SET_ALARM mode
        
        // --- 3. LET IT RUN TO ALARM TRIGGER ---
        // Fast forward exactly 60 seconds (60,000ns at this scaled speed) to hit 07:25
        #65000; 

        $display("Modern UI Simulation Complete. Check GTKWave for Trigger Radio output.");
        $finish;
    end
endmodule