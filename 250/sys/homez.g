M18 Z
M17 Z
G4 P150

G91
G1 H2 Z5 F6000
G90
M401                ; Explicit call to go get the Euclid (deplyprobe.g)
G1 X125 Y125 F10000
G30 K0 Z-99999
M402                ; Dock the Euclid (retractprobe.g)
