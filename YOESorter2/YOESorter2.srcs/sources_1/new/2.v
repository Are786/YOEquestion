`timescale 1ns/1ps
module Top(
    input             clk,
    input             reset,
    input             start,
    output            done,

    // Pass-through of the eight memory outputs
    output      [15:0] mem_outx0,
    output      [15:0] mem_outx1,
    output      [15:0] mem_outx2,
    output      [15:0] mem_outx3,
    output      [15:0] mem_outx4,
    output      [15:0] mem_outx5,
    output      [15:0] mem_outx6,
    output      [15:0] mem_outx7
);
    Datapath dp (
        .clk      (clk),
        .reset    (reset),
        .start    (start),
        .done     (done),

        .mem_outx0(mem_outx0),
        .mem_outx1(mem_outx1),
        .mem_outx2(mem_outx2),
        .mem_outx3(mem_outx3),
        .mem_outx4(mem_outx4),
        .mem_outx5(mem_outx5),
        .mem_outx6(mem_outx6),
        .mem_outx7(mem_outx7)
    );
endmodule
