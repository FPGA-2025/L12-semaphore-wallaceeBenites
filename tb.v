`timescale 1ns/1ps

module tb;

parameter CLK_FREQ = 4;
parameter MEMFILE = "teste.txt";

reg clk = 0;
reg rst_n = 0;
reg pedestrian_tb = 0;

wire green;
wire yellow;
wire red;

Semaphore #(
    .CLK_FREQ (CLK_FREQ)
) uut (
    .clk        (clk),
    .rst_n      (rst_n),
    .pedestrian (pedestrian_tb),
    .green      (green),
    .yellow     (yellow),
    .red        (red)
);

always #5 clk = ~clk;

reg [3:0] trace_mem [0:1023]; // {red, yellow, green, pedestrian}
reg [2:0] expected_state;
reg [2:0] actual_state;

integer i;

initial begin
    $dumpfile("saida.vcd");
    $dumpvars(0, tb);

    $display("Iniciando testbench com trace combinado...");

    $readmemb(MEMFILE, trace_mem);

    rst_n = 0;
    #20;
    rst_n = 1;

    for (i = 0; i < 1024; i = i + 1) begin
        @(negedge clk);

        // Detecção de linha inválida (contém 'x' ou 'z')
        if (^trace_mem[i] === 1'bx) begin
            $display("FIM: linha inválida encontrada na posição %0d", i);
            $finish;
        end

        pedestrian_tb = trace_mem[i][0];
        expected_state = trace_mem[i][3:1];
        actual_state = {red, yellow, green};

        if (expected_state !== actual_state) begin
            $display("=== ERRO ciclo %0d: esperado %b, obtido %b (pedestre=%b)",
                     i, expected_state, actual_state, pedestrian_tb);
        end else begin
            $display("=== OK   ciclo %0d: estado %b (pedestre=%b)",
                     i, actual_state, pedestrian_tb);
        end

        // Verificação especial: transição para CLOSING após botão
        if (i > 0 && trace_mem[i-1][0] == 1 && expected_state == 3'b010) begin
            if (actual_state !== 3'b010)
                $display("=== ERRO: botão foi pressionado mas estado esperado CLOSING (yellow)");
        end
    end

    $display("Testbench encerrado.");
    $finish;
end

endmodule
