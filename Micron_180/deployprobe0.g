if sensors.probes[0].value[0] == 1000
  M564 H1
  G90
  G1 X18 Y150 F8000
  G1 Y187 F4000
  G1 Y150
  M400 S1
  if sensors.probes[0].value[0] == 1000
    abort "Probe attach failed"
G1 X92 Y90
