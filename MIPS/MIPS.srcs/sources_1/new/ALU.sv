/*--------------------------------------------------------------------------------
Author: Waseem Orphali 
Create Date: 12/28/2020
Module Name: ALU
Project Name: MIPS
Target Devices: ARTY Z20
Description: 
The ALU module performs arithmetic and logic operations in the MIPS processor.
The operation performed is decided using the opcode and funct fields in the 
instructions as specified in the Instructions_Encoding.xlsx file
The immedaite value i in the instruction is 16 bits, it is sign extended to 32 bits
before getting into the ALU as i_operand2

--------------------------------------------------------------------------------*/
module ALU(
    input   logic    [5:0]   i_opcode,          // opcode
    input   logic            i_reg_not_imm,     // indicates if the instruction is a register or immediate instruction
    input   logic    [4:0]   i_shamt,           // shift amount
    input   logic    [31:0]  i_operand1,        // $s
    input   logic    [31:0]  i_operand2,        // $t or i depending on the instruction
    output  logic    [31:0]  o_output
    );
    
    always_comb
    begin
        if (i_reg_not_imm == 1'b1)
            case (i_opcode)
                6'b100000:      // add
                    o_output = i_operand1 + i_operand2;
                6'b100001:      // addu
                    o_output = i_operand1 + i_operand2;
                6'b100100:      // and
                    o_output = i_operand1 & i_operand2;
                6'b100111:      // nor
                    o_output = ~(i_operand1 | i_operand2);
                6'b100101:      // or
                    o_output = i_operand1 | i_operand2;
                6'b000000:      // sll
                    o_output = i_operand2 << i_shamt;
                6'b000100:      // sllv
                    o_output = i_operand2 << i_operand1;
                6'b000011:      // sra
                    o_output = signed'(i_operand2) >>> i_shamt;
                6'b000111:      // srav
                    o_output = signed'(i_operand2) >>> i_operand1;
                6'b000010:      // srl
                    o_output = i_operand2 >> i_shamt;
                6'b000110:      // srlv
                    o_output = i_operand2 >> i_operand1;
                6'b100010:      // sub
                    o_output = i_operand1 - i_operand2;
                6'b100011:      // subu
                    o_output = i_operand1 - i_operand2;
                6'b100110:      // xor
                    o_output = i_operand1 ^ i_operand2;
                6'b101010:      // slt
                    o_output = (signed'(i_operand1) < signed'(i_operand2)) ? 32'h00000001 : 0;
                6'b101001:      // sltu
                    o_output = (i_operand1 < i_operand2) ? 32'h00000001 : 0;
                default:
                    o_output = 0;
            endcase
        else
            case (i_opcode)
                6'b001000:      // addi (sign extended i)
                    o_output = i_operand1 + i_operand2;
                6'b001001:      // addiu (sign extended i)
                    o_output = i_operand1 + i_operand2;
                6'b001100:      // andi (zero extended i)
                    o_output = i_operand1 & i_operand2 & 32'h0000ffff;
                6'b001101:      // ori (zero extended i)
                    o_output = i_operand1 | (i_operand2 & 32'h0000ffff);
                6'b001110:      // xori (zero extended i)
                    o_output = i_operand1 ^ (i_operand2 & 32'h0000ffff);
                6'b011001:      // lui (load upper 16 bits)
                    o_output = {i_operand2, 16'h0000};
                6'b001010:      // slti (sign extended i)
                    o_output = (signed'(i_operand1) < signed'(i_operand2)) ? 32'h00000001 : 0;
                6'b001001:      // sltiu (sign extended i)
                    o_output = (i_operand1 < i_operand2) ? 32'h00000001 : 0;
                6'b100011:      // lw (sign extended i)
                    o_output = i_operand1 + i_operand2;
                6'b101011:      // sw (sign extended i)
                    o_output = i_operand1 + i_operand2;
                default:
                    o_output = 0;
            endcase
    end    
       
endmodule
