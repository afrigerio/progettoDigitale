module binary2bcd (binary_input, d3, d2, d1, d0, clk, n_rst);

input clk, n_rst;
input [12-1:0] binary_input;
output reg [4-1:0] d3, d2, d1, d0;

//FSM states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

reg [2-1:0] status;

//auxiliary registers
reg [4-1:0] A,B,C,D; //ABCD is a 16 bit auxiliary number, A, B, C, D are groups of four bit representing a decimal number
reg [12-1:0] input_reg;

integer cycle;

always @(posedge clk or negedge n_rst)
begin
	if(!n_rst)
		status <= S0;
	else
	begin
		//default output status
		d0 <= d0;
		d1 <= d1;
		d2 <= d2;
		d3 <= d3;
		
		case(status)
		S0:
		begin
			//reset
			cycle <= 0;
			A <= 4'b0;
			B <= 4'b0;
			C <= 4'b0;
			D <= 4'b0;
			input_reg <= binary_input; //sample the input
			status <= S1;
		end	
		S1:
		begin
			//if the group of four bit is >= 5 sum 3 to it
			if(A >= 3'd5)
				A = A + 4'd3;
			if(B >= 3'd5)
				B = B + 4'd3;
			if(C >= 3'd5)
				C = C + 4'd3;
			if(D >= 3'd5)
				D = D + 4'd3;
			
			//shift everything one place to the left
			A = A << 1;
			A[0] = B[4-1];
			B = B << 1;
			B[0] = C[4-1];
			C = C << 1;
			C[0] = D[4-1];
			D = D << 1;
			D[0] = input_reg[12-1-cycle];
			
			//check the cycle number, if cycle == 11 the algorithm is completed
			if(cycle >= 11)
				status <= S2;
			else 
			begin
				status <= S1;
				cycle <= cycle + 1; //update the cycle number
			end	
		end
			
		S2:
		begin
			//update the output 
			d0 <= D;
			d1 <= C;
			d2 <= B;
			d3 <= A;
			status <= S0;
		end
		endcase;
	end
end

endmodule 