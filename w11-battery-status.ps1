# Carrega as bibliotecas de interface do Windows
Add-Type -AssemblyName System.Windows.Forms

# Exibe a mensagem inicial de ativação (opcional)
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Information
$notify.Visible = $true
$notify.ShowBalloonTip(5000, "Informação da Bateria", "Aviso de bateria ativado", "Info")

while ($true) {
    # Obtém dados da bateria (Status e Porcentagem)
    $battery = Get-CimInstance -ClassName Win32_Battery
    $percent = $battery.EstimatedChargeRemaining
    $status = $battery.BatteryStatus # 2 = Carregando, 1 = Descarregando

    # Lógica de aviso: > 90% carregando
    if ($status -eq 2 -and $percent -gt 90) {
        $msg = "A Bateria atingiu $percent%. Remova o carregador!"
        $notify.ShowBalloonTip(10000, "Informação da Bateria", $msg, "Info")
        # Toca o som (ajuste o caminho se necessário)
        $player = New-Object System.Media.SoundPlayer("C:\Windows\Media\Windows Background.wav")
        $player.Play()
    }

    # Lógica de aviso: < 30% descarregando
    if ($status -eq 1 -and $percent -lt 30) {
        $msg = "A Bateria atingiu $percent%. Conecte o carregador!"
        $notify.ShowBalloonTip(10000, "Informação da Bateria", $msg, "Warning")
        $player = New-Object System.Media.SoundPlayer("C:\Windows\Media\Windows Background.wav")
        $player.Play()
    }

    # Aguarda 5 minutos (300 segundos)
    Start-Sleep -Seconds 300
}