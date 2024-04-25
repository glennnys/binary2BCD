`timescale 1ns / 1ps


module doubledabble #(
    parameter BITS = 16,
    localparam integer NIBBLES = $ceil($log10(2**(BITS-1))),
    localparam integer OUTBITS = NIBBLES*4
    
)(
    input [BITS-1:0] bin,
    output [OUTBITS-1:0] bcd
    );
    
    reg [OUTBITS-1:0] data [BITS:0];
    reg [OUTBITS-1:0] intermediate [BITS:0];
    integer i, j;
    always @(bin) begin
        data[0] = 0;
        for (i = 0; i < BITS; i = i + 1) begin
            for (j = 0; j < OUTBITS; j = j + 4) begin
                if (i > j) begin
                    if (data[i][j+:4] >= 5) intermediate[i][j+:4] = data[i][j+:4] + 3;		//If any BCD digit is >= 5, add 	
                    else begin intermediate[i][j+:4] = data[i][j+:4]; end
                end
                else begin intermediate[i][j+:4] = data[i][j+:4]; end
            end
            data[i+1] = {intermediate[i][BITS:0],bin[(BITS-1)-i]};
        end
    end 
    
    assign bcd = data[BITS];
    
endmodule
