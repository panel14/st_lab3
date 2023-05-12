`timescale 1ns / 1ps

module arbiter(
    input CLK,
    input wire[15:0] SW,
    input BTNL,
    input BTNR,
    output wire[15:0] LED,
    output wire[7:0] AN,
    output wire[6:0] LED_OUT,
    output DP
);
    
    assign DP = 1;
    wire button_clk;
    wire RST;
    wire tran_valid_1, tran_valid_2, tran_valid_3, tran_valid_4;
    reg data_out_ready_1, data_out_ready_2, data_out_ready_3, data_out_ready_4;
    reg arbiter_ready;
    reg not_default;
    reg[2:0] chosen_sw;
    reg[2:0] thread_number;
    
    assign tran_valid_1 = SW[3];
    assign tran_valid_2 = SW[7];
    assign tran_valid_3 = SW[11];
    assign tran_valid_4 = SW[15];
    assign LED[3] = data_out_ready_1;
    assign LED[7] = data_out_ready_2;
    assign LED[11] = data_out_ready_3;
    assign LED[15] = data_out_ready_4;
    
    button but(.CLK(CLK), .btn_i(BTNL), .activated(button_clk));
    button rst_but(.CLK(CLK), .btn_i(BTNR), .activated(RST));
    display dis(.CLK(CLK), .data(chosen_sw), .thread_number(thread_number), .not_default(not_default), .anode_number(AN), .digit(LED_OUT));
    
    parameter READY = 0;
    parameter FIRST_TRAN = 1;
    parameter SECOND_TRAN = 2;
    parameter THIRD_TRAN = 3;
    parameter FOURTH_TRAN = 4;
    
    reg [2:0] current_state = READY;
    reg [2:0] next_state = READY;
   
    
    always @(posedge button_clk, posedge RST)            
        if (RST) current_state <= READY; 
        else current_state <= next_state;
    
    always @(posedge button_clk) 
        case (current_state)
            READY: begin
                if (tran_valid_1) next_state <= FIRST_TRAN;
                else if (tran_valid_2) next_state <= SECOND_TRAN;
                else if (tran_valid_3) next_state <= THIRD_TRAN;
                else if (tran_valid_4) next_state <= FOURTH_TRAN;
                else next_state <= READY;
                end
            FIRST_TRAN: begin
                if (tran_valid_2) next_state <= SECOND_TRAN;
                else if (tran_valid_3) next_state <= THIRD_TRAN;
                else if (tran_valid_4) next_state <= FOURTH_TRAN;
                else if (tran_valid_1) next_state <= FIRST_TRAN;
                else next_state <= READY;
                end
            SECOND_TRAN: begin
                if (tran_valid_3) next_state <= THIRD_TRAN;
                else if (tran_valid_4) next_state <= FOURTH_TRAN;
                else if (tran_valid_1) next_state <= FIRST_TRAN;
                else if (tran_valid_2) next_state <= SECOND_TRAN;
                else next_state <= READY;
                end  
            THIRD_TRAN: begin
                if (tran_valid_4) next_state <= FOURTH_TRAN;
                else if (tran_valid_1) next_state <= FIRST_TRAN;
                else if (tran_valid_2) next_state <= SECOND_TRAN;
                else if (tran_valid_3) next_state <= THIRD_TRAN;
                else next_state <= READY;
                end
            FOURTH_TRAN: begin
                if (tran_valid_1) next_state <= FIRST_TRAN;
                else if (tran_valid_2) next_state <= SECOND_TRAN;
                else if (tran_valid_3) next_state <= THIRD_TRAN;
                else if (tran_valid_4) next_state <= FOURTH_TRAN;
                else next_state <= READY;
                end
            default:
                next_state <= READY;
        endcase        
        
    always @(posedge button_clk)
        case (current_state)
            READY: begin
                chosen_sw <= 3'b000;
                not_default <= 0;
                thread_number <= 3'b000;
                data_out_ready_1 <= 0;
                data_out_ready_2 <= 0;
                data_out_ready_3 <= 0; 
                data_out_ready_4 <= 0;
                end
            FIRST_TRAN: begin
                if (tran_valid_1) begin
                    chosen_sw <= SW[2:0];
                    thread_number <= 3'b001;
                    not_default <= 1;
                    data_out_ready_1 <= 1;
                    data_out_ready_2 <= 0;
                    data_out_ready_3 <= 0; 
                    data_out_ready_4 <= 0;
                    end
                else begin
                    not_default <= 0;
                    data_out_ready_1 <= 0;
                    data_out_ready_2 <= 0;
                    data_out_ready_3 <= 0; 
                    data_out_ready_4 <= 0;
                end
            end
            SECOND_TRAN: begin
                if (tran_valid_2) begin
                    chosen_sw <= SW[6:4];
                    thread_number <= 3'b010;
                    not_default <= 1; 
                    data_out_ready_1 <= 0;
                    data_out_ready_2 <= 1;
                    data_out_ready_3 <= 0; 
                    data_out_ready_4 <= 0;
                    end
                else begin
                    not_default <= 0;
                    data_out_ready_1 <= 0;
                    data_out_ready_2 <= 0;
                    data_out_ready_3 <= 0; 
                    data_out_ready_4 <= 0;
                end
            end
            THIRD_TRAN: begin
                if (tran_valid_3) begin
                    chosen_sw <= SW[10:8];
                    thread_number <= 3'b011;
                    not_default <= 1;
                    data_out_ready_1 <= 0;
                    data_out_ready_2 <= 0;
                    data_out_ready_3 <= 1; 
                    data_out_ready_4 <= 0; 
                    end
                else begin
                    not_default <= 0;
                    data_out_ready_1 <= 0;
                    data_out_ready_2 <= 0;
                    data_out_ready_3 <= 0; 
                    data_out_ready_4 <= 0;
                end
            end
            FOURTH_TRAN: begin
                if (tran_valid_4) begin
                    chosen_sw <= SW[14:12];
                    thread_number <= 3'b100;
                    not_default <= 1; 
                    data_out_ready_1 <= 0;
                    data_out_ready_2 <= 0;
                    data_out_ready_3 <= 0; 
                    data_out_ready_4 <= 1;
                    end
                 else begin
                    not_default <= 0;
                    data_out_ready_1 <= 0;
                    data_out_ready_2 <= 0;
                    data_out_ready_3 <= 0; 
                    data_out_ready_4 <= 0;
                end
            end
            default: begin
                chosen_sw <= 3'b000;
                not_default <= 0;
                thread_number <= 3'b000;
                data_out_ready_1 <= 0;
                data_out_ready_2 <= 0;
                data_out_ready_3 <= 0; 
                data_out_ready_4 <= 0;
            end
        endcase
        
endmodule