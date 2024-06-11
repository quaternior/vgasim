//
// TFT-LCD�� Color Test Pattern�� display�ϱ� ���� coding
//

module TFTLCDCtrl (
    // input [2:0]PushButton,
    input CLK,
    input nRESET,
    input TCLK,	// TFT-LCD Clock
    input Hsync,	// TFT-LCD HSYNC
    input Vsync,	// TFT-LCD VSYNC
    input [7:0] BRAM_R, // TFT-LCD Red signal 
    input [7:0] BRAM_G, // TFT-LCD Green signal
    input [7:0] BRAM_B, // TFT-LCD Blue signal
    output [7:0] R, // TFT-LCD Red signal 
    output [7:0] G, // TFT-LCD Green signal
    output [7:0] B, // TFT-LCD Blue signal
    input BRAMCLK
    ); //BRAM Data 16bits

    // Temporature variable for final sim
    reg [2:0] PushButton;
    reg [31:0] simcnt;
    reg [16:0] pixel_cnt;
    wire [1:0] SW;
    assign SW[0] = 0;   //0 : 5pxl, 1 : 10pxl

    always@(posedge CLK or negedge nRESET) begin
        if(!nRESET) begin
            simcnt <= 0;
            PushButton[2:0] <= 3'b111;
        end
        // else if(simcnt>=5) begin
        //     simcnt <= 0;
        //     PushButton[0] <= ~PushButton[0];
        // end
        // else begin
        //     simcnt <= simcnt + 1;
        // end
    end


    wire g2mclk;
    wire hclk;
    wire [9:0] H_COUNT;
    wire [9:0] V_COUNT;
    wire hDE;
    wire vDE;
    wire DEimage;	 
	wire RESET;
	wire Hsyncimage;	// TFT-LCD HSYNC
	wire Vsyncimage;	// TFT-LCD VSYNC
    // wire [7:3] BRAM_R;
    // wire [7:2] BRAM_G;
    // wire [7:3] BRAM_B;
    wire [23:0]vcnt;
    wire [13:0]hcnt;
    wire on;
    
    assign RESET = ~nRESET;
    assign g2mclk = TCLK;
    assign DEimage = hDE & vDE;
    
        // always @ (posedge g2mclk or posedge RESET)
        // begin
        //   if (RESET)
        //   begin
        //     Vsync <= 1'b0;
        //     Hsync <= 1'b0;
        //   end
        //   else
        //   begin
        //     Vsync <= Vsyncimage;
        //     Hsync <= Hsyncimage;
        //   end
        // end 
        
        // // TFT-LCD CLOCK ����
        // g2m a_g2m
        // (
        //     .CLK        (CLK),
        //     .UP_CLK        (g2mclk),
        //     .RESET        (RESET)
        //     );
    
        // HSYNC ����
        // horizontal b_horizontal
        // (
        //     .CLK        (g2mclk),
        //     .UP_CLKa    (hclk),
        //     .H_COUNT     (H_COUNT),
        //     .Hsync        (Hsyncimage),
        //     .hDE        (hDE),
        //     .RESET        (RESET)
        //     );
    
    
        // VSYNC ����
        // vertical c_vertical
        // (
        //     .CLK        (hclk),
        //     .V_COUNT    (V_COUNT),
        //     .Vsync		(Vsyncimage),
        //     .vDE        (vDE),
        //     .RESET        (RESET)
        //     );
            
            
    // TFT-LCD R/G/B Data (Color Bar) ����
   

    // BRAM Controller
    BRAMCtrl f_BRAMCtrl
    (
        .CLK(g2mclk),
        .RESET(RESET),
        .Vsync(Vsync),
        .Hsync(Hsync),
        // .DE(DEimage),
        .BRAMCLK(BRAMCLK),
        // .BRAMADDR(BRAMADDR),
        // .BRAMDATA(BRAMDATA),
        // .R(BRAM_R),
        // .G(BRAM_G),
        // .B(BRAM_B),
        .Reverse_SW(1'b1),
        .vcnt(vcnt),
        .hcnt(hcnt)
    );
    
    tracker f_tracker
    (
        .PushButton(PushButton),
        .CLK(g2mclk),
        .RESET(RESET),
        .vcnt(vcnt),
        .hcnt(hcnt),
        .on(on),
        .SW(SW[0]),
        .pixel_cnt(pixel_cnt)
    );

    assign R = on ? BRAM_R : 8'b0; // black  value
    assign G = on ? BRAM_G : 8'b0;
    assign B = on ? BRAM_B : 8'b0;
endmodule
