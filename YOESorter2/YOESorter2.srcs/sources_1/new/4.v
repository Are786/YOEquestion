`timescale 1ns / 1ps
module Controller#(
    parameter state0 = 3'b000,
    parameter state1 = 3'b001,
    parameter state2 = 3'b010,
    parameter state3 = 3'b011,
    parameter state4 = 3'b100,
    parameter state5 = 3'b101,
    parameter state6 = 3'b110,
    parameter state7 = 3'b111
)(
    input            S, rst, clk,             // THROUGH TEST BENCH
    input            zi, zj, AgtB,            // FLGS RECEIVED FROM DATA PATH
    output           Li_w,
    output           Ei_w,
    output           Lj_w,
    output           Ej_w,
    output           EA_w,
    output           EB_w,
    output           Csel_w,
    output           Bout_w,
    output           Wr_w,
    output           Done_w
);

    reg       Li;
    reg       Ei;
    reg       Lj;
    reg       Ej;
    reg       EA;
    reg       EB;
    reg       Csel;
    reg       Bout;
    reg       Wr;
    reg       Done;

    reg [2:0] state = state0;

    always @(posedge clk) begin
        if (rst) begin
            state <= state0;
            // <outputs> <= <initial_values>;
            Li <= 0; 
            Ei <= 0; // here they are not function of state but reset
            Lj <= 0;
            Ej <= 0;
            EA <= 0;
            EB <= 0;
            Csel <= 0;
            Bout <= 0;
            Wr <= 0;
            Done <= 0;
        end else begin
            // Default: clear Mealy?style signals every cycle
            Li = 0; Ei = 0; Lj = 0; Ej = 0; EA = 0; EB = 0; Csel = 0; Bout = 0; Wr = 0; Done = 0;

            case (state)
                state0 : begin
                    if (S)
                        state <= state1;
                    else if (!S)
                        state <= state0;
                    else
                        state <= state0;
                    // <outputs> <= <values>;
                    Li <= 1; // load 0 in I counter
                    Ei <= 1; // start count
                end

                state1 : begin
                    // UNCONDITIONAL MOVE TO S2
                    state <= state2;	
                    //***** <outputs> <= <values>;
                    //Enable EA, Set Csel=0, also enable Lj and Ej to load data into J counter from I counter
                    EA <= 1;
                    Csel <= 0;
                    Lj <= 1; // load I+1 IN J
                    Ej <= 1;
                end

                state2 : begin
                    // UNCONDITIONAL MOVE TO S3
                    state <= state3;
                    //*** <outputs> <= <values>;
                    // Enable EB, Set Csel to 1
                    EB <= 1;
                    Csel <= 1;
                end

                state3 : begin // NO FLAGS DEFINED IN BOX
                    if (AgtB) begin // If true move on to next state S4
                        state <= state4;
                    end else if (zj) begin // If AgtB is low, then check if zj is high
                        if (zi) begin
                            // if zi is also high  Move TO S7 WHERE DONE=1
                            state <= state7;
                        end else begin // if zi is low, ENABLE Ei, that is Increment I counter, and move to state 1
                            Ei <= 1; // mealy 
                            state <= state1;
                        end
                    end else if (!zj) begin // if zj is low enable Ej and move to S2
                        Ej <= 1; // again mealy
                        state <= state2;
                    end
                end

                state4 : begin
                    // UNCONDITIONAL MOVE TO S5
                    state <= state5;
                    //*** <outputs> <= <values>;
                    // SET Wr=1, Csel=0, Bout=1              
                    Wr <= 1;
                    Csel <= 0;
                    Bout <= 1;
                end

                state5 : begin
                    // UNCONDITIONAL MOVE TO S6
                    state <= state6;
                    // <outputs> <= <values>; Set Wr=1, Csel=1, and Bout = 0
                    Wr <= 1;
                    Csel <= 1;
                    Bout <= 0;
                end

                state6 : begin
                    if (zj) begin // if zj is high check zi
                        if (zi) begin
                            // if zi is also high  Move TO S7 WHERE DONE=1
                            state <= state7;
                        end else begin // if zi is low, ENABLE Ei, that is Increment I counter, AND MOVE TO S1
                            Ei <= 1; // mealy 
                            state <= state1;
                        end
                    end else if (!zj) begin
                        Ej <= 1; // again mealy
                        state <= state2;
                    end
                    // <outputs> <= <values>; ENABLE EA, set Csel=0
                    EA <= 1;
                    Csel <= 0;
                end

                state7 : begin
                    // <outputs> <= <values>;
                    Done <= 1;
                end

                default : begin
                    Li    <= 0;
                    Ei    <= 0;
                    EA    <= 0;
                    Csel  <= 0;
                    Lj    <= 0;
                    Ej    <= 0;
                    EB    <= 0;
                    Wr    <= 0;
                    Bout  <= 0;
                    Done  <= 0;
                    state <= state0;
                end
            endcase
        end
    end

    assign Li_w   = Li;
    assign Ei_w   = Ei;
    assign Lj_w   = Lj;
    assign Ej_w   = Ej;
    assign EA_w   = EA;
    assign EB_w   = EB;
    assign Csel_w = Csel;
    assign Bout_w = Bout;
    assign Wr_w   = Wr;
    assign Done_w = Done;

endmodule
