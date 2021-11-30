module DTigger
    #(
         parameter N = 8
     )
     (
         input clk,
         input [N-1:0] D,
         output reg [N-1:0] Q
     );
     reg [N-1:0] T;
    always @(posedge clk) begin
        T=D;
        Q=T;
    end

endmodule
