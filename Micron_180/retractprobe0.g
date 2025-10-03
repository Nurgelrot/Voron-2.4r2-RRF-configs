if sensors.probes[0].value[0] == 0
  M564 H1
  G90
  G1 X18 Y150 F8000
  G1 Y187 F4000
  G1 X70 F8000
  M400 S1
  if sensors.probes[0].value[0] == 0
    abort "Probe detach failed"
G1 X82 Y90
