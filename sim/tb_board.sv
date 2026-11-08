`timescale 1ns/1ps
module tb_board;
reg clk=0,rst=1,button=0,a=0,b=0,c=0;
always #5 clk=~clk;
wire [2:0] count,state;
wire down,y,vend;
lab5_3_updown #(3) u(clk,rst,button,count,down);
lab5_2_vending #(3,8) v(clk,rst,a,b,c,state,y,vend);
integer pulses=0,checks=0;
always @(posedge clk) if(vend) pulses=pulses+1;
task ck(input bit ok,input string msg);
begin checks++; if(!ok) $fatal(1,"FAIL %s",msg); end endtask
task wait_cycles(input integer n);
begin repeat(n) @(negedge clk); end endtask
task press(input [2:0] abc);
begin {a,b,c}=abc; wait_cycles(15); {a,b,c}=0; wait_cycles(10); end endtask
initial begin
 wait_cycles(2); rst=0;
 button=1; wait_cycles(1); button=0; wait_cycles(8);
 ck(count===0,"short bounce rejected");
 button=1; wait_cycles(20); ck(count===1,"held button exactly once");
 wait_cycles(20); ck(count===1,"long hold stable");
 button=0; wait_cycles(10); button=1; wait_cycles(12);
 ck(count===2,"release rearms"); button=0;
 press(4); ck(state===1,"A one press S50");
 press(2); ck(state===3,"B one press S150");
 press(1); ck(state===3 && pulses==0,"insufficient credit");
 press(4); ck(state===4,"full credit");
 c=1; wait_cycles(8); ck(state===0 && y===1,"vend and visible LED");
 wait_cycles(25); ck(state===0 && pulses==1 && y===0,"single vend and LED timeout");
 c=0; rst=1; #1; ck(count===0 && state===0 && y===0,"board reset");
 $display("BOARD_PASS checks=%0d",checks); $finish;
end
endmodule
