module program_counter
    (
    input   logic           i_clk,
    input   logic           i_reset,
    input   logic           i_exec,
    output  logic   [31:0]  o_address
    );
    
    logic   [31:0]  address = 32'h0;
    
    always_ff @(i_clk)
    begin
        if (i_reset | i_exec)
            address <= 0;
        else if (address <= 32'd504)
            address <= address + 32'd4;
    end
    
    assign o_address = address;
    
endmodule