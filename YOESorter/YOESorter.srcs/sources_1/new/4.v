
module testbench;
    reg        clk, rst, S;
    wire       done;
    // Memory wires
    wire [15:0] mem0, mem1, mem2, mem3, mem4, mem5, mem6, mem7;
    // Instantiate top with memory outputs
    top UUT (
        .clk(clk),
        .rst(rst),
        .S(S),
        .done(done),
        .mem0(mem0), .mem1(mem1), .mem2(mem2), .mem3(mem3),
        .mem4(mem4), .mem5(mem5), .mem6(mem6), .mem7(mem7)
    );

    // expose A, B, i, j
    wire [15:0] A = UUT.dp.A;
    wire [15:0] B = UUT.dp.B;
    wire [2:0]  i = UUT.dp.i;
    wire [2:0]  j = UUT.dp.j;

    // clock gen
    initial clk = 0; always #1 clk = ~clk;

    initial begin
        rst = 1; S = 0;
        #20 rst = 0;
        #10 S = 1;
        // wait for done
        while (!done) @(posedge clk);
        @(posedge clk);
        S = 0;
        // final sorted memory
        $display("=== Final sorted memory ===");
        $display("mem = [%0d, %0d, %0d, %0d, %0d, %0d, %0d, %0d]",
                 mem0, mem1, mem2, mem3,
                 mem4, mem5, mem6, mem7);
        $finish;
    end

    always @(posedge clk) begin
        if (!rst && (S || done)) begin
            $display("t=%0t i=%0d j=%0d A=%0d B=%0d mem=[%0d %0d %0d %0d %0d %0d %0d %0d]",
                $time, i, j, A, B,
                mem0, mem1, mem2, mem3,
                mem4, mem5, mem6, mem7
            );
        end
    end
endmodule
