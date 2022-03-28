//--------------------------------------------------------------------
// Design Name : halfadder
// File Name   : halfadder.v
// Function    :  
// Designer    : Chen Xiaowei         - Nanyang technological University 
//                                    - Technische Universität München
// Email       : chen1408@e.ntu.edu.sg
// Blog        : haitianzhishang.github.io
//---------------------------------------------------------------------
module halfadder 
(
  input   a,
  input   b,
  output  sum,
  output  co
);

  assign sum = a^b;
  assign co  = a&b;

endmodule : halfadder