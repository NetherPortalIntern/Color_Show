/*
---UART STATE MACHINE---

  |<-------------------------------------------------|
  |<---------------------------------------|         |
IDLE ---> START ---> DATA ---> STOP ---> WAIT ---> ERROR 
                       |        |          |         |
                       |        |          |-------->|   
                       |        |------------------->|
                       |---------------------------->|
                       
Primul bit esantionat reprezinta bit-ul de START, care trebuie sa fie 0. 
In caz contrar se considera ca a fost un start fals si se reincepe transmisia la detectarea unui nou bit de start. 
Urmatorii 8 biti esantionati reprezinta bitii de DATE, care pot lua valoare de 0 sau 1. 
In cazul in care paritatea este activata, urmatorul bit reprezinta bit-ul de PARITY, care este verificat. 
In cazul in care paritatea nu este valida, se semnaleaza eroarea, se considera ca datele transmise au fost corupte si se reincepe transmisia la detectarea unui nou bit de start. 
Urmatorul bit/biti reprezinta bit-ul/bitii de STOP, care trebuie sa fie pe 1. 
In caz contrar se semnaleaza eroarea, se considera ca datele transmise nu au fost esantionate corect si se reincepe transmisia la detectarea unui nou bit de start. 
Daca toti bitii verificati (START, PARITY, STOP) sunt valizi, atunci counicaea a avut succes.
*/

`timescale 1 ns/1 ns

module UART_state
  #(`include "UART_width.v")
(input clk,
input rst,

input paritybit,
input stopbit,

input data,
input valid_data,

output [WIDTH_ERROR-1:0]error,
output ready_error,

output [WIDTH_DATABITS-1:0]out,
output ready_out
);

`include "UART_param.v"
`include "CS_errors.v"

reg [WIDTH_UART_STATES-1:0]state_reg, state_next;

parameter IDLE = 'b000;
parameter START = 'b001;
parameter DATA = 'b010;
parameter STOP = 'b011;
parameter WAIT = 'b100;
parameter ERROR = 'b101; 

reg [WIDTH_ERROR-1:0]error_reg, error_next;
reg [WIDTH_DATABITS-1:0]out_reg, out_next;
reg ready_error_reg, ready_error_next;
reg ready_out_reg, ready_out_next;

reg [WIDTH_DATABITS_SIZE-1:0]data_location_reg, data_location_next;
reg parity_check_reg, parity_check_next;
reg [WIDHT_PARITY_STOP_BITS-1:0]parity_stop_location_reg, parity_stop_location_next;
reg [WIDTH_IDLE_BITS-1:0]wait_reg, wait_next;

always @(posedge clk or negedge rst) begin
	if(rst) begin
		state_reg <= IDLE;
		error_reg <= NO_ERRORS;
		out_reg <= 0;
		ready_error_reg <= 1'b0;
		ready_out_reg <= 1'b0;
		data_location_reg <= 'b0;
		parity_check_reg <= 'b0;
		parity_stop_location_reg <= 0;
		wait_reg <= 0;
	end
	else begin
		state_reg <= state_next;
		error_reg <= error_next;
		out_reg <= out_next;
		ready_error_reg <= ready_error_next;
		ready_out_reg <= ready_out_next;
		data_location_reg <= data_location_next;
		parity_check_reg <= parity_check_next;
		parity_stop_location_reg <= parity_stop_location_next;
		wait_reg <= wait_next;
	end
end

always @(*) begin
  state_next = state_reg;
  error_next = error_reg;
  out_next = out_reg;
  ready_error_next = ready_error_reg;
  ready_out_next = ready_out_reg;
  data_location_next = data_location_reg;
  parity_stop_location_next = parity_stop_location_reg;
  parity_check_next = parity_check_reg;
  wait_next = wait_reg;
  
  if(valid_data) begin
	case(state_reg)
	  IDLE: begin
	    ready_out_next = 0;
		ready_error_next = 0;
	    if(!data) begin // received a negedge signal, which means that the transmision started
	      state_next = DATA;
	      error_next = 0;
	      out_next = 0;
	      data_location_next = 0;
	      parity_stop_location_next = 0;
	      parity_check_next = 0;
	    end
	  end
	  DATA: begin
	      out_next = {out_reg[6:0], data}; // the data is shifted and saved in the output register
	      parity_check_next = parity_check_reg ^ data;
	      data_location_next = data_location_reg + 1;
	      if(data_location_reg == 6) begin // if the 8 bits where read
	        state_next = STOP;
	      end
	    end
	  STOP: begin
	      case({paritybit, stopbit, parity_stop_location_reg})
	        'b00000, 'b00101, 'b01001, 'b01110: begin // the last stop bit
	          if(data) begin // valid last stop bit
	            parity_stop_location_next = 0;
	            state_next = WAIT;
	          end
	          else begin // non-valid stop bit - report error
	            error_next = FAILED_STOP_BITS;
	            state_next = ERROR;
	          end
	        end
	        'b00100, 'b01101: begin // first stop bit in case of multiple stop bits
	          if(data) begin // valid stop bit
	            state_next = STOP;
	          end
	          else begin // non-valid stop bit - report error
	            error_next = FAILED_STOP_BITS;
	            state_next = ERROR;
	          end
	        end
	        'b10000, 'b11100: begin // parity bit
	          if(parity_check_reg == paritybit[0]) begin // non-valid parity - report error
	            error_next = FAILED_PARITY_BIT;
	            state_next = ERROR;
	          end
	          else begin // valid parity - continue to the stop bits
	            state_next = STOP;
	          end
	        end
	        default: begin // toward the next state
	          state_next = WAIT;
	        end
	      endcase
	      parity_stop_location_next = parity_stop_location_reg + 1;
	    end
	  WAIT: begin
	        if(data) begin //the idle bit was valid (1)
	          if(wait_reg == 0) begin // first iteration trough WAIT state
	            wait_next = 1;
	          end
	          else begin // second iteration trough WAIT state - the communication was succesfull
	            ready_out_next = 1'b1;
	            wait_next = 0;
	            state_next = IDLE;
	          end
	        end
	        else begin // wrong idle bit - report error
	          error_next = FAILED_IDLE_BITS;
	          state_next = ERROR;
 	        end
 	  end
	  ERROR: begin
	    ready_error_next = 1'b1;
	    state_next = IDLE;
	  end
	endcase
	end
end

assign error = error_reg;
assign ready_error = ready_error_reg;
assign out = out_reg;
assign ready_out = ready_out_reg;

endmodule