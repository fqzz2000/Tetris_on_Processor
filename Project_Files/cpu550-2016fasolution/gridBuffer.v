module gridBuffer(clock, 		// clock of the buffer
						reset,
						address,		// address of the write
						in_data,  // data of write
						wren,			// write enable
						out_data);	// data out
input clock, wren, reset;
input [11:0] address;
input [2:0] in_data;
output reg [1999:0] out_data;

always@(posedge clock)
begin
	if (reset == 1'b1)
	begin
		out_data <= 2000'h8;
	end
	// TODO:set buffer value
end			
						
endmodule
