module bcd2seven_segment (in, a, b, c, d, e, f, g);

input [4-1:0] in;
output reg a,b,c,d,e,f,g;

localparam ZERO = 4'd0;
localparam ONE = 4'd1;
localparam TWO = 4'd2;
localparam THREE = 4'd3;
localparam FOUR = 4'd4;
localparam FIVE = 4'd5;
localparam SIX = 4'd6;
localparam SEVEN = 4'd7;
localparam EIGHT = 4'd8;
localparam NINE = 4'd9;

//low == light ON, high = light OFF
always @(in)
begin
	case(in)
	ZERO:
	begin
		a = 1'b0;
		b = 1'b0;
		c = 1'b0;
		d = 1'b0;
		e = 1'b0;
		f = 1'b0;
		g = 1'b1;
	end
	ONE:
	begin
		a = 1'b1;
		b = 1'b0;
		c = 1'b0;
		d = 1'b1;
		e = 1'b1;
		f = 1'b1;
		g = 1'b1;
	end
	TWO:
	begin
		a = 1'b0;
		b = 1'b0;
		c = 1'b1;
		d = 1'b0;
		e = 1'b0;
		f = 1'b1;
		g = 1'b0;
	end
	THREE:
	begin
		a = 1'b0;
		b = 1'b0;
		c = 1'b0;
		d = 1'b0;
		e = 1'b1;
		f = 1'b1;
		g = 1'b0;
	end
	FOUR:
	begin
		a = 1'b1;
		b = 1'b0;
		c = 1'b0;
		d = 1'b1;
		e = 1'b1;
		f = 1'b0;
		g = 1'b0;
	end
	FIVE:
	begin
		a = 1'b0;
		b = 1'b1;
		c = 1'b0;
		d = 1'b0;
		e = 1'b1;
		f = 1'b0;
		g = 1'b0;
	end
	SIX:
	begin
		a = 1'b0;
		b = 1'b1;
		c = 1'b0;
		d = 1'b0;
		e = 1'b0;
		f = 1'b0;
		g = 1'b0;
	end
	SEVEN:
	begin
		a = 1'b0;
		b = 1'b0;
		c = 1'b0;
		d = 1'b1;
		e = 1'b1;
		f = 1'b1;
		g = 1'b1;
	end
	EIGHT:
	begin
		a = 1'b0;
		b = 1'b0;
		c = 1'b0;
		d = 1'b0;
		e = 1'b0;
		f = 1'b0;
		g = 1'b0;
	end
	NINE:
	begin
		a = 1'b0;
		b = 1'b0;
		c = 1'b0;
		d = 1'b0;
		e = 1'b1;
		f = 1'b0;
		g = 1'b0;
	end
	default:
	begin
		a = 1'b1;
		b = 1'b1;
		c = 1'b1;
		d = 1'b1;
		e = 1'b1;
		f = 1'b1;
		g = 1'b1;
	end
	endcase
end
endmodule 