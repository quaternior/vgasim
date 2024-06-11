//
// TFT-LCD Clock 생성
// 입력 Clock을 2분주 시킴
//

module g2m(
  input CLK,
  input RESET,
  output reg UP_CLK);
    
  always@(posedge RESET or posedge CLK)
  begin
    if(RESET == 1)
        UP_CLK = 0;
    else
        UP_CLK = ~UP_CLK;
  end
    
endmodule