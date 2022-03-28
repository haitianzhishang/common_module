//--------------------------------------------------------------------
// Design Name : mux2
// File Name   : mux2.v
// Function    :  
// Designer    : Chen Xiaowei         - Nanyang technological University 
//                                    - Technische Universität München
// Email       : chen1408@e.ntu.edu.sg
// Blog        : haitianzhishang.github.io
//---------------------------------------------------------------------
module mux2 #(
  parameter  DATA_WIDTH = 32
)
(
  input    [DATA_WIDTH-1: 0]         a,    
  input    [DATA_WIDTH-1: 0]         b,
  input                              sel,
  output   [DATA_WIDTH-1: 0]         c
);

  assign c = a & sel | b & (~sel);

endmodule : mux2