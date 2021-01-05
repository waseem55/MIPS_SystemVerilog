/*--------------------------------------------------------------------------------
Author: Waseem Orphali 
Create Date: 12/28/2020
Module Name: Register File
Project Name: MIPS
Target Devices: ARTY Z20
Description: 
The register file holds 32 general purpose registers R0 - R31 that can be read
and written to using the addresses of the registers 00000 - 11111.
Register R0 holds 32'h00000000 and cannot be written to.

--------------------------------------------------------------------------------*/
module register_file #(

    parameter   width       =   32,
    parameter   num_of_regs =   32,     // number of registers
    parameter   add_bits    =   5       // number of bits to address registers = log2(num_of_regs)
    )

    (
    input   logic   [add_bits-1:0]  i_r_reg1,
    input   logic   [add_bits-1:0]  i_r_reg2,
    input   logic   [add_bits-1:0]  i_w_reg,
    input   logic                   i_write,
    input   logic   [width-1:0]     i_w_data,
    output  logic   [width-1:0]     o_reg1,
    output  logic   [width-1:0]     o_reg2
    );
    
    logic   [width-1:0]  register [num_of_regs] = '{default : 0};
    
    always_latch
    begin
        register[0] = 0;             // R0 = 0 and cannot be modified
        if (i_write && (i_w_reg != 0))
            register [i_w_reg] = i_w_data;
        o_reg1 = register [i_r_reg1];
        o_reg2 = register [i_r_reg2];
    end
    
endmodule