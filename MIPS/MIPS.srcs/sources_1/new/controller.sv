/*--------------------------------------------------------------------------------
Author: Waseem Orphali 
Create Date: 12/28/2020
Module Name: Controller
Project Name: MIPS
Target Devices: ARTY Z20
Description:
The controller module sends control signals to pipeline registers and other
modules depending on the opcode and funct fields of the instruction being executed.
Instruction formats are:
register format:  add $d, $s, $t    000000ss sssttttt dddddaaa aaffffff
immediate format: addi $t, $s, i    ooooooss sssttttt iiiiiiii iiiiiiii

--------------------------------------------------------------------------------*/

module controller(
    input   logic   [5:0]   i_opcode,
    output  logic           o_alusrc,           // 1 if register instruction, 0 if immediate instruction
    output  logic           o_reg_file_dst,     // 1 if the instruction destination in the reg file is $d, 0 if $t
    output  logic           o_reg_file_w,       // 1 enable write to reg file
    output  logic           o_mem_w,            // 1 enable write to data memory
    output  logic           o_wdata_slct        // 1 for data coming from data memroy ,0 for data coming from ALU
    );
    

    assign o_alusrc         = (i_opcode == 6'b000000) ? 1'b1 : 1'b0;    // second ALU operand is a register when 1, an immediate when 0
    assign o_reg_file_dst   = (i_opcode == 6'b000000) ? 1'b1 : 1'b0;    // register destination is $d for register instructions, $t for immediate
    assign o_reg_file_w     = (i_opcode != 6'b101011) ? 1'b1 : 1'b0;    // always write to reg file except for store instruction
    assign o_mem_w          = (i_opcode == 6'b101011) ? 1'b1 : 1'b0;    // only write to data memory when store instruction
    assign o_wdata_slct     = (i_opcode == 6'b100011) ? 1'b1 : 1'b0;    // 1 for load instruction, 0 otherwise
    
    
    
endmodule