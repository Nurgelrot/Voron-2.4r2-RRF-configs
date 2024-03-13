; DISPLAY
M575 P1 S1 B57600

G90                                                         ; send absolute coordinates...
M83                                                         ; ...but relative extruder moves
M550 P"OctoPussy"                                           ; set printer name
M669 K1                                                     ; select CoreXY mode
G4 S8                                                       ; wait 8s for expansion boards to start

; ================================== 
; DRIVERS
; ==================================

M569 P0.0 S1 D3 V10                                         ; Z0 Front Left
M569 P0.1 S0 D3 V10                                         ; Z1 Rear Left
M569 P0.2 S1 D3 V10                                         ; Z2 Rear Right
M569 P0.3 S0 D3 V10                                         ; Z 3Front Right
M569 P0.4 S0 D2                                             ; EMPTY
M569 P0.5 S1 D2                                             ; Y (B Motor)
M569 P0.6 S1 D2                                             ; X (A Motor)
M569 P124.0 S1 D2                                           ; E On toolboard CAN addr 124

M584 X0.6 Y0.5 Z0.0:0.1:0.2:0.3 E124.0
M350 X16 Y16 Z16 E16 I1                                     ; configure microstepping with interpolation
M92 X80.00 Y80.00 Z400.00 E562.00                           ; LGX Lite set steps per mm

; Accelerations and speeds
M566 X350 Y350 Z150 E300                                    ; Set maximum instantaneous speed changes (mm/min) aka Jerk
M203 X18000 Y18000 Z1200 E3600                              ; Set maximum speeds (mm/min)
M201 X8000 Y8000 Z350 E600                                  ; Set maximum accelerations (mm/s^2)
M204 P4000 T6000                                            ; Set printing acceleration and travel accelerations

; Stepper driver currents
; set motor currents (mA) and motor idle factor in per cent
; Drive currents
M906 X1100 Y1100 Z1000 E600 I50                             ; XYZ and E current
M84 S30                                                     ; Idle timeout

; ==================================
; Endstops						
; ==================================

; Endstops
M574 X2 S1 P"^124.io0.in"                                   ; X on toolboard io1 
M574 Y2 S1 P"^0.io3.in"                                     ; Y on io3

;Filament monitored disabled in 3.5rc2 do to too many updates error to RRF36
;M591 D0 P3 C"124.io2.in" S1 R70:130 L25.52 E3.0 	  ; Duet3D rotating magnet sensor for extruder drive 0 is connected to E0 endstop input, enabled, sen


; Axis travel limits
M208 X0:249 Y0:250 Z0:205

; Belt Locations
M671 X-65:-65:320:320 Y-20:350:350:-20 S20                  ; Define Z belts locations (Front_Left, Back_Left, Back_Right, Front_Right)
                                                            ; Position of the bed leadscrews.. 4 Coordinates
                                                            ; Snn Maximum correction to apply to each leadscrew in mm (optional, default 1.0)
                                                            ; S20 - 20 mm spacing
M557 X25:225 Y25:225 P9                                     ; Define bed mesh grid (inductive probe, positions include the Y offset!)

; ==================================
; Bed heater
; ==================================
M308 S0 P"temp0" Y"thermistor" T100000 B4138 A"Bed"         ; configure sensor 0 as thermistor on pin temp0
M950 H0 C"out0" T0 Q10                                      ; create bed heater output on out0 and map it to sensor 0 PWM 5Hz SSR
M307 H0 B0 S1.00                                            ; disable bang-bang mode for the bed heater and set PWM limit
M140 H0                                                     ; map heated bed to heater 0
M143 H0 S120                                                ; set temperature limit for heater 0 to 110C

; ==================================
; Hotend heater 
; ==================================
M308 S1 P"124.temp0" Y"thermistor" T100000 B4138  A"Nozzle" ; configure sensor 1 as PT1000 on pin 124.temp0
M950 H1 C"124.out0" T1                                      ; create nozzle heater output on 124.out0 and map it to sensor 1
M307 H1 B0 S1.00                                            ; disable bang-bang mode for heater  and set PWM limit
M143 H1 S280                                                ; set temperature limit for heater 1 to 280C
; ==================================
; SENSORS MISC 
; ==================================

M308 S3 A"Duet" Y"mcu-temp"
M308 S4 A"RRF36" Y"mcu-temp" P"124.dummy"


; ==================================
; CHAMBER SENSOR 
; ==================================
M308 S10 P"io2.out+io2.in" Y"dht22" A"Enc Temp[C]"
M308 S11 P"S10.1" Y"dhthumidity" A"Enc Hum[%]"
; ==================================
; Z probes

; TAP
M558 K0 P8 C"^124.io1.in" T18000 F400:120 H5 A5 S0.01
G31 K0 P500 X0 Y0 Z-0.90                                    ;

; nozzle switch


; ==================================
; Fans
; ==================================
M950 F0 C"124.out1" Q100                                    ; create fan 0 on pin 124.out1 and set its frequency
M106 P0 S0 H-1                                              ; set fan 0 value. Thermostatic control is turned off
M950 F1 C"124.out2" Q100                                    ; create fan 1 on pin 124.out2 and set its frequency
M106 P1 S1 H1 T45                                           ; set fan 1 value. Thermostatic control is turned on

M950 F2 C"!out3+out3.tach"                                  ; Noctau 12v PWM 4 wire on out 3
M106 P2 H3 L0.2 T25:45 C"Electronics Fan"

;M950 F5 C"124.out3" Q100                            ; create fan 2 on pin 124.out3 and set its frequency
;M106 P5 H4 L0.2 T30:50                              ; set fan 2 value. Thermostatic control is turned to SB2040 50+ TOOL_PCB

M950 F4 C"0.out5" Q100
M106 P4 H-1 C"Nevermore"

; =====================================
; Lights
; =====================================
M950 F3 C"0.out1" Q500
M106 P3 H-1 L064 C"Lights"

; ====================================					
; SB LED												
; ====================================					
M950 E1 C"124.rgbled" T2                                    ; define the pin
M150 E1 P0 R0 B0 U0 S3 F0                                   ; zero out the lights
M150 E1 P128 R128 B128 S1 F1                                ; set the voron symbol purple
M150 E1 W255 P255 S2 F0                                     ;

; Accelerometer
M955 P124.0 I10

; Tools
M563 P0 D0 H1 F0                                            ; define tool 0
G10 P0 X0 Y0 Z0                                             ; set tool 0 axis offsets
G10 P0 R0 S0                                                ; set initial tool 0 active and standby temperatures to 0C
M572 D0 S0.065                                              ; Pressure Advance for Tool 0
M593 P"zvddd" F45 S0.1                                      ; input shaping
T0

M501