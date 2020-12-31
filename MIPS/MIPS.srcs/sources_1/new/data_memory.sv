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

module data_memory(
    input   logic   [31:0]  i_address,
    input   logic   [31:0]  i_data,
    input   logic           i_write,
    output  logic   [31:0]  o_data
    );
    
    logic   [31:0]  mem [128] = '{default : 0};
    
    always_latch
    begin
        if (i_write)
            mem[i_address] = i_data;
        o_data = mem[i_address];
    end
    
endmodule