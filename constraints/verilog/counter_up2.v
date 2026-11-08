module counter_up2(
    input wire clk, rst, en,
    output reg [1:0] count
);
    always @(posedge clk or posedge rst)
        if (rst) count <= 2'd0;
        else if (en) count <= count + 2'd1;
endmodule
