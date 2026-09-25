# kill_doble_click.ps1
# Busca procesos python cuya línea de comandos contenga 'doble_click.py' y los termina.
# Ejecutar desde PowerShell con permisos de administrador:
#   cd "D:\Proyectos darien\mouse"
#   .\kill_doble_click.ps1

$matches = Get-CimInstance Win32_Process -Filter "Name = 'python.exe'" | Where-Object { $_.CommandLine -match 'doble_click.py' }
if ($matches.Count -eq 0) {
    Write-Output "No se encontraron procesos 'doble_click.py'."
    exit 0
}

$matches | Format-Table ProcessId,CommandLine -AutoSize

$confirm = Read-Host "¿Terminar estos procesos? (S para confirmar)"
if ($confirm -ne 'S' -and $confirm -ne 's') {
    Write-Output "Cancelado por el usuario."
    exit 1
}

foreach ($m in $matches) {
    try {
        Stop-Process -Id $m.ProcessId -Force -ErrorAction Stop
        Write-Output "Terminado PID $($m.ProcessId)"
    } catch {
        Write-Output "Fallo al terminar PID $($m.ProcessId): $($_.Exception.Message)"
    }
}

# Verificar si quedaron procesos
$remaining = Get-CimInstance Win32_Process -Filter "Name = 'python.exe'" | Where-Object { $_.CommandLine -match 'doble_click.py' }
if ($remaining.Count -eq 0) {
    Write-Output "Todos los procesos relacionados han sido terminados."
} else {
    Write-Output "Algunos procesos no pudieron terminarse (posible privilegio faltante)."
    $remaining | Format-Table ProcessId,CommandLine -AutoSize
}
