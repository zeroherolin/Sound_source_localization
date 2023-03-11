module mic2bram(
    input clk,
    input rst_n,
    input mic_sck,

    //bram port
    input      [31:0] din,
    output reg [31:0] dout,
    output reg        ram_en,
    output reg [3:0]  ram_we,
    output            ram_rst,
    output reg [31:0] ram_addr,

    input [3:0] mic_sd,
    output mic_ws,
    output mic_ck,

    input start,
    output done
);

assign ram_rst = 1'b0;

assign mic_ck = mic_sck;

wire [23:0] mic_data [6:0];

localparam div_ws = 64;
reg [7:0] ws_cnt;
assign mic_ws = (ws_cnt > div_ws/2-1) ? 1'b0 : 1'b1;

always @(negedge mic_sck or negedge rst_n) begin
    if(~rst_n) begin
        ws_cnt <= 0;
    end
    else begin
        if(ws_cnt == div_ws-1) begin
            ws_cnt <= 0;
        end
        else begin
            ws_cnt <= ws_cnt + 1;
        end
    end
end

wire ws_clk;
assign ws_clk = mic_ws;


i2s_top i2s_u3(
    .mic_sck(mic_sck),
    .ws_clk(ws_clk),
    .rst_n(rst_n),
    .ldata(),
    .rdata(mic_data[6]),
    .mic_sd(mic_sd[3])
);

genvar i;

generate
    for (i = 0; i <= 4; i = i + 2) begin: I2S_Decoder
        i2s_top i2s_u(
            .mic_sck(mic_sck),
            .ws_clk(ws_clk),
            .rst_n(rst_n),
            .ldata(mic_data[i]),
            .rdata(mic_data[i + 1]),
            .mic_sd(mic_sd[i / 2])
        );
    end
endgenerate

reg [31:0] ram_temp [1023:0];

initial begin
    $readmemb("C:/Users/ZhouLin/Desktop/Sound_source_localization/zynq_proj/mem1024.txt", ram_temp);
end

localparam IDLE = 0;
localparam READ_MIC = 1;
localparam WRITE_BRAM = 2;

reg [1:0] state;
reg [6:0] m_cnt;

reg write_done;

always @(posedge ws_clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= IDLE;
        m_cnt <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if(start) begin
                    state <= READ_MIC;
                    m_cnt <= 0;
                end
                else begin
                    state <= state;
                end
            end
            READ_MIC: begin
                if(m_cnt == 127) begin
                    state <= WRITE_BRAM;
                end
                else begin
                    m_cnt <= m_cnt + 1;
                    state <= state;
                end
                ram_temp[m_cnt*8  ] <= {{8{mic_data[0][23]}}, mic_data[0]};
                ram_temp[m_cnt*8+1] <= {{8{mic_data[1][23]}}, mic_data[1]};
                ram_temp[m_cnt*8+2] <= {{8{mic_data[2][23]}}, mic_data[2]};
                ram_temp[m_cnt*8+3] <= {{8{mic_data[3][23]}}, mic_data[3]};
                ram_temp[m_cnt*8+4] <= {{8{mic_data[4][23]}}, mic_data[4]};
                ram_temp[m_cnt*8+5] <= {{8{mic_data[5][23]}}, mic_data[5]};
                ram_temp[m_cnt*8+6] <= {{8{mic_data[6][23]}}, mic_data[6]};
                ram_temp[m_cnt*8+7] <= 0;
            end
            WRITE_BRAM: begin
                if(write_done) begin
                    state <= IDLE;
                end
                else begin
                    state <= state;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

localparam RAM_IDLE = 0;
localparam WRITING = 1;
localparam END_WRITE = 2;
localparam start_addr = 32'h4000_0000;
localparam end_addr = 32'h4000_0FFC;

reg [1:0] ram_state;
reg [9:0] ram_cnt;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        ram_state <= 0;
        ram_cnt <= 0;
        ram_addr <= start_addr;
        dout <= 0;
        ram_en <= 1'b0;
        ram_we <= 4'h0;
        write_done <= 1'b0;
    end
    else begin
        case(ram_state)
            RAM_IDLE: begin
                ram_cnt <= 0;
                write_done <= 1'b0;
                ram_addr <= start_addr;
                if(state==WRITE_BRAM) begin
                    ram_en <= 1'b1;
                    ram_we <= 4'hF;
                    dout <= ram_temp[ram_cnt];
                    ram_state <= WRITING;
                end
                else begin
                    ram_state <= ram_state;
                end
            end
            WRITING: begin
                if(ram_addr == end_addr) begin
                    ram_en <= 1'b0;
                    ram_we <= 4'h0;
                    ram_state <= END_WRITE;
                end
                else begin
                    dout <= ram_temp[ram_cnt+1];
                    ram_cnt <= ram_cnt + 1;
                    ram_addr <= ram_addr + 4;
                    ram_state <= ram_state;
                end
            end
            END_WRITE: begin
                if(state==IDLE) begin
                    ram_state <= RAM_IDLE;
                end
                else begin
                    ram_state <= ram_state;
                end
                write_done <= 1'b1;
            end
            default: begin
                ram_state <= RAM_IDLE;
            end
        endcase
    end
end

assign done = (ram_state==END_WRITE) ? 1'b1 : 1'b0;

endmodule
