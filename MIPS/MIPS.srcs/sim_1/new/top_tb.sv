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
        @(negedge clk);
        reset = 0;
        instruction = 32'h34010001; // using ori to load 1 in reg 1 32'b00110100 00000001 00000000 00000001
        @(negedge clk);
        instruction = 32'h34020002; // using ori to load 2 in reg 2 32'b00110100 00000010 00000000 00000010
        @(negedge clk);
        instruction = 32'h34030003; // using ori to load 3 in reg 3 32'b00110100 00000011 00000000 00000011
        @(negedge clk);
        instruction = 32'h34040004; // using ori to load 4 in reg 4 32'b00110100 00000100 00000000 00000100
        @(negedge clk);
        instruction = 32'h34050005; // using ori to load 5 in reg 5 32'b00110100 00000101 00000000 00000100
        @(negedge clk);
        instruction = 32'h00430820; // add reg 2 and reg 3 in reg 1 32'b00000000 01000011 00001000 00100000
        @(negedge clk);
        prog = 0;
    end
endmodule