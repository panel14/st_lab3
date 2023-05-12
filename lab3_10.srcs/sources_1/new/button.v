module button
    #(parameter WAIT_CLOCKS = 50_000)
    (
        input CLK,
        input btn_i,
        output reg activated 
    );
    
    initial activated = 0;
    reg [$clog2(WAIT_CLOCKS+1)-1:0] cnt;
    
    always @(posedge CLK) begin
        if (cnt == WAIT_CLOCKS) begin
            if (btn_i) begin
                activated <= 1;
            end else begin
                activated <= 0;
            end
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
endmodule