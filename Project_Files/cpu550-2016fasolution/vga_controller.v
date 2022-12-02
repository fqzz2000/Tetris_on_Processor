module vga_controller(iRST_n,
                      iVGA_CLK,
							 grid_data, // grid data
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 ); 
	
input iRST_n;
input iVGA_CLK;
input [1999:0] grid_data;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;

initial
begin
x_s <= 0;
y_s <= 0;
counter <= 0;
end
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));

////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)begin
     ADDR<=19'd0;
	  end
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
	
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	

	
//////
//always@(posedge VGA_CLK_n)
//begin
//	if (grid_data == 2000'h8)
//	begin
//	bgr_data <= 24'h00ffff;
//	end
//	else 
//	begin
//	bgr_data <= bgr_data_raw;
//	end
//end

// square coordination
reg [10:0] sqX;
reg [10:0] sqY;
// background coordination
reg [10:0] bgX;
reg [10:0] bgY;
reg [16:0] counter;
// button
input moveUp, moveDown, moveLeft, moveRight;
reg[9:0] scores;// input
integer SD,TD,HD

always@(posedge VGA_CLK_n) begin
	begin
		
	end
end



//////latch valid data at falling edge;
assign b_data = bgr_data_raw[23:16];
assign g_data = bgr_data_raw[15:8];
assign r_data = bgr_data_raw[7:0]; 

///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















