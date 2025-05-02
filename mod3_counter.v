module mod3_counter (
input wire clk, // Clock input
input wire EN, // Enable signal
input wire AR, // Asynchronous reset
output wire [1:0] q, // Current state output
output wire [2:0] y // Terminal count output
);
// Internal wires
wire [1:0] next_state;
wire [1:0] state;
// Register block for state update
d_flip_flop dff0 (
    .clk(clk),
    .d(next_state[0]),
    .rst(AR),
    .q(state[0])
);
d_flip_flop dff1 (
    .clk(clk),
    .d(next_state[1]),
    .rst(AR),
    .q(state[1])
);
    // Next State Logic (NSL)
nsl_mod3 nsl (
    .q(state),
    .EN(EN),
    .AR(AR),
    .next_state(next_state)
);
    // Output Logic (OL)
ol_mod3 ol (
    .q(state),
    .y(y)
);
    // Direct wire connections for q
buf (q[0], state[0]); // Buffer connects q[0] to state[0]
buf (q[1], state[1]); // Buffer connects q[1] to state[1]
endmodule

module nsl_mod3 (
    input wire [1:0] q,          // Current state
    input wire EN,               // Enable signal
    input wire AR,               // Asynchronous reset
    output wire [1:0] next_state // Next state output
);
    wire en_and_q0, en_and_not_q0;
    wire en_and_q1, en_and_not_q1;
    wire hold_state_0, hold_state_1;

    // Logic for next_state[0] when EN = 1
    and (en_and_q0, q[0], EN);
    and (en_and_q1, q[1], EN);
    xnor (hold_state_0, en_and_q0, en_and_q1);

    // Logic for next_state[1] when EN = 1
    and (en_and_q0, q[0], EN);
    buf (hold_state_1, en_and_q0);

    // When EN = 0, hold the current state
    assign next_state = (EN) ? {hold_state_1, hold_state_0} : q;
endmodule

// module d_flip_flop (
//     input wire clk,    // Clock signal
//     input wire rst,    // Asynchronous reset (active high)
//     input wire d,      // Data input
//     output reg q       // Data output
// );
//     // On positive clock edge or asynchronous reset
//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
//             q <= 1'b0;   // Reset output to 0
//         end else begin
//             q <= d;      // Update output with input
//         end
//     end
// endmodule

module d_flip_flop (
    input wire clk,
    input wire rst,
    input wire d,
    output wire q
);
    wire nd1,nd2,nd3,nd4,nd5,nd6;
    wire nr,q_bar;

    not(nr,rst);
    

    nand(nd1,nd4,nd2);
    nand(nd2,clk,nr,nd1);

    nand(nd3,nd2,clk,nd4);
    nand(nd4,nd3,d,nr);
    
    nand(q_bar,nd2,q);
    nand(q,nd3,q_bar,nr);
endmodule


module ol_mod3 (
    input wire [1:0] q, // Current state
    output wire [2:0] y // 3 bit output
    );
    wire not_q0;
    // Inverter for q[0]
    not (not_q0, q[0]);
    // output logic for y[0]
    xor (y[0], q[0], q[1]);
    // output logic for y[1]
    buf (y[1], not_q0);
    //output logic for y[2]
    assign y[2] = 0;
endmodule
