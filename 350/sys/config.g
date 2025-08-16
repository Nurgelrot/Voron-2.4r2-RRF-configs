; Network uncomment if not using a SBC 
;M550 P"Duet 3"; set hostname
; Network
;M552 P0.0.0.0 S1 ; configure Ethernet adapter
;M586 P0 S1                                     ; enable HTTP
;M586 P1 S0                                     ; disable FTP
;M586 P2 S0                                     ; disable Telnet

;==================================						;
; DISPLAY												;
;==================================						;
M575 P1 S1 B57600										; PanalDue

G90                     								; send absolute coordinates...
M83                     								; ...but relative extruder moves
M550 P"BigRed1"       									; set printer name
M669 K1                 								; select CoreXY mode
G4 S5   												;wait 5s for expansion boards to start
														;
; ================================== 					;
; DRIVERS												;
; ==================================					;
														;
M569 P0.0 S1 D3 ;V10									; Z0 Front Left
M569 P0.1 S0 D3 ;V10									; Z1 Rear Left
M569 P0.2 S1 D3 ;V10									; Z2 Rear Right
M569 P0.3 S0 D3 ;V10									; Z3 Front Right
M569 P0.4 S1 D2											; X (B Motor)
M569 P0.5 S1 D2											; Y (A Motor)
M569 P124.0 S1 D2         								; E On toolboard CAN addr 124
														;
M584 X0.4 Y0.5 Z0.0:0.1:0.2:0.3 E124.0					;
M350 X16 Y16 Z16 E16 I1									; configure microstepping with interpolation
M92 X160.00 Y160.00 Z400.00 E708.00						; set steps per mm
M906 X1200 Y1200 Z1000 E550 I50 						; XYZ and E current
M84 S30                        							; Idle timeout
														;
;==================================                 	;
; Speeds                                            	;
;==================================                 	;
M566 X450 Y450 Z250 E300        						; Set maximum instantaneous speed changes (mm/min) aka Jerk
M203 X18000 Y18000 Z2400 E7200 							; Set maximum speeds (mm/min)
M201 X8000 Y8000 Z350 E2000     						; Set maximum accelerations (mm/s^2)
M204 P4000 T6000                						; Set printing acceleration and travel accelerations
														;
;==================================                 	;
; Axis Limits                                       	;
;==================================                 	;
M208 X0:349 Y0:350 Z0:300								; set axis min:max
														;
; ==================================					;
; Endstops												;
; ==================================					;
M574 X2 S1 P"^0.io8.in"									; Voron endstop PCB NO VCC Gnd+out for X 
M574 Y2 S1 P"^0.io8.out"									;      Gnd+in for Y
;M591 D0 P3 C"124.io1.in" S0 R70:130 L26.00 E6.0		; Duet3D rotating magnet sensor for extruder drive 0 is connected to E0 endstop input, enabled, sensitivity 24.8mm.rev, 70% to 130% tolerance, 3mm detection length
														;
														;
;+==================================					;
; Z probes												;
;===================================					;
; TAP 													;
M558 K0 P8 C"124.io0.in" T10000 F600:120 H5 A5 S0.01	;
G31 K0 P500 X0 Y0 Z-1.20								; 
														;
; Nozzle switch											;	
;M558 K1 P8 C"^0.io6.in" T18000 F1200:180 H1 A10 S0.005 R0
;G31 K1 P500 X0 Y0 Z0									;
														;
;Belt Locations											;
M671 X-65:-65:420:340 Y-20:450:450:-20 S20				; Define Z belts locations (Front_Left, Back_Left, Back_Right, Front_Right)
														; Position of the bed leadscrews.. 4 Coordinates
														; Snn Maximum correction to apply to each leadscrew in mm (optional, default 1.0)
                                            			; S20 - 20 mm spacing
M557 X15:335 Y15:335 P10                    			; Define bed mesh grid (inductive probe, positions include the Y offset!)
														;
														;
