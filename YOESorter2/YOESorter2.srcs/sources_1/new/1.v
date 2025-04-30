`timescale 1ns / 1ps
module testbench;
    reg        clk, rst, S;
    wire       done;

    // Instantiate the top?level design
    top UUT (
        .clk(clk),
        .rst(rst),
        .S(S),
        .done(done)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // 1) Apply reset
        rst = 1; S = 0;
        #20 rst = 0;

        // 2) Assert start
        #10 S = 1;

        // 3) Wait for done
        while (!done) @(posedge clk);

        // 4) Final write-through on next clock
        @(posedge clk);

        // 5) Deassert start
        S = 0;

        // 6) Display final sorted memory
        $display("\n=== Final sorted memory ===");
        $display("mem[0]=%0d mem[1]=%0d mem[2]=%0d mem[3]=%0d", 
                 UUT.dp.mem[0], UUT.dp.mem[1], UUT.dp.mem[2], UUT.dp.mem[3]);
        $display("mem[4]=%0d mem[5]=%0d mem[6]=%0d mem[7]=%0d\n", 
                 UUT.dp.mem[4], UUT.dp.mem[5], UUT.dp.mem[6], UUT.dp.mem[7]);

        $finish;
    end

    // Optional: monitor each cycle
    always @(posedge clk) begin
        if (!rst && (S || done)) begin
            $display("t=%0t: i=%0d j=%0d A=%0d B=%0d mem=[%0d %0d %0d %0d %0d %0d %0d %0d]",
                $time,
                UUT.dp.i, UUT.dp.j, UUT.dp.A, UUT.dp.B,
                UUT.dp.mem[0], UUT.dp.mem[1], UUT.dp.mem[2], UUT.dp.mem[3],
                UUT.dp.mem[4], UUT.dp.mem[5], UUT.dp.mem[6], UUT.dp.mem[7]
            );
        end
    end
endmodule
