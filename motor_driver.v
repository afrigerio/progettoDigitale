module motor_driver (en, clk, n_rst, pwm_out_left, pwm_out_right, motor_en_left, motor_en_right);

input clk, n_rst, en;
output reg pwm_out_left, pwm_out_right; //frequecy = 900Hz, duty cycle = 90% -> the higher the duty cycle, the slower the motor
output motor_en_left, motor_en_right;

reg [16-1:0] counter; 
reg status;

localparam S0 = 1'b0;
localparam S1 = 1'b1;

localparam counter_max = 16'd55555; //to have a frequency of 900 Hz counter must be 55555
localparam counter_swap = 16'd50000; //to have a duty cycle of 90% counter must be 50000

assign motor_en_left = en;
assign motor_en_right = en;

always @(posedge clk or negedge n_rst)
begin
	if(!n_rst)
	begin
		pwm_out_left <= 1'b1;
		pwm_out_right <= 1'b1;
		counter <= 16'b0;
		status <= S0;
	end
	else
	begin
		counter <= counter + 16'b1;
		case(status)
			S0:
			begin
				pwm_out_left <= 1'b1;
				pwm_out_right <= 1'b1;
				if(counter == counter_swap)
				begin
					status <= S1;
					pwm_out_left <= 1'b0;
					pwm_out_right <= 1'b0;
				end
				else
					status <= S0;
			end
			S1:
			begin
				pwm_out_left <= 1'b0;
				pwm_out_right <= 1'b0;
				if(counter == counter_max)
				begin
					status <= S0;
					pwm_out_left <= 1'b1;
					pwm_out_right <= 1'b1;
					counter <= 16'b0;
				end
				else
					status <= S1;
			end
			default:
			begin
				status <= S0;
				pwm_out_left <= 1'b1;
				pwm_out_right <= 1'b1;
				counter <= 16'b0;
			end
		endcase
	end
end
endmodule 