//--------------------------------------------------------------------
// Design Name : csa
// File Name   : csa.v
// Function    : carry select adder
// Designer    : Chen Xiaowei         - Nanyang technological University 
//                                    - Technische Universität München
// Email       : chen1408@e.ntu.edu.sg
// Blog        : haitianzhishang.github.io
//---------------------------------------------------------------------
module csa #(
  parameter DATA_WIDTH = 32,
  parameter STAGE_SIZE = 4,
  parameter STAGE_NUM  = DATA_WIDTH/STAGE_SIZE
)
(
  input    [DATA_WIDTH-1 : 0] a,
  input    [DATA_WIDTH-1 : 0] b,
  input                       ci,
  output   [DATA_WIDTH-1 : 0] sum,
  output                      co
);

integer i;

reg [STAGE_NUM: 0]      ci_stage;

wire [STAGE_SIZE-1: 0]  sum_0 [STAGE_NUM];
wire [STAGE_SIZE-1: 0]  sum_1 [STAGE_NUM];
wire [STAGE_NUM-1 : 0]  co_0;
wire [STAGE_NUM-1 : 0]  co_1;

assign ci_stage[0]  = ci;
assign co           = ci_stage[STAGE_NUM];


genvar j;
generate
  for(j=0;j<STAGE_NUM;j=j+1)
  begin
    fulladder #(
               .DATA_WIDTH(STAGE_SIZE)
    )carry0_inst(
                  .a    (a[(j+1)*STAGE_SIZE-1:j*STAGE_SIZE]),
                  .b    (b[(j+1)*STAGE_SIZE-1:j*STAGE_SIZE]),
                  .ci   (1'b0),
                  .sum  (sum_0[j]),
                  .co   (co_0[j])
                );

    fulladder #(
                .DATA_WIDTH(STAGE_SIZE)
    )carry1_inst(
                  .a    (a[(j+1)*STAGE_SIZE-1:j*STAGE_SIZE]),
                  .b    (b[(j+1)*STAGE_SIZE-1:j*STAGE_SIZE]),
                  .ci   (1'b1),
                  .sum  (sum_1[j]),
                  .co   (co_1[j])
                );

    mux2 #(
          .DATA_WIDTH(STAGE_SIZE)
      )sum_mux2_inst(
                  .a  (sum_1[j]),
                  .b  (sum_0[j]),
                  .sel(ci_stage[j]),
                  .c  (sum[(j+1)*STAGE_SIZE-1:j*STAGE_SIZE])
                );
    mux2 #(
          .DATA_WIDTH(1)
      )car_mux2_inst(
                  .a  (co_1[j]),
                  .b  (co_0[j]),
                  .sel(ci_stage[j]),
                  .c  (ci_stage[j+1])
                );
  end
endgenerate

endmodule : csa