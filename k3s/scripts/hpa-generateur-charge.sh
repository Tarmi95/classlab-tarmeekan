#!/bin/bash

DURATION=300   # durée totale en secondes
TARGET_URL="http://192.168.56.13:30081"
WORKERS=25

echo "Génération de charge en cours pendant $DURATION secondes."
echo "Ne pas interrompre ce processus."

# Lance la charge en arrière-plan, limitée par 'timeout'
timeout ${DURATION}s bash -c "
  for i in \$(seq 1 $WORKERS); do
    ( while true; do curl -s '$TARGET_URL' > /dev/null; done ) &
  done
  wait
" &

LOAD_PID=$!

# Affiche "mm:ss / MM:SS" chaque seconde
for ((elapsed=0; elapsed<=DURATION; elapsed++)); do
  # Si la charge s'est déjà terminée, on sort du timer
  if ! ps -p "$LOAD_PID" > /dev/null 2>&1; then
    break
  fi

  mm_elapsed=$((elapsed / 60))
  ss_elapsed=$((elapsed % 60))
  mm_total=$((DURATION / 60))
  ss_total=$((DURATION % 60))

  printf "\rTemps: %02d:%02d / %02d:%02d" "$mm_elapsed" "$ss_elapsed" "$mm_total" "$ss_total"
  sleep 1
done

# Attendre proprement la fin si encore en cours
wait "$LOAD_PID" 2>/dev/null

echo -e "\nGeneration de charge terminée."
