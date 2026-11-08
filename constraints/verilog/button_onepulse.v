// Active-high button; two-stage synchronizer, debounce, one-cycle pulse.
module button_onepulse #(
    parameter integer STABLE_CYCLES=500000
)(input wire clk, rst, button, output wire pulse);
    (* ASYNC_REG="TRUE" *) reg sync1, sync2;
    reg stable, delayed;
    localparam integer WIDTH = (STABLE_CYCLES<2) ? 1 : $clog2(STABLE_CYCLES);
    reg [WIDTH-1:0] ticks;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync1<=0; sync2<=0; stable<=0; delayed<=0; ticks<=0;
        end else begin
            sync1<=button; sync2<=sync1; delayed<=stable;
            if (sync2==stable) ticks<=0;
            else if (ticks==STABLE_CYCLES-1) begin
                stable<=sync2; ticks<=0;
            end else ticks<=ticks+1'b1;
        end
    end
    assign pulse=stable & ~delayed;
endmodule
