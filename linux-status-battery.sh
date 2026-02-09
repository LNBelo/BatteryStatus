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
    if [ "$bCharging" = true ] && [ "$iPercent" -gt 43 ]; then
        notify-send -u critical "Informação da Bateria" "A Bateria atingiu $iPercent%. Remova o carregador!" -i battery-full
        # Toca um som de notificação (o '&' permite que o script continue sem esperar o som acabar)
        paplay /usr/share/sounds/mint/stereo/notification-softer.ogg &
    fi

    # Lógica de aviso: Bateria abaixo de 30% (Descarregando)
    if [ "$bCharging" = false ] && [ "$iPercent" -lt 30 ]; then
        notify-send -u critical "Informação da Bateria" "A Bateria atingiu $iPercent%. Conecte o carregador!" -i battery-caution
        # Toca um som de alerta mais forte
        paplay /usr/share/sounds/mint/stereo/notification-softer.ogg &
    fi

    sleep 10000 #300 # 5 minutos
done