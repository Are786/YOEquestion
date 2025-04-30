module Controller(
    input clk,
    input rst,
    input S,          // start
    input AgtB,       // (A > B) flag from datapath
    input zi,         // (i == 6) flag
    input zj,         // (j == 7) flag
    output reg EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout,
    output reg done
);
    // State encoding
    reg [2:0] state, next_state;
    parameter S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3,
              S4=3'd4, S5=3'd5, S6=3'd6, S7=3'd7;
    // Combinational next-state and output logic
    always @(*) begin
        // Defaults
        EA=0; EB=0; WR=0; Li=0; Lj=0; Ei=0; Ej=0; Csel=0; Bout=0; done=0;
        next_state = state;
        case(state)
            S0: begin
                Li = 1;               // i <= 0 (initialize i)
                if (S) next_state = S1;
                else    next_state = S0;
            end
            S1: begin
                EA = 1; Csel = 0; Ej = 1; // A <= Mem[i]; j <= j+1 (set j = i+1)
                next_state = S2;
            end
            S2: begin
                EB = 1; Csel = 1;    // B <= Mem[j]
                next_state = S3;
            end
            S3: begin
                if (AgtB) next_state = S4;
                else       next_state = S6;
            end
            S4: begin
                WR = 1; Csel = 0; Bout = 1; // Mem[i] = B
                next_state = S5;
            end
            S5: begin
                WR = 1; Csel = 1; Bout = 0; // Mem[j] = A
                next_state = S6;
            end
            S6: begin
                EA = 1; Csel = 0;    // Reload A <= Mem[i] before next loop
                if (!zj) begin
                    Ej = 1;         // j <= j+1 (continue inner loop)
                    next_state = S2;
                end
                else if (!zi) begin
                    Ei = 1; Lj = 1; // i <= i+1, reset j (end inner loop)
                    next_state = S1;
                end
                else begin
                    next_state = S7; // done when i==6 and j==7
                end
            end
            S7: begin
                done = 1;           // Indicate sorting done
                if (!S) next_state = S0; else next_state = S7;
            end
        endcase
    end
    // State register (synchronous reset)
    always @(posedge clk or posedge rst) begin
        if (rst) state <= S0;
        else      state <= next_state;
    end
endmodule
