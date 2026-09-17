# Variables de compilación
CXX_NATIVE = g++
CXX_CROSS  = aarch64-linux-gnu-g++

# Banderas de compilación
CXXFLAGS   = -std=c++11 -ggdb3 -O0 -Wall -Wextra -pedantic

# Banderas de enlace para la Raspberry Pi:
# -static-libstdc++ y -static-libgcc evitan GLIBCXX/GLIBCCXX en la Pi,
# pero -static es el que evita la dependencia de GLIBC_2.38 del host de compilación.
LDFLAGS_RPI = -static-libstdc++ -static-libgcc -static

# Directorios del proyecto
SRC_DIR     = src
BIN_DIR     = bin
RESULTS_DIR = results

# Archivos fuente y objetivos
SRC         = $(SRC_DIR)/sensor_data_processing.cpp
TARGET_HOST = $(BIN_DIR)/sensor_host
TARGET_RPI  = $(BIN_DIR)/sensor_rpi

.PHONY: all directories clean host rpi git-sync help

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
	$(CXX_CROSS) $(CXXFLAGS) -o $@ $< $(LDFLAGS_RPI)

# Limpieza de binarios y archivos temporales
clean:
	rm -rf $(BIN_DIR)/*

# Añade todos los cambios, crea un commit con mensaje opcional y publica la rama
git-sync:
	@read -r -p "Mensaje del commit (deja vacío para no poner comentario): " commit_message; \
	git add .; \
	if git diff --cached --quiet; then \
		echo "No hay cambios para confirmar."; \
	else \
		if [ -n "$$commit_message" ]; then \
			git commit -m "$$commit_message"; \
		else \
			git commit --allow-empty-message -m ""; \
		fi && git push; \
	fi

# Ayuda rápida de uso
help:
	@echo "Opciones disponibles:"
	@echo "  make         - Compila ambas versiones (nativa y cruzada)"
	@echo "  make host    - Compila solo la versión nativa (sensor_host)"
	@echo "  make rpi     - Compila solo la versión cruzada (sensor_rpi)"
	@echo "  make clean   - Limpia los binarios generados"
	@echo "  make git-sync - Hace git add ., commit con mensaje opcional y git push"