#!/bin/bash

# Mensagem inicial
notify-send "Informação da Bateria" "Aviso de bateria ativado" -i battery-info

while true; do
    # Obtém a capacidade e o status (carregando ou não)
    iPercent=$(cat /sys/class/power_supply/BAT0/capacity)
    sStatus=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$sStatus" = "Charging" ]; then
        bCharging=true
    else
        bCharging=false
    fi

    # Lógica de aviso: Bateria acima de 90% (Carregando)
    if [ "$bCharging" = true ] && [ "$iPercent" -gt 90 ]; then
        notify-send -u critical "Informação da Bateria" "A Bateria atingiu $iPercent%.\nRemova o carregador!" -i battery-full
        # Toca um som de notificação (o '&' permite que o script continue sem esperar o som acabar)
        paplay --volume=65536 "Windows Background.wav" &
    fi

    # Lógica de aviso: Bateria abaixo de 30% (Descarregando)
    if [ "$bCharging" = false ] && [ "$iPercent" -lt 30 ]; then
        notify-send -u critical "Informação da Bateria" "A Bateria atingiu $iPercent%.\nConecte o carregador!" -i battery-caution
        # Toca um som de alerta mais forte
        paplay --volume=65536 "Windows Background.wav" &
    fi

    sleep 300 # 5 minutos
done10 