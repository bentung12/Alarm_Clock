module alarm_clock
					( 
					input logic clk, input logic rst, input logic SW1, input logic SW2, input logic SW4, input logic KEY0, input logic KEY2, input logic KEY3,
					
					output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2, output logic [6:0] HEX3, output logic LED9, output logic LED7);
					
					logic clkMode;
					logic [31:0] defaultTime; 
					logic [24:0] debugTime;
					logic [25:0] ledTime;
					logic [3:0] hexMinOnes;
					logic [3:0] hexMinTens;
					logic [1:0] hexHoursTens;
					logic [3:0] hexHoursOnes;
					
					
					logic [3:0] minOnes;
					logic [3:0] minTens;
					logic [4:0] hours;
					logic [1:0] hoursTens;
					logic [3:0] hoursOnes;
					logic minuteOnesInc;
					logic minuteTensInc;
					logic hoursInc;
					logic isatwo;
					logic isaone;
					
					logic [3:0] minOnesAlarm;
					logic [3:0] minTensAlarm;
					logic [4:0] hoursAlarm;
					logic [1:0] hoursTensAlarm;
					logic [3:0] hoursOnesAlarm;
					logic minuteOnesIncAlarm;
					logic minuteTensIncAlarm;
					logic hoursIncAlarm;
					logic isatwoAlarm;
					logic isaoneAlarm;
					logic equalTime;
					logic alarmOn;
					logic alarmOff;
					
					
					assign minuteOnesInc = ((!SW1 || (SW1 && SW2)) && clkMode) || (SW1 && !SW2 && KEY2 && !KEY3 && (debugTime == 0));
					
					assign minuteTensInc = (minuteOnesInc && (minOnes == 4'd9));
					assign hoursInc = (minuteTensInc && (minTens == 4'd5)) || (SW1 && !SW2 && KEY3 && !KEY2 && (debugTime == 0));
					
					assign clkMode = SW4 ? (debugTime == 0) : (defaultTime == 0);
					
					counter #(10) minOnesCounter(.inc(minuteOnesInc), .dec('0), .clk, .rst, .cnt(minOnes));      //minutes ones counter
					counter #(6) minTensCounter(.inc(minuteTensInc), .dec('0), .clk, .rst, .cnt(minTens));   //minutes tens counter
					
					counter #(24) hoursCounter(.inc(hoursInc), .dec('0), .clk, .rst, .cnt(hours));
					
					assign isatwo = hours > 5'd19;
					assign isaone = (hours > 5'd9) && !isatwo; 
					
					assign hoursTens = {isatwo,isaone};
					
					always_comb begin
						unique case (1'b1)
							isatwo: hoursOnes = hours - 5'd20;
							isaone: hoursOnes = hours - 5'd10;
							default: hoursOnes = hours;
						endcase
					end
					
					assign hexMinOnes = (SW2 && !SW1) ? minOnesAlarm : minOnes;
					assign hexMinTens = (SW2 && !SW1) ? minTensAlarm : minTens;
					assign hexHoursOnes = (SW2 && !SW1) ? hoursOnesAlarm : hoursOnes;
					assign hexHoursTens = (SW2 && !SW1) ? hoursTensAlarm : hoursTens;
					
					ourHex bit0Hex(.s(hexMinOnes), .z(HEX0));
					ourHex bit1Hex(.s(hexMinTens), .z(HEX1));
					ourHex bit2Hex(.s(hexHoursOnes), .z(HEX2));
					ourHex bit3Hex(.s(hexHoursTens), .z(HEX3));
					
					counter #(25_000_000) halfSecond (.clk, .rst, .inc(1'b1), .dec(1'b0), .cnt(debugTime));
					counter #(3_000_000_000) minute (.clk, .rst, .inc(1'b1), .dec(1'b0), .cnt(defaultTime));
					counter #(50_000_000) second (.clk, .rst, .inc(1'b1), .dec(1'b0), .cnt(ledTime));
					
					assign LED9 = (ledTime <= 26'd10_000_000);

					assign equalTime = (minOnesAlarm == minOnes) && (minTensAlarm == minTens) && (hoursOnesAlarm == hoursOnes) && (hoursTensAlarm == hoursTens);
					
					ourDff #(1) dff2 (.rst(!KEY0 || rst), .clk, .en(equalTime), .q(alarmOn), .d(1'b1));
					
					assign LED7 = alarmOn && LED9;
					
					//alarm
					
					assign minuteOnesIncAlarm = (SW2 && !SW1 && KEY2 && !KEY3 && (debugTime == 0));
					assign minuteTensIncAlarm = (minuteOnesIncAlarm && (minOnesAlarm == 4'd9));
					assign hoursIncAlarm = (!SW1 && SW2 && KEY3 && !KEY2 && (debugTime == 0));
					
					counter #(10) minOnesCounterAlarm(.inc(minuteOnesIncAlarm), .dec('0), .clk, .rst(!KEY0 || rst), .cnt(minOnesAlarm));      //minutes ones counter
					counter #(6) minTensCounterAlarm(.inc(minuteTensIncAlarm), .dec('0), .clk, .rst(!KEY0 || rst), .cnt(minTensAlarm));   //minutes tens counter
					
					counter #(24) hoursCounterAlarm(.inc(hoursIncAlarm), .dec('0), .clk, .rst(!KEY0 || rst), .cnt(hoursAlarm));
					
					assign isatwoAlarm = hoursAlarm > 5'd19;
					assign isaoneAlarm = (hoursAlarm > 5'd9) && !isatwoAlarm; 
					
					assign hoursTensAlarm = {isatwoAlarm,isaoneAlarm};
					
					always_comb begin
						unique case (1'b1)
							isatwoAlarm: hoursOnesAlarm = hoursAlarm - 5'd20;
							isaoneAlarm: hoursOnesAlarm = hoursAlarm - 5'd10;
							default: hoursOnesAlarm = hoursAlarm;
						endcase
					end
					
					
					
					
					
endmodule