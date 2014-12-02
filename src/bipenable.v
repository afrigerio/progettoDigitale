module bipenable (binary_dst, clk, n_rst, bip_en, motor_en, duty_cycle);
input clk, n_rst;
input [12-1:0] binary_dst;
output reg bip_en, motor_en;
output reg [8-1:0] duty_cycle;

//parameters for the binary_dst ranges
localparam SEVEN_CENT = 12'd70;
localparam EIGHT_POINT_FIVE_CENT = 12'd85;
localparam TEN_CENT = 12'd100;
localparam TWELVE_CENT = 12'd120;
localparam FIFTEEN_CENT = 12'd150;
localparam TWENTY_CENT = 12'd200;
localparam TWENTYFIVE_CENT = 12'd250;
localparam THIRTY_CENT = 12'd300;
localparam FOURTY_CENT = 12'd400;
localparam FIFTY_CENT = 12'd500;
localparam SEVENTY_CENT = 12'd700;

//parameters for the counter_max reg in order to set the correct frequency
localparam ONE_HZ = 26'd50000000;
localparam TWO_HZ = 26'd25000000;
localparam THREE_HZ = 26'd16666666;
localparam FOUR_HZ = 26'd12500000;
localparam FIVE_HZ = 26'd10000000;
localparam SIX_HZ = 26'd8333334;
localparam SEVEN_HZ = 26'd7142858;
localparam EIGHT_HZ = 26'd6250000; 
localparam NINE_HZ = 26'd5555556;
localparam TEN_HZ = 26'd5000000;
localparam ELEVEN_HZ = 26'd4545454;


reg [26-1:0] counter, counter_max;
reg status;
reg sound_enable;

localparam S0 = 1'b0;
localparam S1 = 1'b1;
localparam duty_max = 8'd85;


//combinatory block to calculate the counter_max value and the sound_enable
always @ (binary_dst)
begin
	motor_en = 1'b1;
	sound_enable = 1'b1;
	duty_cycle = duty_max-8'd20; //default value
	if (binary_dst > SEVENTY_CENT)
	begin
			counter_max = 26'b0;
			sound_enable = 1'b0;
	end
	else if (binary_dst <= SEVENTY_CENT && binary_dst > FIFTY_CENT)
	begin
		counter_max = ONE_HZ;
		duty_cycle = duty_max-8'd18;
	end
	else if (binary_dst <= FIFTY_CENT && binary_dst > FOURTY_CENT)
	begin
		counter_max = TWO_HZ;
		duty_cycle = duty_max-8'd16;
	end
	else if (binary_dst <= FOURTY_CENT && binary_dst > THIRTY_CENT)
	begin
		counter_max = THREE_HZ;
		duty_cycle = duty_max-8'd14;
	end
	else if (binary_dst <= THIRTY_CENT && binary_dst > TWENTYFIVE_CENT)
	begin
		counter_max = FOUR_HZ;
		duty_cycle = duty_max-8'd12;
	end
	else if (binary_dst <= TWENTYFIVE_CENT && binary_dst > TWENTY_CENT)
	begin
		counter_max = FIVE_HZ;
		duty_cycle = duty_max-8'd10;
	end
	else if (binary_dst <= TWENTY_CENT && binary_dst > FIFTEEN_CENT)
	begin
		counter_max = SIX_HZ;
		duty_cycle = duty_max-8'd8;
	end
	else if (binary_dst <= FIFTEEN_CENT && binary_dst > TWELVE_CENT)
	begin
		counter_max = SEVEN_HZ;
		duty_cycle = duty_max-8'd6;
	end
	else if (binary_dst <= TWELVE_CENT && binary_dst > TEN_CENT)
	begin
		counter_max = EIGHT_HZ;
		duty_cycle = duty_max-8'd4;
	end
	else if (binary_dst <= TEN_CENT && binary_dst > EIGHT_POINT_FIVE_CENT)
	begin
		counter_max = NINE_HZ;
		duty_cycle = duty_max-8'd2;
	end
	else if (binary_dst <= EIGHT_POINT_FIVE_CENT && binary_dst > SEVEN_CENT)
	begin
		counter_max = TEN_HZ;
		duty_cycle = duty_max;
	end
	else if (binary_dst <= SEVEN_CENT)
	begin
		counter_max = ELEVEN_HZ;
		motor_en = 1'b0;
	end
	else
		counter_max = 26'b0;
		
end

//synchronous block to generate bip_en
always @ (posedge clk or negedge n_rst)
begin
	if(!n_rst)
	begin
		counter <= 26'b0;
		bip_en <= 1'b0;
		status <= S0;
	end
	else
	begin
		if(sound_enable)
		begin
			counter <= counter + 26'b1;
			case (status)
			S0:
			begin
				if(counter >= counter_max / 2)
				begin
					status <= S1;
					bip_en <= 1'b1;
				end
				else
				begin
					status <= S0;
					bip_en <= 1'b0;
				end	
			end
			S1:
			begin
				if(counter >= counter_max)
				begin
					status <= S0;
					bip_en <= 1'b0;
					counter <= 26'b0;
				end
				else
				begin
					status <= S1;
					bip_en <= 1'b1;
				end	
			end
			default:
			begin
				status <= S0;
				bip_en <= 1'b0;
				counter <= 26'b0;
			end	
			endcase
		end
		else
		begin
			status <= S0;
			bip_en <= 1'b0;
			counter <= 26'b0;
		end
	end
end
endmodule 