# ---
# Common
# ---

CC = clang
PKG_CONFIG = x11 cairo
CFLAGS = -Wall -Wextra -g -MMD -MP -fPIC $(shell pkg-config --cflags $(PKG_CONFIG))

# ---
# Build
# ---

SRC_DIR = src
OBJ_DIR = obj
LIB_DIR = lib

TARGET = $(LIB_DIR)/limeos-drawing-lib.a

SOURCES = $(shell find $(SRC_DIR) -name '*.c')
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
DEPS = $(OBJECTS:.o=.d)
-include $(DEPS)

CFLAGS += -I$(SRC_DIR)

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p $(LIB_DIR)
	ar rcs $@ $(OBJECTS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR) $(LIB_DIR)

# ---
# Installation
# ---

PREFIX ?= /usr/local
INSTALL_INC_DIR = $(PREFIX)/include/limeos-drawing-lib
INSTALL_LIB_DIR = $(PREFIX)/lib

install: $(TARGET)
	@mkdir -p $(INSTALL_INC_DIR)
	@mkdir -p $(INSTALL_LIB_DIR)
	@cp -r $(SRC_DIR)/* $(INSTALL_INC_DIR)/
	@find $(INSTALL_INC_DIR) -name '*.c' -delete
	@cp $(TARGET) $(INSTALL_LIB_DIR)/
	@echo '#include <limeos-drawing-lib/all.h>' > $(PREFIX)/include/limeos-drawing-lib.h

uninstall:
	rm -rf $(INSTALL_INC_DIR)
	rm -f $(INSTALL_LIB_DIR)/limeos-drawing-lib.a
	rm -f $(PREFIX)/include/limeos-drawing-lib.h

# ---
# Other
# ---

.PHONY: all clean install uninstall
