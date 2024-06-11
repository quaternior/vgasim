`timescale 1ns / 1ps
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
    output reg on
    );
    parameter HSIZE = 480;
    parameter VSIZE = 272;
    reg on_mat [VSIZE-1:0][HSIZE-1:0];
    reg [8:0] row_addr;
    reg [8:0] col_addr;
    integer i, j;
    
    reg [2:0] RegPushButton;
    reg [1:0] state;
    reg [3:0] cnt;
    
    always@(posedge CLK)
    begin
        RegPushButton <= PushButton;
        if(RESET==0)
        begin
            row_addr <= 0;
            col_addr <= 0;
            state <= 2'b00;
        end
        // Right
        else if(!RegPushButton[0]&&PushButton[0])
        begin
//            col_addr = col_addr+5;
              state <= 2'b01;
              cnt <= 5;
        end
        // Up
        else if(!RegPushButton[1]&&PushButton[1])
        begin
            state <= 2'b10;
            cnt <= 5;
        end
        // Down
        else if(!RegPushButton[2]&&PushButton[2])
        begin
            state <= 2'b11;
            cnt <= 5;
        end
        else if(state != 2'b00)
        begin
            if(cnt==0) begin
                state <= 2'b00;
            end
            else begin
                case(state)
                    2'b01 : col_addr <= col_addr + 1;
                    2'b10 : row_addr <= row_addr + 1;
                    2'b11 : row_addr <= row_addr - 1;
                endcase
                cnt = cnt - 1;
            end
        end
    end
    
    always@(posedge CLK or negedge RESET) begin
        if(!RESET) begin
            for(i=0;i<VSIZE;i = i+1) begin
                for(j=0;j<HSIZE;j = j+1) begin
                    on_mat[i][j] <= 0;
                end
            end
        end
        else begin
            for(i=0;i<VSIZE;i = i+1) begin
                for(j=0;j<HSIZE;j = j+1) begin
                    on_mat[i][j] <= (i==row_addr && j==col_addr) ? 1 : on_mat[i][j];
                end
            end
        end
    end
    
    always@(posedge CLK) begin
        on <= on_mat[vcnt/HSIZE][hcnt];
    end
    
endmodule
