/*--------------------------------------------------------------------------------
Author: Waseem Orphali 
Create Date: 12/28/2020
Module Name: Top Module
Project Name: MIPS
Target Devices: ARTY Z20

--------------------------------------------------------------------------------*/

module top_module(
    input   logic           i_clk,
    input   logic           i_reset,
    input   logic   [31:0]  i_instructions,
    input   logic           i_prog,
    input   logic           i_exec
    );
    
    logic   [31:0]  inst_address;
    logic   [31:0]  if_id_in_0, if_id_out_0;
    logic   [31:0]  id_ex_in_0, id_ex_in_1, id_ex_in_2;
    logic   [31:0]  id_ex_out_0, id_ex_out_1, id_ex_out_2, id_ex_out_3;
    logic           id_ex_obit0, id_ex_obit1, id_ex_obit2, id_ex_obit3;
    logic   [31:0]  ex_mem_in_0;
    logic   [31:0]  ex_mem_out_0, ex_mem_out_1, ex_mem_out_2;
    logic           ex_mem_obit0, ex_mem_obit1;
    logic   [31:0]  mem_wb_in_0, mem_wb_out_0, mem_wb_out_1;
    logic           mem_wb_obit_0;
    logic   [31:0]  extended_imm, operand2, mem_data;
    logic           reg_file_dst, alusrc, reg_file_w, mem_w, wdata_slct;
    logic   [4:0]   reg_file_dst_data;
    logic   [5:0]   opcode_funct;
    
    program_counter pc
    (
    .i_clk                  (i_clk),
    .i_reset                (i_reset),
    .i_exec                 (i_exec),
    .o_address              (inst_address)
    );
    
    instruction_memory  inst_mem
    (
    .i_address              (inst_address),
    .i_instruction          (i_instructions),
    .i_wen                  (i_prog),
    .o_instruction          (if_id_in_0)
    );
    
    pipeline_register #(32, 1, 1) if_id
    (
    .i_clk                  (i_clk),
    .i_words                (if_id_in_0),
    .i_control_bits         (open),
    .i_reset                (i_reset),
    .o_out_words            (if_id_out_0),
    .o_out_bits             (open)
    );
    
    register_file reg_file
    (
    .i_r_reg1                (if_id_out_0[25:21]),
    .i_r_reg2                (if_id_out_0[20:16]),
    .i_w_reg                 (mem_wb_out_1[4:0]),
    .i_write                 (mem_wb_obit_0),
    .i_w_data                (mem_wb_out_0),
    .o_reg1                  (id_ex_in_0),
    .o_reg2                  (id_ex_in_1)
    );
    
    controller conrtoller
    (
    .i_opcode               (if_id_out_0[32:27]),
    .i_funct                (if_id_out_0[5:0]),
    .o_alusrc               (alusrc),
    .o_reg_file_dst         (reg_file_dst),
    .o_reg_file_w           (reg_file_w),
    .o_mem_w                (mem_w),
    .o_wdata_slct           (wdata_slct)
    );
    
    pipeline_register #(32, 4, 4) id_ex
    (
    .i_clk                  (i_clk),
    .i_words                ({id_ex_in_0, id_ex_in_1, id_ex_in_2, {16'b0,opcode_funct, shamt, reg_file_dst_data}}),
    .i_control_bits         ({alusrc, reg_file_w, mem_w, wdata_slct}),
    .i_reset                (i_reset),
    .o_out_words            ({id_ex_out_0, id_ex_out_1, id_ex_out_2, id_ex_out_3}),
    .o_out_bits             ({id_ex_obit0, id_ex_obit1, id_ex_obit2, id_ex_obit3})
    );
    
    ALU alu
    (
    .i_opcode                (id_ex_out_3[22:17]),
    .i_reg_not_imm           (id_ex_obit0),
    .i_shamt                 (id_ex_out_3[27:23]),
    .i_operand1              (id_ex_out_0),
    .i_operand2              (operand2),
    .o_output                (ex_mem_in_0)
    );
    
    pipeline_register #(32, 3, 3) ex_mem
    (
    .i_clk                  (i_clk),
    .i_words                ({ex_mem_in_0, id_ex_out_1, id_ex_out_3}),
    .i_control_bits         ({id_ex_obit1, id_ex_obit2, id_ex_obit3}),
    .i_reset                (i_reset),
    .o_out_words            ({ex_mem_out_0, ex_mem_out_1, ex_mem_out_2}),
    .o_out_bits             ({ex_mem_obit0, ex_mem_obit1, ex_mem_obit2})
    );
    
    data_memory d_mem
    (
    .i_address              (ex_mem_out_0),
    .i_data                 (ex_mem_out_1),
    .i_wen                  (ex_mem_obit1),
    .o_data                 (mem_data)
    );
    
    pipeline_register #(32, 2, 1) mem_wb
    (
    .i_clk                  (i_clk),
    .i_words                ({mem_wb_in_0, ex_mem_out_2}),
    .i_control_bits         (ex_mem_obit0),
    .i_reset                (i_reset),
    .o_out_words            ({mem_wb_out_0, mem_wb_out_1}),
    .o_out_bits             (mem_wb_obit_0)
    );
    
    // mux to send opcode or funct to ALU
    assign opcode_funct = (if_id_out_0 == 6'b000000) ? if_id_out_0[5:0] : if_id_out_0[32:27];
    
    // mux to decide operand2 of ALU
    assign operand2 = id_ex_obit0 ? id_ex_out_1 : id_ex_out_2;
    
    // mux to decide register file destination: $d or $t
    assign reg_file_dst_data = reg_file_dst ? if_id_out_0[15:11] : if_id_out_0[20:16];
    
    // mux to decide register wb data: from memory if the instruction is load or from ALU
    assign mem_wb_in_0 = ex_mem_obit2 ? mem_data : ex_mem_out_0;
    
    // sign extending immediate field:
    assign id_ex_in_2 = {{16{if_id_out_0[15]}},if_id_out_0[15:0]};
    
endmodule