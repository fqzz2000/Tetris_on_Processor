module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							up,
							down,
							left,
							right);

	
input iRST_n;
input iVGA_CLK;
input up, down, left, right;
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
reg [18:0] x_s, y_s;
reg [15:0]counter;

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
////
//always@(negedge up) y_s <= (y_s - 1 + 480) % 480;
//always@(negedge down) y_s <= (y_s + 1) % 480;
//always@(negedge left) x_s <= (x_s - 1 + 640) % 640;
//always@(negedge right) x_s <= (x_s + 1) % 640;
always@(negedge VGA_CLK_n)
begin
if (counter == 0) begin
if (left == 0) 
begin 
if (x_s > 0) x_s <= (x_s - 1);
end
if (right == 0) 
begin
if (x_s < 590) x_s <= (x_s + 1);
end
if (up == 0) 
begin
if (y_s > 0) y_s <= (y_s - 1);
end
if (down == 0)
begin
if (y_s < 430) y_s <= (y_s + 1);
end
end
counter <= (counter + 1) % (1 << 15);
end
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


//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) 
begin
if ( (ADDR % 640 - x_s <= 50)  && (ADDR % 640 - x_s >= 0) && (ADDR / 640 - y_s <= 50) && (ADDR / 640 - y_s >= 0)) begin
//if (y_s > 110 && x_s > 50) begin
bgr_data <= 24'hFFFFFF;
end else begin
bgr_data <= bgr_data_raw;
end
end
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















