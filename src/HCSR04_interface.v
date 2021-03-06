module HCSR04_interface (clk, n_rst, echo_in, trigger_out, binary_distance);

input clk, n_rst, echo_in;
output reg trigger_out;
output[12-1:0] binary_distance;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

localparam counter_max = 22'b1111111111111111111111; //real value -> almost 100ms
//localparam counter_max = 22'd30; //simulation value

localparam pulse_width = 22'd500; //real value -> 10us
//localparam pulse_width = 22'd4; //simulation value

reg [22-1:0] start_reg, end_reg, counter; 
reg [2-1:0] status;
reg [32-1:0] binary_temporary; //32 bits because its the result of a 10bits * 22bits multiplication

assign binary_distance = binary_temporary[30-1:18]; //12 bits, shifted by 18 bits

always @(posedge clk or negedge n_rst)
begin
	if(!n_rst)
	begin
	//RESET
		status <= S0;
		counter <= 22'd0;
		start_reg <= 22'd0;
		end_reg <= 22'd0;
		binary_temporary <= 32'd0;
		trigger_out <= 1'b0;
	end
	else
	begin
	//NORMAL
	trigger_out <= 1'b0;
	binary_temporary <= binary_temporary;
	counter <= counter + 22'd1;
	case(status)
		S0: //trigger_out high for 10 us, it wakes up the sensor (counter == 500 clock cycle)
		begin
			trigger_out <= 1'b1;
			if(counter == pulse_width)
			begin
				status <= S1;
				trigger_out <= 1'b0;
			end
			else
				status <= S0;
		end
		
		S1: //wait for echo_in high
		begin
			if(counter == counter_max) //come back to S0, no echo_in received
			begin
				counter <= 22'd0;
				status <= S0;
			end
			else
			begin
				if(echo_in) //start counting for the distance range measurement
				begin
					status <= S2;
					start_reg <= counter;
				end
				else 
					status <= S1;
			end
		end
		
		S2: //count the time for the distance range measurement (range = time * 340 / 2)
		begin
			if(counter == counter_max) //come back to S0, no echo_in received
			begin
				counter <= 22'd0;
				status <= S0;
			end
			else
			begin
				if(!echo_in) //stop counting for the distance range measurement
				begin
					status <= S3;
					end_reg <= counter;
				end
				else 
					status <= S2;
			end	
		end
		
		S3:
		begin
			if(counter == counter_max) //come back to S0
			begin
				counter <= 22'd0;
				status <= S0;
				binary_temporary <= (end_reg - start_reg) * 10'b1101111011; //result is on 32 bits
			end
			else
				status <= S3;
		end
		default:
		begin
			counter <= 22'd0;
			status <= S0;
		end
		endcase
	end
end
endmodule
