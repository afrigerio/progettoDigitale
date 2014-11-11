module RS232 (binary_dist, clk, n_rst, tx);

input [12-1:0] binary_dist;
input clk, n_rst;
output tx;

localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S7 = 3'b111;

localparam counter_max = 13'd5208; //baud rate is 9600

reg [3-1:0] status;
reg [13-1:0] counter;
integer send_cycle;

always @(posedge clk or negedge n_rst)
begin

end

endmodule

