#!/bin/bash

# Mensagem inicial
notify-send "Informação da Bateria" "Aviso de bateria ativado" -i battery-info

while true; do
    # Obtém a capacidade e o status (carregando ou não)
    iPercent=$(cat /sys/class/power_supply/BAT0/capacity)
    sStatus=$(cat /sys/class/power_supply/BAT0/status)

    # Verifica se está carregando (Charging)
    if [ "$sStatus" = "Charging" ]; then
        bCharging=true
    else
        bCharging=false
    fi

    # Lógica de aviso: > 90% carregando ou < 30% descarregando
    if [ "$bCharging" = true ] && [ "$iPercent" -gt 60 ]; then
        notify-send -u critical "Informação da Bateria" "A Bateria atingiu $iPercent%. Remova o carregador!" -i battery-full
    fi

    if [ "$bCharging" = false ] && [ "$iPercent" -lt 30 ]; then
        notify-send -u critical "Informação da Bateria" "A Bateria atingiu $iPercent%. Conecte o carregador!" -i battery-caution
    fi

    sleep 300 # 5 minutes
done