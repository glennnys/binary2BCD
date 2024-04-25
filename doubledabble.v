`timescale 1ns / 1ps


module doubledabble #(
    parameter BITS = 32,
    localparam integer NIBBLES = $ceil((BITS-1)*$log10(2)),
    localparam integer OUTBITS = NIBBLES*4
    
)(
    input [BITS-1:0] bin,
    output [OUTBITS-1:0] bcd
    );
    
    reg [OUTBITS-1:0] data [BITS:0];
    reg [OUTBITS-1:0] intermediate [BITS-1:0];
    integer i, j;
    
    always @(bin) begin
        data[0] = 0;
        for (i = 0; i < BITS; i = i + 1) begin                                           // shift every bit in one by one
            for (j = 0; j < OUTBITS; j = j + 4) begin                                    //for every nibble...
                if ($ceil(4*i*$log10(2)) > j + 1) begin                                  //if this nibble can't have a value larger than 5, don't add the adder and comparison
                    if (data[i][j+:4] >= 5) intermediate[i][j+:4] = data[i][j+:4] + 3;	 //algorithm; add 3 to the nibble if the value is larger than 4
                    else begin intermediate[i][j+:4] = data[i][j+:4]; end                //algorithm; otherwise don't change nibble
                end
                else begin intermediate[i][j+:4] = data[i][j+:4]; end      
            end
            data[i+1] = {intermediate[i][OUTBITS-2:0],bin[(BITS-1)-i]};                  //algorithm; the shifting in of the data
        end
    end 
    
    assign bcd = data[BITS];
    
endmodule
