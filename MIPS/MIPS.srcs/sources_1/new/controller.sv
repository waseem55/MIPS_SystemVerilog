/*--------------------------------------------------------------------------------
Author: Waseem Orphali 
Create Date: 12/28/2020
Module Name: Controller
Project Name: MIPS
Target Devices: ARTY Z20
Description:
The controller module sends control signals to pipeline registers and other
modules depending on the opcode and funct fields of the instruction being executed.

--------------------------------------------------------------------------------*/

module controller(
    input   [5:0]   i_opcode,
    input   [5:0]   i_funct
    );
    
    