/*--------------------------------------------------------------------------------
Author: Waseem Orphali 
Create Date: 12/28/2020
Module Name: Pipeline Register
Project Name: MIPS
Target Devices: ARTY Z20
Description:
The clocked pipeline register stores 5 32-bit words and 5 control bits.
i_reset = 1 to synchronously reset all bits to zeros.

--------------------------------------------------------------------------------*/

module pipeline_register#(
    parameter   width           = 32,
    parameter   num_of_words    = 5,
    parameter   num_of_bits     = 5
    )
    
    (
    input   logic                               i_clk,
    input   logic   [num_of_words-1:0][width-1:0]   i_words,
    input   logic   [num_of_bits-1:0]               i_control_bits,
    input   logic                               i_reset,
    output  logic   [num_of_words-1:0][width-1:0]   o_out_words,
    output  logic   [num_of_bits-1:0]               o_out_bits
    );
    
    logic   [num_of_words-1:0][width-1:0] words  = '{default : 0};
    logic   [num_of_bits-1:0]      control_bits  = '{default : 0};
    
    always_ff @(posedge i_clk)
    begin
        if (i_reset)
        begin
            words <= '{num_of_words{0}};
            control_bits <= '{num_of_bits{0}};
        end
        else
        begin
            for (int i = 0; i < num_of_words; i++)
                words[i] <= i_words[i];
            for (int i = 0; i < num_of_bits; i++)
                control_bits <= i_control_bits;
        end
    end
    
    assign o_out_words = words;
    assign o_out_bits = control_bits;
    
endmodule