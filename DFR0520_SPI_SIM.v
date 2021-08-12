`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2021 07:28:51 PM
// Design Name: 
// Module Name: DFR0520_SPI_SIM
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


module DFR0520_SPI_SIM;
reg [1:0] cmd, sel;
reg [7:0] data;
reg clk_in, EN;

wire CS, SCK, MOSI;

DFR0520_SPI CUT (
    .cmd(cmd),
    .sel(sel),
    .data(data),
    .clk_in(clk_in),
    .EN(EN)
    );
    
always
    #20 clk_in = ~clk_in;

initial begin
    cmd = 2'b01;
    sel = 2'b01;
    clk_in = 0;
    EN = 0;
    data = 8'b10101010;
    
    #100 EN = 1;
    #40 EN = 0;
    
    #200 data = 8'b11110001;
    #600 EN = 1;
    #40 EN = 0;
end

endmodule