; ==================================					;
; Bed heater											;
; ==================================					;
M308 S0 P"temp0" Y"thermistor" T100000 B4138 A"Bed"		; configure sensor 0 as thermistor on pin temp0
M950 H0 C"out1" T0 Q10									; create bed heater output on out0 and map it to sensor 0 PWM 5Hz SSR
M307 H0 B0 S1.00										; disable bang-bang mode for the bed heater and set PWM limit
M140 H0													; map heated bed to heater 0
M143 H0 S120											; set temperature limit for heater 0 to 120
														;
; ==================================					;
; Hotend heater 										;	
; ==================================					;
M308 S1 P"124.temp0" Y"thermistor" T100000 B4138		; configure sensor 1 as PT1000 on pin 121.temp0
M950 H1 C"124.out0" T1									; create nozzle heater output on 121.out0 and map it to sensor 1
M307 H1 B0 S1.00										; disable bang-bang mode for heater  and set PWM limit
M143 H1 S290											; set temperature limit for heater 1 to 290C
														;
; ==================================					;
; SENSORS												;
; ==================================					;
														;
M308 S3 A"Duet" Y"mcu-temp"								; Duet3d Mainboard
M308 S4 A"SB2040" Y"mcu-temp" P"124.dummy"				; Mellow SB2040 toolboard
M308 S10 P"io7.out+io7.in" Y"dht22" A"Enc Temp[C]"		; Chamber Temp
M308 S11 P"S10.1" Y"dhthumidity" A"Enc Hum[%]"			; Champber Hum
														;
; ==================================					;
; Fans													;
; ==================================					;
M950 F0 C"124.out1" Q100								; create fan 0 on pin 124.out1 and set its frequency
M106 P0 S0 H-1  C"Part Cooling"							; set fan 0 value. Thermostatic control is turned off
														;
M950 F1 C"124.out2" Q100								; create fan 1 on pin 121.out2 and set its frequency
M106 P1 L255 S255 H1 T45 c"Heatsink"					; set fan 1 value. Thermostatic control is turned on
														;
M950 F2 C"!out4+out4.tach"								; Noctau 12v PWM 4 wire on out 3
M106 P2 H3 L0.2 T25:55 C"R Electronics Fan"				;
														;
M950 F3 C"!out5+out5.tach"								; Noctau 12v PWM 4 wire on out 3
M106 P3 H3 L0.2 T25:55 C"L Electronics Fan"				;
														;
; =====================================					;
; Lights												;
; =====================================					;
M950 F4 C"0.out2" Q500									;
M106 P4 H-1 L064 C"Lights"								;
														;
M950 F5 C"0.out7" Q100									; Nevermore 
M106 P5 H-1 C"Nevermore"								;
														;
M950 F6 C"124.out3"	Q100								; create fan 2 on pin 124.out3 and set its frequency
M106 P6 H4 L0.2 T30:50			  						; set fan 2 value. Thermostatic control is turned to SB2040 30-50+ TOOL_PCB
														;
; ====================================					;
; SB LED												;
; ====================================					;
M950 E1 C"124.rgbled" T2								; define the pin
M150 E1 P0 R0 B0 U0 S3 F0								; zero out the lights
M150 E1 P128 B128 S1 F1									; set the voron symbol purple
M150 E1 W255 P255 S2 F0									;
														;
;==================================                 	;
; Tools                                             	;
;==================================                 	;
M563 P0 S"Rapido" D0 H1 F0								; define tool 0
G10 P0 X0 Y0 Z0											; set tool 0 axis offsets
G10 P0 R0 S0											; set initial tool 0 active and standby temperatures to 0C
														;
;==================================                 	;
; Miscellaneous                                     	;
;==================================                 	;    
; Accelerometer											;
;M955 P121.0 I05 									  	; toolboard mounted right side of toolhead VIN up OUT0 forward 
M572 D0 S0.065											; Pressure Advance for Tool 0
M593 P"mzv" F41 S0.1									; input shaping
T0														; Tool 0 active
M501
