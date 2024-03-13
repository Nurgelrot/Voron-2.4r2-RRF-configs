M591 D0 ; print out filament sensing diagnostics
M106 P0 S0 ; layer fan off
M220 S100 ; reset speed factor to 100%
M221 D0 S100

G1 E-2 F3600

;G91 ; relative positioning
;G1 Z5 F2400 ; move nozzle relative to position
;G90 ; absolute positioning

G10 P0 S-273.1 ; turn off T0
M144
M140 S-273.1 ; turn off bed heater
G92 E0  ; reset extrusion position
M84 X Y E0; stop all motors