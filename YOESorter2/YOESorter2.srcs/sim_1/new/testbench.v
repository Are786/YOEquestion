`timescale 1ns/1ps
module testbench;
    reg        clk;
    reg        reset;
    reg        start;
    wire       done;

    // Wires to capture each mem_outxN
    wire [15:0] mem_outx0;
    wire [15:0] mem_outx1;
    wire [15:0] mem_outx2;
    wire [15:0] mem_outx3;
    wire [15:0] mem_outx4;
    wire [15:0] mem_outx5;
    wire [15:0] mem_outx6;
    wire [15:0] mem_outx7;

    // Instantiate Top
    Top uut (
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

    // 10 ns clock
    initial clk = 0;
    always #1 clk = ~clk;

    integer i;

    initial begin
        // Dump everything
        $dumpfile("sorting.vcd");
        $dumpvars(0, testbench, uut);

        // Reset and initial conditions
        reset = 1;
        start = 0;
        #20;
        reset = 0;
        #10;

        // Print unsorted memory
        $display("\n--- Memory before sorting ---");
        $display(" mem[0] = %0d", mem_outx0);
        $display(" mem[1] = %0d", mem_outx1);
        $display(" mem[2] = %0d", mem_outx2);
        $display(" mem[3] = %0d", mem_outx3);
        $display(" mem[4] = %0d", mem_outx4);
        $display(" mem[5] = %0d", mem_outx5);
        $display(" mem[6] = %0d", mem_outx6);
        $display(" mem[7] = %0d", mem_outx7);

        // Pulse start to kick off sorting
        #10;
        start = 1;
        #10;
        start = 0;

        // Wait for done
        @(posedge done);
        #5;

        // Print sorted memory
        $display("\n--- Memory after sorting ---");
        $display(" mem[0] = %0d", mem_outx0);
        $display(" mem[1] = %0d", mem_outx1);
        $display(" mem[2] = %0d", mem_outx2);
        $display(" mem[3] = %0d", mem_outx3);
        $display(" mem[4] = %0d", mem_outx4);
        $display(" mem[5] = %0d", mem_outx5);
        $display(" mem[6] = %0d", mem_outx6);
        $display(" mem[7] = %0d", mem_outx7);

        $display("\nSorting done at time %0t ns\n", $time);
        $finish;
    end
endmodule
