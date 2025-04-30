`timescale 1ns/1ps
module Datapath(
    input             clk,
    input             reset,
    input             start,
    output reg        done,

    // New individual memory outputs
    output       [15:0] mem_outx0,
    output       [15:0] mem_outx1,
    output       [15:0] mem_outx2,
    output       [15:0] mem_outx3,
    output       [15:0] mem_outx4,
    output       [15:0] mem_outx5,
    output       [15:0] mem_outx6,
    output       [15:0] mem_outx7
);
    // Internal memory array (8 words of 16 bits)
    reg [15:0] mem [0:7];

    // Indices for bubble sort
    reg [2:0] i, j;
    reg [15:0] temp;
    reg        working;

    // Initialize memory with unsorted values
    initial begin
        mem[0] = 16'd50;
        mem[1] = 16'd20;
        mem[2] = 16'd30;
        mem[3] = 16'd70;
        mem[4] = 16'd10;
        mem[5] = 16'd90;
        mem[6] = 16'd40;
        mem[7] = 16'd60;
    end

    // Latch the start signal into 'working'
    always @(posedge clk or posedge reset) begin
        if (reset) 
            working <= 1'b0;
        else if (start) 
            working <= 1'b1;
    end

    // Bubble-sort logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            i    <= 3'd0;
            j    <= 3'd0;
            done <= 1'b0;
        end else if (working && !done) begin
            if (mem[j] > mem[j+1]) begin
                temp      = mem[j];
                mem[j]    = mem[j+1];
                mem[j+1]  = temp;
            end
            if (j < 6 - i) begin
                j <= j + 1;
            end else begin
                j <= 3'd0;
                if (i < 6) begin
                    i <= i + 1;
                end else begin
                    done <= 1'b1;
                end
            end
        end
    end

    // Expose each internal mem[k] as a separate output
    assign mem_outx0 = mem[0];
    assign mem_outx1 = mem[1];
    assign mem_outx2 = mem[2];
    assign mem_outx3 = mem[3];
    assign mem_outx4 = mem[4];
    assign mem_outx5 = mem[5];
    assign mem_outx6 = mem[6];
    assign mem_outx7 = mem[7];
endmodule
