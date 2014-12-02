module RS232 (binary_dist, clk, n_rst, tx);

input [12-1:0] binary_dist;
input clk, n_rst;
output reg tx;

//RS232 idle == high
//The first bit of data byte is 0 for the less significant data byte and 1 for the most significant data byte: this is necessary for synchronization with Labview

localparam S0 = 3'b00; //sampling
localparam S1 = 3'b01; //start, data_byte, parity bit, stop for the first group of data
localparam S2 = 3'b10; //idle
localparam S3 = 3'b11; //start, data_byte, parity bit, stop for the first group of data

localparam counter_max = 13'd5208; //baud rate is 9600 - real value
//localparam counter_max = 13'd5; //baud rate is 9600 - simulation value

reg [12-1:0] sample;
reg [2-1:0] status;
reg [13-1:0] counter;
integer send_cycle; 

always @(posedge clk or negedge n_rst)
begin
	if(!n_rst)
	begin
		status <= S0;
		tx <= 1'b1; //idle
		counter <= 13'b0;
		send_cycle <= 0;
		sample <= 12'b111111111111;
	end
	else
	begin
		counter <= counter + 13'b1;
		case(status)
			S0: //wait for a RS232 clock cycle and sample the input 
			begin
				if(counter == counter_max)
				begin
					status <= S1;
					sample <= binary_dist;
					counter <= 13'b0;
					send_cycle <= 0;
				end
				else
					status <= S0;
			end	
			
			S1:
			begin
				if(counter == counter_max)
				begin
					counter <= 13'b0;
					send_cycle <= send_cycle + 1;
					if(send_cycle >= 11-1) //start bit, datat byte, parity bit and stop bit have been sent
					begin
						status <= S2;
						send_cycle <= 0;
					end
					else
						status <= S1;
				end
				else
					send_cycle <= send_cycle;
		
				if(send_cycle == 0)
					tx <= 1'b0; //start bit
				else if(send_cycle >= 1 && send_cycle <= 7)
					tx <= sample[send_cycle-1]; //starting from the LSB 
				else if(send_cycle == 8)
					tx <= 1'b0; //the last bit of the less significant data byte is always zero
				else if(send_cycle == 9)
					tx <= sample[0] ^ sample[1] ^ sample[2] ^ sample[3] ^ sample[4] ^ sample[5] ^ sample[6]; //even parity bit
				else if(send_cycle == 10)
					tx <= 1'b1; //stop bit
				else //error
					tx <= 1'b1;
			end
			
			S2:
			begin
				tx <= 1'b1;
				if(counter == counter_max)
				begin
					status <= S3;
					counter <= 13'b0;
					send_cycle <= 0;
				end
				else
					status <= S2;		
			end
			
			S3:
			begin
				if(counter == counter_max)
				begin
					counter <= 13'b0;
					send_cycle <= send_cycle + 1;
					if(send_cycle >= 11-1) //start bit, data byte, parity bit and stop bit have been sent
					begin
						status <= S0;
						send_cycle <= 0;
					end
					else
						status <= S3;
				end
				else
					send_cycle <= send_cycle;
		
				if(send_cycle == 0)
					tx <= 1'b0; //start bit
				else if(send_cycle >= 1 && send_cycle <= 5)
					tx <= sample[send_cycle+7-1]; //starting from the LSB, second half of data
				else if(send_cycle >= 6 && send_cycle <= 7)
					tx <= 1'b0; //unuseful data
				else if(send_cycle == 8)
					tx <= 1'b1; //the last bit of the most significant data byte is always one
				else if(send_cycle == 9)
					tx <= sample[0+7] ^ sample[1+7] ^ sample[2+7] ^ sample[3+7] ^ sample[4+7]; //even parity bit
				else if(send_cycle == 10)
					tx <= 1'b1; //stop bit
				else //error
					tx <= 1'b1;
			end
			
			default:
			begin
				status <= S0;
				tx <= 1'b1;
				counter <= 13'b0;
				send_cycle <= 0;
			end
		endcase
	end
end
endmodule

