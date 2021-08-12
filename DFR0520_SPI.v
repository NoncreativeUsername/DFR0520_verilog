`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 08/11/2021 06:20:17 PM
// Design Name: 
// Module Name: DFR0520_SPI
// Project Name: 
// Target Devices: DFR0520 100k digital potentiometer
// Tool Versions: Vivado 2020.2
// Description: Control DFR0520 duel digital 100K potentiometer through SPI interface through a PMOD connecter
//              
//              more details at: https://wiki.dfrobot.com/Dual_Digital_Pot__100K__SKU__DFR0520
// 
// Dependencies: 
// 
// Revision:0.1
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DFR0520_SPI(
    input clk_in, EN,               //clk input and enable input
    input [0:7] data,               //data byte
    input [0:1] cmd,                //2 command bits
    input [0:1] sel,                //2 channel select bits
    output CS, SCK, MOSI            //CS(chip select active low), SCK (serial clk), MOSI (master out slave in)
    );
    
reg select = 1'b1;                  //select is active low, keep high until needed
reg [3:0] CS_counter = 4'b0000;               //keeps select low for 16 clk cycles
reg [15:0] sdata = 16'b0;                   //serial data to be sent to chip, use as shift register
reg [1:0] delay;                            //shift register for timing issues


always @ (posedge clk_in) begin
    delay <= {delay[0], 1'b0};                      //delayshift register
    
    if (EN == 1'b1 && select == 1'b1) begin
        sdata <= {2'b0, cmd, 2'b0, sel, data};      //load command, select, and data bits into the serial data register
        delay <= 2'b01;                            //load delay shift register
    end
   
end

always @ (posedge clk_in) begin
    if (delay[1] == 1'b1)
        select <= 1'b0;                                 //set select low after 3 clks
end

always @ (posedge clk_in) begin
    if (select == 1'b0) begin
        if (CS_counter == 4'b1111) begin
            select <= 1'b1;                         //set select high after 16 clks
        end
        CS_counter <= CS_counter + 1;               //count up whenever select is low
    end
end

always @ (posedge clk_in) begin
    if (select == 1'b0) begin
        sdata <= {sdata[14:0], 1'b0};               //shift register into serial data output
    end
end

assign CS = select;                 //assign chip select output to select
assign MOSI = sdata[15];            //assign MOSI as sdata most significant bit
assign SCK = clk_in;                //just pass this through for now, SPI typicaly uses half the system clk but not more than 12.5 MHz

endmodule
