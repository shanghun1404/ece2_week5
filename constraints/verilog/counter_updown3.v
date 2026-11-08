module counter_updown3(
    input wire clk, rst, en,
    output reg [2:0] count,
    output reg down
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 3'd0;
            down <= 1'b0;
        end else if (en) begin
            if (!down) begin
                count <= count + 3'd1;
                if (count == 3'd6) down <= 1'b1;
            end else begin
                count <= count - 3'd1;
                if (count == 3'd1) down <= 1'b0;
            end
        end
    end
endmodule
