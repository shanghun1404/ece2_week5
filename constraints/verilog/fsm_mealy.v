module fsm_mealy(
    input wire clk, rst, x,
    output reg [1:0] state,
    output wire y
);
    reg [1:0] next_state;
    always @* begin
        case (state)
            2'b00: next_state = x ? 2'b01 : 2'b00;
            2'b01: next_state = x ? 2'b11 : 2'b00;
            2'b10: next_state = x ? 2'b10 : 2'b00;
            2'b11: next_state = x ? 2'b10 : 2'b00;
            default: next_state = 2'b00;
        endcase
    end
    always @(posedge clk or posedge rst)
        if (rst) state <= 2'b00;
        else state <= next_state;
    assign y = (|state) & ~x;
endmodule
