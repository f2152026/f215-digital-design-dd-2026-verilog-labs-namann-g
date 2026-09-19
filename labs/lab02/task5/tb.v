
module tb;

    reg [3:0] a, b;
    reg op;
    wire [3:0] result;

    reg [3:0] expected;
    integer i, j;
    integer errors;

    alu U1 (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    task check;
        input [3:0] aa, bb;
        input opx;
        begin
            a = aa;
            b = bb;
            op = opx;
            #10;

            if (opx == 0)
                expected = aa + bb;
            else
                expected = aa - bb;

            if (result !== expected) begin
                $display("FAIL: a=%d b=%d op=%b result=%d expected=%d",
                         aa, bb, opx, result, expected);
                errors = errors + 1;
            end
            else begin
                $display("PASS: a=%d b=%d op=%b result=%d",
                         aa, bb, opx, result, expected);
            end
        end
    endtask

    initial begin
        errors = 0;

        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                check(i, j, 0);
                check(i, j, 1);
            end
        end

        a = 9;
        b = 3;
        op = 0;
        #10;

        op = 1;
        #10;

        if (result !== 4'd6) begin
            $display("FAIL: op-only change | result=%d expected=6",
                     result);
            errors = errors + 1;
        end
        else
            $display("PASS: op-only change");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL ERRORS = %d", errors);

        $finish;
    end

endmodule