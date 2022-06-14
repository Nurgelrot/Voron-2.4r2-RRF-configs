; Pause macro file
M83					; relative extruder moves
G1 E-3 F2500		; retract 3mm
G91					; relative moves
G1 Z2 F5000			; raise nozzle 2mm
G90					; absolute moves
G1 X10 Y10 F6000 ; go to X=10 Y=10
