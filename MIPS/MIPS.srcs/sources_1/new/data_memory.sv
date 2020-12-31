/*--------------------------------------------------------------------------------
Author: Waseem Orphali 
Create Date: 12/28/2020
Module Name: Data Memory
Project Name: MIPS
Target Devices: ARTY Z20
Description: 
The data memory has a width of 32 bits and depth of 128.
Following the MIPS convention and for future plans, it can only be addressed
using word aligned addressing 

--------------------------------------------------------------------------------*/

module data_memory#(
    
    parameter   width   =   32,
    parameter   depth   =   128
    )
    
    (
    input   logic   [31:0]      i_address,
    input   logic   [width-1:0] i_data,
    input   logic               i_wen,
    output  logic   [width-1:0] o_data
    );
    
    logic   [width-1:0] mem [depth] = '{default : 0};
    logic   [width-1:0] address;
    
    assign address = {2'b00,i_address[31:2]};       // because i_address is word aligned (i_address[1:0] = 00), but array index is not
    
    always_latch
    begin
        if (i_address[1:0] == 2'b00)
        begin
            if (i_wen)
                mem[address] = i_data;
            o_data = mem[address];
        end
    end
    
endmodule