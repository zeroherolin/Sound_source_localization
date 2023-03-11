module i2s_top(
    input mic_sck,
    input rst_n,
    input ws_clk,
    output reg [23:0] ldata,
    output reg [23:0] rdata,
    input mic_sd
);

    reg [31:0] shift_reg_l;
    reg [31:0] shift_reg_r;

    always @(posedge mic_sck or negedge rst_n) begin
        if(~rst_n) begin
            shift_reg_l <= 0;
            shift_reg_r <= 0;
        end
        else begin
            if(~ws_clk) begin
                shift_reg_l <= {shift_reg_l[30:0],mic_sd};
                shift_reg_r <= shift_reg_r;
            end
            else begin
                shift_reg_l <= shift_reg_l;
                shift_reg_r <= {shift_reg_r[30:0],mic_sd};
            end
        end
    end

    always @(negedge ws_clk or negedge rst_n) begin
        if(~rst_n) begin
            ldata <= 0;
            rdata <= 0;
        end
        else begin
            ldata <= shift_reg_l[30:7];
            rdata <= shift_reg_r[30:7];
        end
    end

endmodule
