`timescale 1ns/1ps
`include "fifo.sv"
`include "interface_transactions.sv"
`include "driver.sv"
`include "checker.sv"
`include "score_board.sv"
`include "agent.sv"
`include "ambiente.sv"
`include "test.sv"


module test_bench;
    reg clk;
    parameter width = 16;
    parameter depth = 8;
    test #(.width(width), .depth(depth)) t0;

    fifo_if #(.width(width)) _if(.clk(clk));
    always #5 clk = ~clk;

    fifo_flops #(.bits(width), .depth(depth)) uut(
        .Din(_if.dato_in),
        .Dout(_if.dato_out),
        .push(_if.push),
        .pop(_if.pop),
        .clk(_if.clk),
        .full(_if.full),
        .pndng(_if.pndng),
        .rst(_if.rst)
    );

    initial begin
        clk = 0;
        t0 = new();
        t0._if = _if;
        t0.ambiente_inst.driver_inst.vif = _if;
        fork
            t0.run();
        join_none
    end

    always @(posedge clk) begin
        if ($time > 200000) begin
            $display("Test_bench: Tiempo limite de prueba en el test_bench alcanzado");
            $finish;
        end
    end
    
endmodule