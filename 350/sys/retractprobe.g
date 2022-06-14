if sensors.probes[0].value[0] == 0
  M564 H1
  G90
  G1 X175 Y356 F10000
  G1 X5
  G1 Y205
  M400
  if sensors.probes[0].value[0] == 0
    abort "Probe detach failed"
G1 X175 Y175