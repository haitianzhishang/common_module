//--------------------------------------------------------------------
// Design Name : nociadder
// File Name   : nociadder.v
// Function    : Multi bits adder without carry input
// Designer    : Chen Xiaowei         - Nanyang technological University 
//                                    - Technische Universität München
// Email       : chen1408@e.ntu.edu.sg
// Blog        : haitianzhishang.github.io
//---------------------------------------------------------------------
module nociadder #(
  parameter  DATA_WIDTH = 32
)
(  
  input    [DATA_WIDTH-1 : 0] a,
  input    [DATA_WIDTH-1 : 0] b,
  output   [DATA_WIDTH-1 : 0] sum,
  output                      co
);

  wire half_co;
  wire half_sum;
  wire [DATA_WIDTH-2:0] full_sum;

  halfadder halfadder_inst(
                            .a  (a[0]),
                            .b  (b[0]),
                            .co (half_co),
                            .sum(half_sum)
  );

  fulladder #(
              .DATA_WIDTH(DATA_WIDTH-1)
  )fulladder_inst(
                  .a  (a[DATA_WIDTH-1:1]),
                  .b  (b[DATA_WIDTH-1:1]),
                  .ci (half_co),
                  .co (co),
                  .sum(full_sum)
  );

  assign sum = {full_sum, half_sum};

endmodule : nociadder