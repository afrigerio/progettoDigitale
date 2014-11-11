module bipbip (enable, clk, n_rst, buzzer);
input clk, n_rst, enable;
output reg buzzer;

localparam S0 = 1'b0;
localparam S1 = 1'b1;

reg status;
reg [16-1:0] counter; //count to 50000 to have 1kHz sound freq

always @ (posedge clk or negedge n_rst)
begin
	//reset
	if(!n_rst) 
	begin
		counter <= 16'b0;
		status <= S0;
		buzzer <= 1'b0;
	end
	
	else 
	begin
		if (enable) //enabled
		begin
			counter <= counter + 16'b1;
			case (status)
			S0:
			begin
				buzzer <= 1'b0;
				if (counter == 16'd25000)
				begin
					buzzer <= 1'b1;
					status <= S1;
				end
				else
					status <= S0;
			end
			S1:
			begin
				buzzer <= 1'b1;
				if (counter >= 16'd50000)
				begin
					buzzer <= 1'b0;
					status <= S0;
					counter <= 16'b0;
				end
				else
					status <= S1;
			end
			default:
			begin
				status <= S0;
				counter <= 16'b0;
				buzzer <= 1'b0;
			end
			endcase
			
		end
		//not enabled
		else 
		begin
			status <= S0;
			counter <= 16'b0;
			buzzer <= 1'b0;
		end
	end
end

endmodule 