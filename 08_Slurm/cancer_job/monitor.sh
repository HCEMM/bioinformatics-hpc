#!/bin/bash

clear
while true; do
  echo -e "\033[2J\033[H🌡️  Tumor Simulation Dashboard - Node View"
  echo ""

  for i in {0..3}; do
    echo "-----------------------------"
    echo "Patient $i"
    echo ""

    if [[ -f patient_$i/log.txt ]]; then
      tail -n 5 patient_$i/log.txt
    else
      echo "Log not found."
    fi

    echo ""
  done

  sleep 2
done