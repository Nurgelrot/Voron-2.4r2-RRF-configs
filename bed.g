M561
M558 K0 H8 F800 ;1000
G90
G1 Z10 F2000
M401

G30 K0 P0 X30 Y30 Z-99999
G30 K0 P1 X30 Y220 Z-99999
G30 K0 P2 X220 Y220 Z-99999
G30 K0 P3 X220 Y30 Z-99999 S4

M558 K0 H4 F300 ;500

G30 K0 P0 X30 Y30 Z-99999
G30 K0 P1 X30 Y220 Z-99999
G30 K0 P2 X220 Y220 Z-99999
G30 K0 P3 X220 Y30 Z-99999 S4

M558 K0 H2 F120
while move.calibration.initial.deviation > 0.005
        if iterations >= 4
                break
        echo "Deviation over threshold. Executing pass" , iterations+3, "deviation", move.calibration.initial.deviation
        G30 K0 P0 X30 Y30 Z-99999
        G30 K0 P1 X30 Y220 Z-99999
        G30 K0 P2 X220 Y220 Z-99999
        G30 K0 P3 X220 Y30 Z-99999 S4
        echo "Current deviation: " ^ move.calibration.initial.deviation
        continue
M558 K0 F1200:180
G28 Z

;set global.need_g32 = false