
module Datapath(
    input         clk,
    input         rst,
    input         EA,    // enable load of A from mem[i] or mem[j]
    input         EB,    // enable load of B from mem[i] or mem[j]
    input         WR,    // write enable into memory
    input         Li,    // load/reset i counter (and reset j)
    input         Lj,    // load j = i+1
    input         Ei,    // increment i (and set j = i+1)
    input         Ej,    // increment j
    input         Csel,  // choose address: 0 ? i, 1 ? j
    input         Bout,  // choose write data: 1 ? B, 0 ? A
    output reg [15:0] A, // data register A
    output reg [15:0] B, // data register B
    output reg [2:0]  i, // loop counter i
    output reg [2:0]  j, // loop counter j
    output        AgtB,  // flag: A > B
    output        zi,    // flag: i == 6
    output        zj,    // flag: j == 7
    // Exposed memory outputs for observation
    output [15:0] mem0,
    output [15:0] mem1,
    output [15:0] mem2,
    output [15:0] mem3,
    output [15:0] mem4,
    output [15:0] mem5,
    output [15:0] mem6,
    output [15:0] mem7
);

    // Internal 8×16 RAM
    reg [15:0] mem [0:7];

    // Initialize RAM with the given values
    initial begin
        mem[0] = 16'd90;
        mem[1] = 16'd25;
        mem[2] = 16'd60;
        mem[3] = 16'd15;
        mem[4] = 16'd30;
        mem[5] = 16'd75;
        mem[6] = 16'd45;
        mem[7] = 16'd10;
    end

    // Expose RAM words as outputs
    assign mem0 = mem[0];
    assign mem1 = mem[1];
    assign mem2 = mem[2];
    assign mem3 = mem[3];
    assign mem4 = mem[4];
    assign mem5 = mem[5];
    assign mem6 = mem[6];
    assign mem7 = mem[7];

    // Compute address and write data multiplexers
    wire [2:0] addr = (Csel ? j : i);
    wire [15:0] wdata = (Bout ? B : A);

    // Comparator flags
    assign AgtB = (A > B);
    assign zi   = (i == 3'd6);
    assign zj   = (j == 3'd7);

    // Sequential logic: counters, registers, memory read/write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset counters and registers
            i <= 3'd0;
            j <= 3'd0;
            A <= 16'd0;
            B <= 16'd0;
        end else begin
            // Counter control
            if (Li) begin
                i <= 3'd0;
                j <= 3'd0;
            end else if (Ei) begin
                i <= i + 3'd1;
                j <= i + 3'd1;
            end else if (Ej) begin
                j <= j + 3'd1;
            end

            // Load data from memory
            if (EA)
                A <= mem[addr];
            if (EB)
                B <= mem[addr];

            // Write-back to memory
            if (WR)
                mem[addr] <= wdata;
        end
    end

endmodule

