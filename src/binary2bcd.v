module binary2bcd (binary_dist, d0, d1, d2, d3, clk, n_rst);
input [12-1:0] binary_dist;
input clk, n_rst;
output reg [4-1:0] d0, d1, d2, d3;

reg [12-1:0] shift_reg;
reg [16-1:0] output_reg;

reg [4-1:0] current_state, next_state;

parameter S0 = 4'b0000;  //sample input to
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;
parameter S6 = 4'b0110;
parameter S7 = 4'b0111;
parameter S8 = 4'b1000;
parameter S9 = 4'b1001;
parameter S10 = 4'b1010;
parameter S11 = 4'b1011;
parameter S12 = 4'b1100;
parameter S13 = 4'b1101;

//update status - sample input - update output - rst
always @ (posedge clk or negedge n_rst)
begin
	//async rst
	if (!n_rst)
	begin
		d0 <= 4'b0;
		d1 <= 4'b0;
		d2 <= 4'b0;
		d3 <= 4'b0;
		shift_reg <= 12'b0;
		current_state <= S0;
	end
	
	else
	begin
		//sample input
		if (current_state == S0)
		begin
			shift_reg <= binary_dist;
		end
	
		//update output at the end of the cycle
		else if (current_state == S13)       //XXXX
		begin
			d0 <= output_reg[4-1:0];
			d1 <= output_reg[8-1:4];
			d2 <= output_reg[12-1:8];
			d3 <= output_reg[16-1:12];
		end
	
		else
		begin
			shift_reg <= shift_reg;
			d0 <= d0;
			d1 <= d1;
			d2 <= d2;
			d3 <= d3;
		end
		
		//update current status
		current_state <= next_state;
	end
end

//update next state and perform the algorithm
always @ (current_state)
begin
	case (current_state)
	S0:	begin
				output_reg = 16'b0;
				next_state = S1;
			end
	//Algorithm: shift left shift_reg into output_reg, if any 4bit digit of output_reg is >= 5, sum 3 before shifting
	S1:	begin
				output_reg[0] = shift_reg[12-1];
				next_state = S2;
			end
	S2:	begin 
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-2];
				next_state = S3;
			end
	//S3 is the first critical state for the first digit (>= 5)
	S3:	begin
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-3];
				next_state = S4;
			end
	S4:	begin 
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-4];
				next_state = S5;
			end
	S5:	begin 
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-5];
				next_state = S6;
			end
	S6:	begin
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-6];
				next_state = S7;
			end
	//S7 is the first critical state for the second digit (>= 5)
	S7:	begin
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-7];
				next_state = S8;
			end
	S8:	begin
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-8];
				next_state = S9;
			end
	S9:	begin
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-9];
				next_state = S10;
			end
	S10:	begin
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-10];
				next_state = S11;
			end
	S11:	begin
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-11];
				next_state = S12;
			end
	S12:	begin
				output_reg = output_reg << 1;
				output_reg[0] = shift_reg[12-12];
				next_state = S13;
			end
	S13:  begin
			next_state = S0;
			end
	endcase;
	
	if (output_reg[4-1:0] > 4'd4)
	begin
		output_reg = output_reg + 16'b0000000000000011;
	end
	if (output_reg[8-1:4] > 4'd4)
	begin
		output_reg = output_reg + 16'b0000000000110000;
	end
	if (output_reg[12-1:8] > 4'd4)
	begin
		output_reg = output_reg + 16'b0000001100000000;
	end
end

endmodule 