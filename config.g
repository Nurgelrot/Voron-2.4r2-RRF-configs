; DISPLAY
M575 P1 S1 B57600

G90                     ; send absolute coordinates...
M83                     ; ...but relative extruder moves
M550 P"OctoPussy"       ; set printer name
M669 K1                 ; select CoreXY mode
G4 S4   				;wait 2s for expansion boards to start

; ================================== 
; DRIVERS
; ==================================

M569 P0.0 S1 D3 V10						; Z0 Front Left
M569 P0.1 S0 D3 V10						; Z1 Rear Left
M569 P0.2 S1 D3 V10						; Z2 Rear Right
M569 P0.3 S0 D3 V10						; Z3 Front Right
M569 P0.4 S0 D2							; EMPTY
M569 P0.5 S1 D2							; Y (B Motor)
M569 P0.6 S1 D2							; X (A Motor)
M569 P121.0 S0 D2         				; E On toolboard CAN addr 121

M584 X0.6 Y0.5 Z0.0:0.1:0.2:0.3 E121.0
M350 X16 Y16 Z16 E16 I1								; configure microstepping with interpolation
M92 X80.00 Y80.00 Z400.00 E404						; set steps per mm

; Accelerations and speeds
M566 X450 Y450 Z240 E300        					; Set maximum instantaneous speed changes (mm/min) aka Jerk
M203 X10000 Y10000 Z1000 E3600 						; Set maximum speeds (mm/min)
M201 X5000 Y5000 Z350 E600     						; Set maximum accelerations (mm/s^2)
M204 P4000 T5000                					; Set printing acceleration and travel accelerations

; Stepper driver currents
; set motor currents (mA) and motor idle factor in per cent
; Drive currents
M906 X1000 Y1000 Z1000 E550 I50 					; XYZ and E current
M84 S30                        						; Idle timeout

; ==================================
; Endstops						
; ==================================

; Endstops
M574 X2 S1 P"^0.io3.out"							  ; Voron endstop PCB NO VCC Gnd+out for X 
M574 Y2 S1 P"^0.io3.in"                               ;      Gnd+in for Y
M591 D0 P7 C"121.io1.in"  S0 L6.89 R70:130 E15 	  ; Duet3D rotating magnet sensor for extruder drive 0 is connected to E0 endstop input, enabled, sensitivity 24.8mm.rev, 70% to 130% tolerance, 3mm detection length

; Axis travel limits
M208 X0:249 Y0:256 Z0:230

; Belt Locations
M671 X-65:-65:320:320 Y-20:350:350:-20 S20      ; Define Z belts locations (Front_Left, Back_Left, Back_Right, Front_Right)
											; Position of the bed leadscrews.. 4 Coordinates
											; Snn Maximum correction to apply to each leadscrew in mm (optional, default 1.0)
                                            ; S20 - 20 mm spacing
M557 X30:220 Y30:220 P5                     ; Define bed mesh grid (inductive probe, positions include the Y offset!)

; ==================================
; Bed heater
; ==================================
M308 S0 P"temp0" Y"thermistor" T100000 B4138 A"Bed"         ; configure sensor 0 as thermistor on pin temp0
M950 H0 C"out0" T0 Q10                                ; create bed heater output on out0 and map it to sensor 0 PWM 5Hz SSR
M307 H0 B0 S1.00                                      ; disable bang-bang mode for the bed heater and set PWM limit
M140 H0                                               ; map heated bed to heater 0
M143 H0 S120                                          ; set temperature limit for heater 0 to 110C

; ==================================
; Hotend heater 
; ==================================
M308 S1 P"121.temp0" Y"thermistor" T100000 B4138  A"Nozzle"                ; configure sensor 1 as PT1000 on pin 121.temp0
M950 H1 C"121.out0" T1                                ; create nozzle heater output on 121.out0 and map it to sensor 1
M307 H1 B0 S1.00                                      ; disable bang-bang mode for heater  and set PWM limit
M143 H1 S280                                          ; set temperature limit for heater 1 to 280C
; ==================================
; SENSORS MISC 
; ==================================

M308 S3 A"MCU" Y"mcu-temp"

; ==================================
; CHAMBER SENSOR 
; ==================================
M308 S10 P"io2.out+io2.in" Y"dht22" A"Enc Temp[C]"
M308 S11 P"S10.1" Y"dhthumidity" A"Enc Hum[%]"
; ==================================
; Z probes

; Euclid
M558 K0 P8 C"^121.io2.in" T18000 F600:180 H2 A10 S0.01
G31 K0 P500 X-2.5 Y24.5 Z9.07

; nozzle switch -Pretty much unused
M558 K1 P8 C"^0.io5.in" T18000 F1200:180 H1 A10 S0.005 R0
G31 K1 P500 X0 Y0 Z0

; ==================================
; Fans
; ==================================
M950 F0 C"121.out1" Q100                              ; create fan 0 on pin 121.out1 and set its frequency
M106 P0 S0 H-1                                        ; set fan 0 value. Thermostatic control is turned off
M950 F1 C"121.out2" Q100                              ; create fan 1 on pin 121.out2 and set its frequency
M106 P1 S1 H1 T45                                     ; set fan 1 value. Thermostatic control is turned on

M950 F2 C"!out3+out3.tach"							  ; Noctau 12v PWM 4 wire on out 3
M106 P2 H3 L0.2 T25:45 C"Electronics Fan"

; =====================================
; Lights 24v LED strips top of voron
; =====================================
M950 F3 C"0.out1" Q500
M106 P3 H-1 L064 C"Lights"


; Accelerometer
M955 P121.0 I05										  ; toolboard mounted right side of toolhead VIN up OUT0 forward 

; Tools
M563 P0 D0 H1 F0                                      ; define tool 0
G10 P0 X0 Y0 Z0                                       ; set tool 0 axis offsets
G10 P0 R0 S0                                          ; set initial tool 0 active and standby temperatures to 0C
M572 D0 S0.06										  ; Pressure Advance for Tool 0
T0

M501
