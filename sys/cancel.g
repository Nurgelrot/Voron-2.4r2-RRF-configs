M220 S100           ; restore speed to 100%
M221 S100           ; restore extrusion flow to 100%

M106 P0 S0          ; layer fan off
;G1 Y300 F18000
;G1 E2 F3600        ; unretract filament from pause.g
M140 S0             ; turn off heatbed
M104 S0             ; turn off temperature
M107                ; turn off fan
M84 X Y E           ; disable motors
