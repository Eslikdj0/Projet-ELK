#!/usr/bin/env pwsh

# Script de gestion du Docker Compose
# Utilisation: .\docker-compose-manager.ps1 [action]
# Actions: start, stop, restart, status, logs

param(
    [Parameter(Position=0)]
    [ValidateSet('start', 'stop', 'restart', 'status', 'logs', 'help')]
    [string]$Action = 'help'
)

# Chemin du script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Couleurs pour l'affichage
$successColor = 'Green'
$errorColor = 'Red'
$infoColor = 'Cyan'

function Write-Status {
    param([string]$Message, [string]$Color = 'White')
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $Message" -ForegroundColor $Color
}

function Check-Docker {
    try {
        $null = docker --version
        Write-Status "Docker détecté" $successColor
        return $true
    }
    catch {
        Write-Status "Erreur: Docker n'est pas installé ou non accessible" $errorColor
        return $false
    }
}

function Start-DockerCompose {
    Write-Status "Démarrage du Docker Compose..." $infoColor
    if (Check-Docker) {
        Push-Location $scriptDir
        docker-compose up -d
        $exitCode = $LASTEXITCODE
        Pop-Location
        
        if ($exitCode -eq 0) {
            Write-Status "Docker Compose démarré avec succès" $successColor
        }
        else {
            Write-Status "Erreur lors du démarrage du Docker Compose" $errorColor
        }
        return $exitCode
    }
    return 1
}

function Stop-DockerCompose {
    Write-Status "Arrêt du Docker Compose..." $infoColor
    if (Check-Docker) {
        Push-Location $scriptDir
        docker-compose down
        $exitCode = $LASTEXITCODE
        Pop-Location
        
        if ($exitCode -eq 0) {
            Write-Status "Docker Compose arrêté avec succès" $successColor
        }
        else {
            Write-Status "Erreur lors de l'arrêt du Docker Compose" $errorColor
        }
        return $exitCode
    }
    return 1
}

function Restart-DockerCompose {
    Write-Status "Redémarrage du Docker Compose..." $infoColor
    Stop-DockerCompose
    Start-Sleep -Seconds 2
    Start-DockerCompose
}

function Get-DockerStatus {
    Write-Status "État du Docker Compose:" $infoColor
    if (Check-Docker) {
        Push-Location $scriptDir
        docker-compose ps
        Pop-Location
    }
}

function Get-DockerLogs {
    Write-Status "Affichage des logs du Docker Compose..." $infoColor
    if (Check-Docker) {
        Push-Location $scriptDir
        docker-compose logs -f
        Pop-Location
    }
}

function Show-Help {
    Write-Host @"
╔════════════════════════════════════════════════════════════════╗
║         Script de gestion du Docker Compose (ELK)              ║
╚════════════════════════════════════════════════════════════════╝

Utilisation: .\docker-compose-manager.ps1 [action]

Actions disponibles:
  start    - Démarrer les conteneurs Docker
  stop     - Arrêter les conteneurs Docker
  restart  - Redémarrer les conteneurs Docker
  status   - Afficher l'état des conteneurs
  logs     - Afficher les logs en temps réel
  help     - Afficher cette aide

Exemples:
  .\docker-compose-manager.ps1 start
  .\docker-compose-manager.ps1 stop
  .\docker-compose-manager.ps1 status

"@ -ForegroundColor $infoColor
}

# Exécution selon l'action
switch ($Action) {
    'start' { Start-DockerCompose; break }
    'stop' { Stop-DockerCompose; break }
    'restart' { Restart-DockerCompose; break }
    'status' { Get-DockerStatus; break }
    'logs' { Get-DockerLogs; break }
    'help' { Show-Help; break }
    default { Show-Help }
}
