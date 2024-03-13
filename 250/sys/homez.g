G91
G1 H2 Z5 F6000; make damn sure we have enough z to clear the bed on probing.
G90
G1 X125 Y125 F10000
G30

; Uncomment the following lines to lift Z after probing

G91                                     ; relative positioning
G1 Z5 F100                              ; lift Z relative to current position
G90                                     ; absolute positioning
