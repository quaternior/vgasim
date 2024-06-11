//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 10:38:32
// Design Name: 
// Module Name: tracker
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


module tracker(
    input [2:0]PushButton,
    input CLK,
    input RESET,
    input [23:0] vcnt,
    input [13:0] hcnt,
    input SW,
    output reg on,
    output [16:0] pixel_cnt
    );
    parameter HSIZE = 96;
    parameter VSIZE = 54;
    reg on_5mat [VSIZE-1:0][HSIZE-1:0];
    reg on_10mat [VSIZE/2-1:0][HSIZE/2-1:0];
    reg [8:0] row_addr;
    reg [8:0] col_addr;
    integer i, j;
    reg [16:0] pixel_5cnt;
    reg [16:0] pixel_10cnt;
    
    assign pixel_cnt = SW ? pixel_10cnt : pixel_5cnt;
    
    reg [2:0] RegPushButton;
    reg [3:0] cnt;
    reg initon;
    
    always@(posedge CLK or posedge RESET)
    begin
        RegPushButton <= PushButton;
        if(RESET)
        begin
            row_addr <= 0;
            col_addr <= 0;
            initon <= 1;
        end
        // Right
        else if(!RegPushButton[0]&&PushButton[0])
        begin
            if(initon==0) begin
                initon <= 1;
            end
            else begin
                col_addr <= col_addr + 1;
            end
        end
        // Up
        else if(!RegPushButton[1]&&PushButton[1])
        begin
            if(initon==0) begin
                initon <= 1;
            end
            else begin
                row_addr <= row_addr + 1;
            end
        end
        // Down
        else if(!RegPushButton[2]&&PushButton[2])
        begin
            if(initon==0) begin
                initon <= 1;
            end
            else begin
                row_addr <= row_addr - 1;
            end
        end
        else
        begin
           row_addr <= row_addr;
           col_addr <= col_addr;
       end
    end
    
    always@(posedge CLK or posedge RESET) begin
        if(RESET || !initon) begin
            for(i=0;i<VSIZE;i = i+1) begin
                for(j=0;j<HSIZE;j = j+1) begin
                    on_5mat[i][j] = 0;
                end
            end
        end
        else begin
            for(i=0;i<VSIZE;i = i+1) begin
                for(j=0;j<HSIZE;j = j+1) begin
                    on_5mat[i][j] = (i==row_addr && j==col_addr) ? 1 : on_5mat[i][j];
                end
            end
        end
    end
    
    always@(posedge CLK or posedge RESET) begin
        if(RESET || !initon) begin
            for(i=0;i<VSIZE/2;i = i+1) begin
                for(j=0;j<HSIZE/2;j = j+1) begin
                    on_10mat[i][j] = 0;
                end
            end
        end
        else begin
            for(i=0;i<VSIZE/2;i = i+1) begin
                for(j=0;j<HSIZE/2;j = j+1) begin
                    on_10mat[i][j] = (i==row_addr && j==col_addr) ? 1 : on_10mat[i][j];
                end
            end
        end
    end
    always@(posedge CLK) begin
        on <= (SW) ? on_10mat[(VSIZE/2)-1-((vcnt/50)/HSIZE)][(HSIZE/2)-1-(hcnt/10)] : on_5mat[VSIZE-1-(vcnt/25)/HSIZE][HSIZE-1-hcnt/5];
    end
    
    always@(posedge CLK or negedge RESET) begin
        if(!RESET) begin
            pixel_5cnt = 0;
        end
        else begin
            pixel_5cnt = 0;
            for(i=0;i<VSIZE;i = i+1) begin
                for(j=0;j<HSIZE;j = j+1) begin
                     pixel_5cnt = (on_5mat[i][j]) ? pixel_5cnt + 25 : pixel_5cnt;
                end
            end
        end
    end
    
    always@(posedge CLK or negedge RESET) begin
        if(!RESET) begin
            pixel_10cnt = 0;
        end
        else begin
            pixel_10cnt = 0;
            for(i=0;i<VSIZE/2;i = i+1) begin
                for(j=0;j<HSIZE/2;j = j+1) begin
                     pixel_10cnt = (on_10mat[i][j]) ? pixel_10cnt + 100 : pixel_10cnt;
                end
            end
        end
    end
    
endmodule
