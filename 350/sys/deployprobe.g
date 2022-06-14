if sensors.probes[0].value[0] == 1000
  M564 H1
  G90
  G1 X175 Y356 F10000
  G1 X5
  G1 X45
  M400
  if sensors.probes[0].value[0] == 1000
    abort "Probe attach failed"
G1 X175 Y175