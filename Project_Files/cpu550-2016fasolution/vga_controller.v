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
wire [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;

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

// print blocks and scores
reg[9:0] score;// input
reg [10:0] bgX;
reg [10:0] bgY;

always@(posedge VGA_CLK_n) begin
	bgX <= ADDR % 10'd640;
	bgY <= ADDR / 10'd640;
	score <= 888;
	
end
score_printer score_ind (score, bgX, bgY, bgr_data_raw, bgr_data);
//////latch valid data at falling edge;
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


module score_printer(score, bgX, bgY, bgr_data_raw, bgr_data);
	input [9:0] score;
	input [10:0] bgX, bgY;
	input [23:0] bgr_data_raw;
	reg [6:0] numH, numT, numS;
	output reg [23:0] bgr_data;
	reg[23:0] valid_score_color;
	reg[23:0] invalid_score_color;
	reg h0,h1,h2,h3,h4,h5,h6;
	reg t0,t1,t2,t3,t4,t5,t6;
	reg s0,s1,s2,s3,s4,s5,s6;
	reg [3:0] HD,SD,TD;	
	always @(*) begin 
		HD <= score / 100;
		TD <= (score / 10) % 10;
		SD <= score % 10;
		invalid_score_color <= 24'h000000;
		valid_score_color <= 24'hFFFFFF;
		h0 <= (bgX >= 490) && (bgX <= 530) && (bgY >= 205) && (bgY<=215);
		h1 <= (bgX >= 490) && (bgX <= 500) && (bgY >= 205) && (bgY<=245);
		h2 <= (bgX >= 520) && (bgX <= 530) && (bgY >= 205) && (bgY<=245);
		h3 <= (bgX >= 500) && (bgX <= 520) && (bgY >= 235) && (bgY<=245);
		h4 <= (bgX >= 490) && (bgX <= 500) && (bgY >= 235) && (bgY<=275);
		h5 <= (bgX >= 520) && (bgX <= 530) && (bgY >= 235) && (bgY<=275);
		h6 <= (bgX >= 490) && (bgX <= 530) && (bgY >= 265) && (bgY<=275);

		t0 <= (bgX >= 540) && (bgX <= 580) && (bgY >= 205) && (bgY<=215);
		t1 <= (bgX >= 540) && (bgX <= 550) && (bgY >= 205) && (bgY<=245);
		t2 <= (bgX >= 570) && (bgX <= 580) && (bgY >= 205) && (bgY<=245);
		t3 <= (bgX >= 550) && (bgX <= 570) && (bgY >= 235) && (bgY<=245);
		t4 <= (bgX >= 540) && (bgX <= 550) && (bgY >= 235) && (bgY<=275);
		t5 <= (bgX >= 570) && (bgX <= 580) && (bgY >= 235) && (bgY<=275);
		t6 <= (bgX >= 540) && (bgX <= 580) && (bgY >= 265) && (bgY<=275);

		s0 <= (bgX >= 590) && (bgX <= 630) && (bgY >= 205) && (bgY<=215);
		s1 <= (bgX >= 590) && (bgX <= 600) && (bgY >= 205) && (bgY<=245);
		s2 <= (bgX >= 620) && (bgX <= 630) && (bgY >= 205) && (bgY<=245);
		s3 <= (bgX >= 600) && (bgX <= 620) && (bgY >= 235) && (bgY<=245);
		s4 <= (bgX >= 590) && (bgX <= 600) && (bgY >= 235) && (bgY<=275);
		s5 <= (bgX >= 620) && (bgX <= 630) && (bgY >= 235) && (bgY<=275);
		s6 <= (bgX >= 590) && (bgX <= 630) && (bgY >= 265) && (bgY<=275);
		
		case (HD)
			0: begin
					numH[0] <= 1;
					numH[1] <= 1;
					numH[2] <= 1;
					numH[3] <= 0;
					numH[4] <= 1;
					numH[5] <= 1;
					numH[6] <= 1;
				end
			1: begin
					numH[0] <= 0;
					numH[1] <= 0;
					numH[2] <= 1;
					numH[3] <= 0;
					numH[4] <= 0;
					numH[5] <= 1;
					numH[6] <= 0;
				end
			2: begin
					numH[0] <= 1;
					numH[1] <= 0;
					numH[2] <= 1;
					numH[3] <= 1;
					numH[4] <= 1;
					numH[5] <= 0;
					numH[6] <= 1;
				end
			3: begin
					numH[0] <= 1;
					numH[1] <= 0;
					numH[2] <= 1;
					numH[3] <= 1;
					numH[4] <= 0;
					numH[5] <= 1;
					numH[6] <= 1;
				end
			4: begin
					numH[0] <= 0;
					numH[1] <= 1;
					numH[2] <= 1;
					numH[3] <= 1;
					numH[4] <= 0;
					numH[5] <= 1;
					numH[6] <= 0;
				end
			5: begin
					numH[0] <= 1;
					numH[1] <= 1;
					numH[2] <= 0;
					numH[3] <= 1;
					numH[4] <= 0;
					numH[5] <= 1;
					numH[6] <= 1;
				end
			6: begin
					numH[0] <= 1;
					numH[1] <= 1;
					numH[2] <= 0;
					numH[3] <= 1;
					numH[4] <= 1;
					numH[5] <= 1;
					numH[6] <= 1;
				end
			7: begin
					numH[0] <= 1;
					numH[1] <= 0;
					numH[2] <= 1;
					numH[3] <= 0;
					numH[4] <= 0;
					numH[5] <= 1;
					numH[6] <= 0;
				end
			8: begin
					numH[0] <= 1;
					numH[1] <= 1;
					numH[2] <= 1;
					numH[3] <= 1;
					numH[4] <= 1;
					numH[5] <= 1;
					numH[6] <= 1;
				end
			9: begin
					numH[0] <= 1;
					numH[1] <= 1;
					numH[2] <= 1;
					numH[3] <= 1;
					numH[4] <= 0;
					numH[5] <= 1;
					numH[6] <= 0;
				end
		endcase

		case (TD)
			0: begin
					numT[0] <= 1;
					numT[1] <= 1;
					numT[2] <= 1;
					numT[3] <= 0;
					numT[4] <= 1;
					numT[5] <= 1;
					numT[6] <= 1;
				end
			1: begin
					numT[0] <= 0;
					numT[1] <= 0;
					numT[2] <= 1;
					numT[3] <= 0;
					numT[4] <= 0;
					numT[5] <= 1;
					numT[6] <= 0;
				end
			2: begin
					numT[0] <= 1;
					numT[1] <= 0;
					numT[2] <= 1;
					numT[3] <= 1;
					numT[4] <= 1;
					numT[5] <= 0;
					numT[6] <= 1;
				end
			3: begin
					numT[0] <= 1;
					numT[1] <= 0;
					numT[2] <= 1;
					numT[3] <= 1;
					numT[4] <= 0;
					numT[5] <= 1;
					numT[6] <= 1;
				end
			4: begin
					numT[0] <= 0;
					numT[1] <= 1;
					numT[2] <= 1;
					numT[3] <= 1;
					numT[4] <= 0;
					numT[5] <= 1;
					numT[6] <= 0;
				end
			5: begin
					numT[0] <= 1;
					numT[1] <= 1;
					numT[2] <= 0;
					numT[3] <= 1;
					numT[4] <= 0;
					numT[5] <= 1;
					numT[6] <= 1;
				end
			6: begin
					numT[0] <= 1;
					numT[1] <= 1;
					numT[2] <= 0;
					numT[3] <= 1;
					numT[4] <= 1;
					numT[5] <= 1;
					numT[6] <= 1;
				end
			7: begin
					numT[0] <= 1;
					numT[1] <= 0;
					numT[2] <= 1;
					numT[3] <= 0;
					numT[4] <= 0;
					numT[5] <= 1;
					numT[6] <= 0;
				end
			8: begin
					numT[0] <= 1;
					numT[1] <= 1;
					numT[2] <= 1;
					numT[3] <= 1;
					numT[4] <= 1;
					numT[5] <= 1;
					numT[6] <= 1;
				end
			9: begin
					numT[0] <= 1;
					numT[1] <= 1;
					numT[2] <= 1;
					numT[3] <= 1;
					numT[4] <= 0;
					numT[5] <= 1;
					numT[6] <= 0;
				end
		endcase

		case (SD)
			0: begin
					numS[0] <= 1;
					numS[1] <= 1;
					numS[2] <= 1;
					numS[3] <= 0;
					numS[4] <= 1;
					numS[5] <= 1;
					numS[6] <= 1;
				end
			1: begin
					numS[0] <= 0;
					numS[1] <= 0;
					numS[2] <= 1;
					numS[3] <= 0;
					numS[4] <= 0;
					numS[5] <= 1;
					numS[6] <= 0;
				end
			2: begin
					numS[0] <= 1;
					numS[1] <= 0;
					numS[2] <= 1;
					numS[3] <= 1;
					numS[4] <= 1;
					numS[5] <= 0;
					numS[6] <= 1;
				end
			3: begin
					numS[0] <= 1;
					numS[1] <= 0;
					numS[2] <= 1;
					numS[3] <= 1;
					numS[4] <= 0;
					numS[5] <= 1;
					numS[6] <= 1;
				end
			4: begin
					numS[0] <= 0;
					numS[1] <= 1;
					numS[2] <= 1;
					numS[3] <= 1;
					numS[4] <= 0;
					numS[5] <= 1;
					numS[6] <= 0;
				end
			5: begin
					numS[0] <= 1;
					numS[1] <= 1;
					numS[2] <= 0;
					numS[3] <= 1;
					numS[4] <= 0;
					numS[5] <= 1;
					numS[6] <= 1;
				end
			6: begin
					numS[0] <= 1;
					numS[1] <= 1;
					numS[2] <= 0;
					numS[3] <= 1;
					numS[4] <= 1;
					numS[5] <= 1;
					numS[6] <= 1;
				end
			7: begin
					numS[0] <= 1;
					numS[1] <= 0;
					numS[2] <= 1;
					numS[3] <= 0;
					numS[4] <= 0;
					numS[5] <= 1;
					numS[6] <= 0;
				end
			8: begin
					numS[0] <= 1;
					numS[1] <= 1;
					numS[2] <= 1;
					numS[3] <= 1;
					numS[4] <= 1;
					numS[5] <= 1;
					numS[6] <= 1;
				end
			9: begin
					numS[0] <= 1;
					numS[1] <= 1;
					numS[2] <= 1;
					numS[3] <= 1;
					numS[4] <= 0;
					numS[5] <= 1;
					numS[6] <= 0;
				end
		endcase
		if ((h0 && numH[0]) || (h1 && numH[1]) || (h2 && numH[2]) || (h3 && numH[3]) || (h4 && numH[4]) || (h5 && numH[5]) || (h6 && numH[6]) ||
			 (t0 && numT[0]) || (t1 && numT[1]) || (t2 && numT[2]) || (t3 && numT[3]) || (t4 && numT[4]) || (t5 && numT[5]) || (t6 && numT[6]) ||
			 (s0 && numS[0]) || (s1 && numS[1]) || (s2 && numS[2]) || (s3 && numS[3]) || (s4 && numS[4]) || (s5 && numS[5]) || (s6 && numS[6])) begin
			bgr_data <= valid_score_color;
//		end else if (h0 || h1 || h2 || h3 || h4 || h5 || h6) begin
//			bgr_data <= invalid_score_color;
		end else begin
		   bgr_data <= bgr_data_raw;
		end		
	end
	
endmodule














