/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2013/02/19 14:59:36
// Design Name: 
// Module Name: BRAMCtrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BRAMCtrl(
  input CLK,
  input RESET,
  input Vsync,
  input Hsync,
  // input DE,
  input BRAMCLK,
  // output [7:3] R,
  // output [7:2] G,
  // output [7:3] B,
  output reg [13:0] hcnt,
  output reg [23:0] vcnt,
  input Reverse_SW);

  //Simulating
  parameter HSIZE = 640;
  parameter VSIZE = 480;
  
  //Simulating
  reg vDE, hDE;
  //
  reg DE1d;
  always @ (posedge CLK or posedge RESET)
  begin
    if (RESET)
    begin
      hcnt <= 14'd0;
      vcnt <= 24'd0;
      vDE <= 0;
      hDE <= 0;
      // DE1d <= 1'b0;
    end
    else
    begin
      hDE1d <= hDE;
      // DE1d <= DE;
      if (Reverse_SW)
      begin
        // if (!Vsync)
        //   vcnt <= (VSIZE-1)*HSIZE;
        // else if ((!DE) && (DE1d))
        //   vcnt <= vcnt - HSIZE;
        if (!Vsync) begin
          vcnt <= (VSIZE-1)*HSIZE;
          vDE <= 1;
        end
        else if(hDE && !hDE1d) begin
          vcnt <= vcnt - HSIZE;
          vDE <= 0;
        end
      end
      else
      begin
      //   if (!Vsync)
      //     vcnt <= 18'd0;
      //   else if ((!DE) && (DE1d))
      //     vcnt <= vcnt + HSIZE;
      end
  
      if (!Hsync) begin
        hcnt <= 14'd0;
        hDE <= 1;
      end
      else begin
        hcnt <= hcnt + 14'd1;
        hDE <= 0;
      end
    end
  end
  
    // assign BRAMCLK = CLK;
    // assign BRAMADDR = vcnt + hcnt;
    // assign R = BRAMDATA[15:11];
    // assign G = BRAMDATA[10:5];
    // assign B = BRAMDATA[4:0];
  
  endmodule
