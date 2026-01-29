#!/bin/bash

# ==============================
# Comprobación de ejecución como root
# ==============================
if [ "$EUID" -ne 0 ]; then
    echo "El script no se está ejecutando como root. Relanzando con sudo..."
    sudo "$0" "$@"
    exit 0
fi

# ==============================
# Comprobar si lshw está instalado
# ==============================
if ! command -v lshw >/dev/null 2>&1; then
    echo "lshw no está instalado."
    echo "Instálalo para poder generar el informe de hardware."
    exit 0
fi

# ==============================
# Limpiar pantalla
# ==============================
clear

# ==============================
# Mostrar últimas 15 órdenes
# ==============================
echo "Últimas 15 órdenes ejecutadas:"
echo "-------------------------------"
history | tail -n 15
echo
sleep 2

# ==============================
# Crear carpeta informes
# ==============================
mkdir -p informes

# ==============================
# Generar informe de hardware
# ==============================
INFORME="informes/hardware_$(date +%F_%H-%M-%S).txt"
echo "Generando informe de hardware con lshw..."
lshw > "$INFORME"

# ==============================
# Comprimir carpeta informes
# ==============================
ARCHIVO="informes.tar.gz"
echo "Comprimiendo carpeta informes..."
tar -czf "$ARCHIVO" informes

# ==============================
# Mostrar tamaño del archivo comprimido
# ==============================
echo
echo "Tamaño del archivo comprimido:"
du -h "$ARCHIVO"

# ==============================
# Comprobar integridad del archivo tar.gz
# ==============================
echo
echo "Comprobando integridad del archivo..."
if tar -tzf "$ARCHIVO" >/dev/null 2>&1; then
    echo "El archivo $ARCHIVO no está corrupto."
else
    echo "Error: el archivo $ARCHIVO está corrupto."
    exit 1
fi

# ==============================
# Preguntar si se desea apagar el equipo
# ==============================
echo
read -p "¿Quieres apagar el equipo? (s/n): " respuesta

if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
    echo "Apagando el equipo..."
    shutdown now
else
    echo "Finalizando el script de forma normal."
fi
