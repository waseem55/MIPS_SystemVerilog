`timescale 1ns / 1ps
 
module top_tb();

    logic   clk                 = 1'b1;
    logic   reset               = 1'b1;
    logic   prog                = 1'b1;
    logic   [31:0]  instruction = 32'b0;
    logic exec                  = 1'b0;
    
    always
    #5 clk = !clk;
    
    top_module dut
    (
    .i_clk          (clk),
    .i_reset        (reset),
    .i_instructions (instruction),
    .i_prog         (prog),
    .i_exec         (exec)
    );
    
    initial
    begin
        @(negedge clk);
        reset = 0;
        instruction = 32'b00110100000000000000000000000001; // using ori to load 1 in reg 0
        @(negedge clk);
        instruction = 32'b00110100000000010000000000000010; // using ori to load 2 in reg 1
        @(negedge clk);
        instruction = 32'b00000000000000010001000000100000; // add reg 0 and reg 1 in reg 2
        @(negedge clk);
        prog = 0;
    end
endmodule