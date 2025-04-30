
module top(
    input        clk,
    input        rst,
    input        S,
    output       done,
    // Memory outputs
    output [15:0] mem0,
    output [15:0] mem1,
    output [15:0] mem2,
    output [15:0] mem3,
    output [15:0] mem4,
    output [15:0] mem5,
    output [15:0] mem6,
    output [15:0] mem7
);
    wire EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout;
    wire AgtB, zi, zj;
    wire [15:0] A, B;
    wire [2:0]  i, j;

    Controller ctrl (
        .clk(clk), .rst(rst), .S(S),
        .AgtB(AgtB), .zi(zi), .zj(zj),
        .EA(EA), .EB(EB), .WR(WR),
        .Li(Li), .Lj(Lj), .Ei(Ei), .Ej(Ej),
        .Csel(Csel), .Bout(Bout),
        .done(done)
    );

    Datapath dp (
        .clk(clk), .rst(rst),
        .EA(EA), .EB(EB), .WR(WR),
        .Li(Li), .Lj(Lj), .Ei(Ei), .Ej(Ej),
        .Csel(Csel), .Bout(Bout),
        .A(A), .B(B), .i(i), .j(j),
        .AgtB(AgtB), .zi(zi), .zj(zj),
        // connect new mem outputs
        .mem0(mem0), .mem1(mem1), .mem2(mem2), .mem3(mem3),
        .mem4(mem4), .mem5(mem5), .mem6(mem6), .mem7(mem7)
    );
endmodule
