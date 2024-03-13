; beg.g
M290 R0 S0      ;  clear baby stepping
M561            ;  reset all bed adjustments
M400            ;  flush move queue

; Home if not already
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
  echo "not all axes homed, homing axes first"
  G28

G30 K0 P0 X30 Y30 Z-99999
G30 K0 P1 X30 Y220 Z-99999
G30 K0 P2 X220 Y220 Z-99999
G30 K0 P3 X220 Y30 Z-99999 S4
echo "Current rough pass deviation: " ^ move.calibration.initial.deviation

; Slowdown more for medium pass
M558 K0 H5 F120 ;500

while move.calibration.initial.deviation > 0.003
        if iterations >= 5
			echo "Error: Max attemps failed. Deviation: " ^ move.calibration.initial.deviation
			abort
        echo "Deviation over threshold. Executing pass" , iterations+2, "deviation", move.calibration.initial.deviation
        G30 K0 P0 X30 Y30 Z-99999
        G30 K0 P1 X30 Y220 Z-99999
        G30 K0 P2 X220 Y220 Z-99999
        G30 K0 P3 X220 Y30 Z-99999 S4
        echo "Current deviation: " ^ move.calibration.initial.deviation
        continue
echo "Final deviation: " ^ move.calibration.initial.deviation

M558 K0 F400:120
G28 Z           ; reset Z=0 as it has likely moved.