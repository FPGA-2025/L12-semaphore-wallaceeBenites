module Semaphore #(
    parameter CLK_FREQ = 100_000_000
) (
    input wire clk,
    input wire rst_n,

    input wire pedestrian,

    output wire green,
    output wire yellow,
    output wire red
);

    localparam RED_STATE = 2'b00;
    localparam GREEN_STATE = 2'b01;
    localparam YELLOW_STATE = 2'b10;

    localparam RED_TIME = CLK_FREQ * 5;
    localparam GREEN_TIME = CLK_FREQ * 7;
    localparam YELLOW_TIME = CLK_FREQ / 2;

    reg [1:0] current_state, next_state; 

    reg [31:0] counter; 

    reg green_reg, yellow_reg, red_reg;

    assign green = green_reg; 
    assign yellow = yellow_reg;
    assign red = red_reg;

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            current_state <= RED_STATE;
            counter <= 0;
        end else begin
            current_state <= next_state;

            if(current_state != next_state) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    always @(*) begin
        
        next_state = current_state; 

        case (current_state)
            RED_STATE: begin
                if(counter >= RED_TIME - 1) begin
                    next_state = GREEN_STATE;
                end
            end

            GREEN_STATE: begin
                if(pedestrian || counter >= GREEN_TIME - 1) begin
                    next_state = YELLOW_STATE;
                end
            end

            YELLOW_STATE: begin
                if(counter >= YELLOW_TIME - 1) begin
                    next_state = RED_STATE;
                end
            end

            default: begin
                next_state = RED_STATE;
            end
        endcase
    end

    always @(*) begin
        
        green_reg = 1'b0;
        yellow_reg = 1'b0;
        red_reg = 1'b0;

        case (current_state)
            RED_STATE: begin
                red_reg = 1'b1;
            end 

            GREEN_STATE: begin
                green_reg = 1'b1;
            end

            YELLOW_STATE: begin
                yellow_reg = 1'b1;
            end

            default: begin
                red_reg = 1'b1;
            end
        endcase
    end


endmodule
