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

TARGET = $(LIB_DIR)/limeos-interface-lib.a

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
INSTALL_INC_DIR = $(PREFIX)/include/limeos-interface-lib
INSTALL_LIB_DIR = $(PREFIX)/lib
INSTALL_PKG_DIR = $(PREFIX)/lib/pkgconfig

install: $(TARGET)
	@mkdir -p $(INSTALL_INC_DIR)
	@mkdir -p $(INSTALL_LIB_DIR)
	@mkdir -p $(INSTALL_PKG_DIR)
	@cp -r $(SRC_DIR)/* $(INSTALL_INC_DIR)/
	@find $(INSTALL_INC_DIR) -name '*.c' -delete
	@cp $(TARGET) $(INSTALL_LIB_DIR)/
	@echo '#include <limeos-interface-lib/all.h>' > $(PREFIX)/include/limeos-interface-lib.h
	@sed 's|@PREFIX@|$(PREFIX)|g' assets/limeos-interface-lib.pc.in > $(INSTALL_PKG_DIR)/limeos-interface-lib.pc

uninstall:
	rm -rf $(INSTALL_INC_DIR)
	rm -f $(INSTALL_LIB_DIR)/limeos-interface-lib.a
	rm -f $(PREFIX)/include/limeos-interface-lib.h
	rm -f $(INSTALL_PKG_DIR)/limeos-interface-lib.pc

# ---
# Other
# ---

.PHONY: all clean install uninstall
