# Variables de compilación
CXX_NATIVE = g++
CXX_CROSS  = aarch64-linux-gnu-g++

# Banderas de compilación recomendadas por la guía (C++11, debug max, sin optimización)
CXXFLAGS   = -std=c++11 -ggdb3 -O0 -Wall -Wextra -pedantic

# Directorios del proyecto
SRC_DIR     = src
BIN_DIR     = bin
RESULTS_DIR = results

# Archivos fuente y objetivos
SRC         = $(SRC_DIR)/sensor_data_processing.cpp
TARGET_HOST = $(BIN_DIR)/sensor_host
TARGET_RPI  = $(BIN_DIR)/sensor_rpi

.PHONY: all directories clean host rpi help

# Regla por defecto: crea carpetas y compila ambas versiones
all: directories $(TARGET_HOST) $(TARGET_RPI)

# Creación de la estructura de carpetas requerida
directories:
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(RESULTS_DIR)/callgrind
	@mkdir -p $(RESULTS_DIR)/massif

# Compilación Nativa (x86_64)
host: directories $(TARGET_HOST)

$(TARGET_HOST): $(SRC)
	$(CXX_NATIVE) $(CXXFLAGS) -o $@ $<

# Compilación Cruzada (ARM64 / Raspberry Pi)
rpi: directories $(TARGET_RPI)

$(TARGET_RPI): $(SRC)
	$(CXX_CROSS) $(CXXFLAGS) -o $@ $<

# Limpieza de binarios y archivos temporales
clean:
	rm -rf $(BIN_DIR)/*

# Ayuda rápida de uso
help:
	@echo "Opciones disponibles:"
	@echo "  make         - Compila ambas versiones (nativa y cruzada)"
	@echo "  make host    - Compila solo la versión nativa (sensor_host)"
	@echo "  make rpi     - Compila solo la versión cruzada (sensor_rpi)"
	@echo "  make clean   - Limpia los binarios generados"