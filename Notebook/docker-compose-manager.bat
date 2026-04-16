@echo off
REM Script de gestion du Docker Compose
REM Utilisation: docker-compose-manager.bat [action]
REM Actions: start, stop, restart, status, logs

setlocal enabledelayedexpansion

set "ACTION=%1"
if "!ACTION!"=="" set "ACTION=help"

REM Obtenir le répertoire du script
set "SCRIPT_DIR=%~dp0"

REM Vérifier si docker est installé
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Docker n'est pas installé ou non accessible
    exit /b 1
)

if /i "!ACTION!"=="start" (
    echo [%date% %time%] Démarrage du Docker Compose...
    cd /d "!SCRIPT_DIR!"
    docker-compose up -d
    if errorlevel 1 (
        echo [ERREUR] Erreur lors du démarrage du Docker Compose
        exit /b 1
    ) else (
        echo [SUCCÈS] Docker Compose démarré avec succès
    )
    goto end
)

if /i "!ACTION!"=="stop" (
    echo [%date% %time%] Arrêt du Docker Compose...
    cd /d "!SCRIPT_DIR!"
    docker-compose down
    if errorlevel 1 (
        echo [ERREUR] Erreur lors de l'arrêt du Docker Compose
        exit /b 1
    ) else (
        echo [SUCCÈS] Docker Compose arrêté avec succès
    )
    goto end
)

if /i "!ACTION!"=="restart" (
    echo [%date% %time%] Redémarrage du Docker Compose...
    cd /d "!SCRIPT_DIR!"
    docker-compose down
    timeout /t 2 /nobreak
    docker-compose up -d
    echo [SUCCÈS] Docker Compose redémarré avec succès
    goto end
)

if /i "!ACTION!"=="status" (
    echo [%date% %time%] État du Docker Compose:
    cd /d "!SCRIPT_DIR!"
    docker-compose ps
    goto end
)

if /i "!ACTION!"=="logs" (
    echo [%date% %time%] Affichage des logs du Docker Compose...
    cd /d "!SCRIPT_DIR!"
    docker-compose logs -f
    goto end
)

REM Afficher l'aide
echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║    Script de gestion du Docker Compose (ELK)                   ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo Utilisation: docker-compose-manager.bat [action]
echo.
echo Actions disponibles:
echo   start    - Démarrer les conteneurs Docker
echo   stop     - Arrêter les conteneurs Docker
echo   restart  - Redémarrer les conteneurs Docker
echo   status   - Afficher l'état des conteneurs
echo   logs     - Afficher les logs en temps réel
echo   help     - Afficher cette aide
echo.
echo Exemples:
echo   docker-compose-manager.bat start
echo   docker-compose-manager.bat stop
echo   docker-compose-manager.bat status
echo.

:end
endlocal
