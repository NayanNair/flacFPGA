/**
 * File Name: Compare15.v
 * Module Name: Compare15
 * Type: Verilog file
 * Description: Selects the optimum rice parameter to encode a residual block by comparing the total # of bits used to encode the residual block
 * Author: Stephan Sunny, Joshua D'Cunha
 * Last Modified: 3rd June 2020
*/

`timescale 100ps / 1ps

module Compare15(
    input wire iClock,
    input wire iEnable,
    
    input wire [31:0]  iIn0,
    input wire [31:0]  iIn1,
    input wire [31:0]  iIn2,
    input wire [31:0]  iIn3,
    input wire [31:0]  iIn4,
    input wire [31:0]  iIn5,
    input wire [31:0]  iIn6,
    input wire [31:0]  iIn7,
    input wire [31:0]  iIn8,
    input wire [31:0]  iIn9,
    input wire [31:0]  iIn10,
    input wire [31:0]  iIn11,
    input wire [31:0]  iIn12,
    input wire [31:0]  iIn13,
    input wire [31:0]  iIn14,
    output wire [3:0] oMinimum,
    output wire [31:0] oSum);

reg [3:0] index0_0;
reg [3:0] index0_1;
reg [3:0] index0_2;
reg [3:0] index0_3;
reg [3:0] index0_4;
reg [3:0] index0_5;
reg [3:0] index0_6;
reg [3:0] rindex0_7;
reg [3:0] index1_0;
reg [3:0] index1_1;
reg [3:0] index1_2;
reg [3:0] index1_3;
reg [3:0] index2_0;
reg [3:0] index2_1;
reg [3:0] index3_0;
reg [31:0] value0_0;
reg [31:0] value0_1;
reg [31:0] value0_2;
reg [31:0] value0_3;
reg [31:0] value0_4;
reg [31:0] value0_5;
reg [31:0] value0_6;
reg [31:0] rvalue0_7;
reg [31:0] value1_0;
reg [31:0] value1_1;
reg [31:0] value1_2;
reg [31:0] value1_3;
reg [31:0] value2_0;
reg [31:0] value2_1;
reg [31:0] value3_0;

/*
        -----
        | 0 | 
        -----  \ -------
        -----  / | 0_0 |
        | 1 |    ------- \
        -----             \ -------
        -----             / | 1_0 |
        | 2 |            /  ------- \
        -----  \ -------             \
        -----  / | 0_1 |              \
        | 3 |    -------               \
        -----                           \ -------
        -----                           / | 2_0 |
        | 4 |                          /  ------- \
        -----  \ -------              /            \
        -----  / | 0_2 |             /              \
        | 5 |    ------- \          /                \
        -----             \ -------/                  \
        -----             / | 1_1 |                    \
        | 6 |            /  -------                     \
        -----  \ -------                                 \
        -----  / | 0_3 |                                  \
        | 7 |    -------                                   \
        -----                                               \ =======
        -----                                               / | 3_0 |
        | 8 |                                              /  =======
        -----  \ -------                                  /
        -----  / | 0_4 |                                 /
        | 9 |    ------- \                              /
        -----             \ -------                    /
        -----             / | 1_2 |                   /
        |10 |            /  ------- \                /
        -----  \ -------             \              /
        -----  / | 0_5 |              \            /
        |11 |    -------               \          /
        -----                           \ -------/
        -----                           / | 2_1 |
        |12 |                          /  -------
        -----  \ -------              /
        -----  / | 0_6 |             /
        |13 |    ------- \ -------  /
        -----            / | 1_3 | /
        -----    -------   -------
        |14 |    | 0_7 |
        -----    -------
*/


assign oMinimum =  index3_0 ; // Variables containing the word 'index' are related to the rice parameter value
assign oSum = value3_0;       // Variables containing the word 'value' are related to the total # of bits used to encode the residual block using a rice parameter

always @(posedge iClock) begin
    if (iEnable) begin
        value0_0 <= (iIn0 < iIn1) ? iIn0 : iIn1;
        index0_0 <= (iIn0 < iIn1) ? 0 : 1;
        value0_1 <= (iIn2 < iIn3) ? iIn2 : iIn3;
        index0_1 <= (iIn2 < iIn3) ? 2 : 3;
        value0_2 <= (iIn4 < iIn5) ? iIn4 : iIn5;
        index0_2 <= (iIn4 < iIn5) ? 4 : 5;
        value0_3 <= (iIn6 < iIn7) ? iIn6 : iIn7;
        index0_3 <= (iIn6 < iIn7) ? 6 : 7;
        value0_4 <= (iIn8 < iIn9) ? iIn8 : iIn9;
        index0_4 <= (iIn8 < iIn9) ? 8 : 9;
        value0_5 <= (iIn10 < iIn11) ? iIn10 : iIn11;
        index0_5 <= (iIn10 < iIn11) ? 10 : 11;
        value0_6 <= (iIn12 < iIn13) ? iIn12 : iIn13;
        index0_6 <= (iIn12 < iIn13) ? 12 : 13;
        rvalue0_7 <= iIn14 ;
        rindex0_7 <= 14 ;
        value1_0 <= (value0_0 < value0_1) ? value0_0 : value0_1;
        index1_0 <= (value0_0 < value0_1) ? index0_0 : index0_1;
        value1_1 <= (value0_2 < value0_3) ? value0_2 : value0_3;
        index1_1 <= (value0_2 < value0_3) ? index0_2 : index0_3;
        value1_2 <= (value0_4 < value0_5) ? value0_4 : value0_5;
        index1_2 <= (value0_4 < value0_5) ? index0_4 : index0_5;
        value1_3 <= (value0_6 < rvalue0_7) ? value0_6 : rvalue0_7;
        index1_3 <= (value0_6 < rvalue0_7) ? index0_6 : rindex0_7;
        value2_0 <= (value1_0 < value1_1) ? value1_0 : value1_1;
        index2_0 <= (value1_0 < value1_1) ? index1_0 : index1_1;
        value2_1 <= (value1_2 < value1_3) ? value1_2 : value1_3;
        index2_1 <= (value1_2 < value1_3) ? index1_2 : index1_3;
        value3_0 <= (value2_0 < value2_1) ? value2_0 : value2_1;
        index3_0 <= (value2_0 < value2_1) ? index2_0 : index2_1;
    end
end

endmodule