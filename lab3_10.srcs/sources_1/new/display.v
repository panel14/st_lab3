`timescale 1ns / 1ps

module display(
    input CLK,
    input wire [2:0] data,
    input wire [2:0] thread_number,
    input wire not_default,
    output reg [7:0] anode_number,
    output reg [6:0] digit
    );
    
    reg[19:0] divider = 0;
    reg freq;
    always @(posedge CLK) begin
        divider = divider + 1;
        if(divider == 250_000)
            divider = 0;
        if(divider == 0)
            freq = 1;
        else
            freq = 0;            
    end 
    
    reg state = 0;
    parameter THREAD_NUMBER = 0, DATA = 1;
    reg[3:0] converter_input;
        
    always @(posedge freq) begin
        case(state)
            THREAD_NUMBER: begin
                anode_number <= 8'b11101111;
                converter_input <= (not_default) ? data[2:0] : 8;
                state <= DATA;
            end
            DATA: begin
                anode_number <= 8'b11111110;
                converter_input <= (not_default) ? thread_number : 8;
                state <= THREAD_NUMBER;
            end
       endcase
       
       case(converter_input)
            0: digit <= 7'b1000000;
            1: digit <= 7'b1111001;
            2: digit <= 7'b0100100;
            3: digit <= 7'b0110000;
            4: digit <= 7'b0011001;
            5: digit <= 7'b0010010;
            6: digit <= 7'b0000010;
            7: digit <= 7'b1111000;
            8: digit <= 7'b0111111;
            default: digit <= 7'b1111111;
        endcase
    end
    
endmodule