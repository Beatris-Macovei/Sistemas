#!/bin/bash

while true; do
  echo "CONSOLA DE GESTION DE PROCESOS"
  echo "1) Lanzar comando en primer plano"
  echo "2) Lanzar comando en segundo plano"
  echo "3) Listar trabajos"
  echo "4) Traer un trabajo al primer plano (fg)"
  echo "5) Reanudar un trabajo en segundo plano (bg)"
  echo "6) Ejecutar un comando con nice"
  echo "7) Terminar un proceso por PID (kill)"
  echo "8) Terminar procesos por nombre (killall)"
  echo "0) Salir"
  read -p "Elige una opción: " opcion

  case $opcion in
        1)
            read -p "Introduce el comando: " cmd
            $cmd
            ;;
        2)
            read -p "Introduce el comando: " cmd
            $cmd &
            ;;
        3)
            jobs
            ;;
        4)
            read -p "Introduce el número del trabajo (%n): " job
            fg %$job
            ;;
        5)
            read -p "Introduce el número del trabajo (%n): " job
            bg %$job
            ;;
        6)
            read -p "Introduce el valor de nice (ej: -10, 10): " valor
            read -p "Introduce el comando: " cmd
            nice -n $valor $cmd &
            ;;
        7)
            read -p "Introduce el PID del proceso: " pid
            kill $pid
            ;;
        8)
            read -p "Introduce el nombre del proceso: " nombre
            killall $nombre
            ;;
        0)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida"
            ;;
    esac

    echo
done
