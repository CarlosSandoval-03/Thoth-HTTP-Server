# ========================
# OS-Specific Configuration
# ========================
ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),)  # Not in a bash-like shell
    CLEANUP = del /F /Q
    MKDIR = mkdir
  else  # In a bash-like shell, like MSYS
    CLEANUP = rm -rf
    MKDIR = mkdir -p
  endif
  TARGET_EXTENSION = exe
else
  CLEANUP = rm -rf
  MKDIR = mkdir -p
  TARGET_EXTENSION = out
endif

# ========================
# Paths
# ========================
PATH_SRC     = src/
PATH_TEST    = test/
PATH_UNITY   = lib/Unity/src/
PATH_BUILD   = build/
PATH_DEPENDS = $(PATH_BUILD)depends/
PATH_OBJS    = $(PATH_BUILD)objs/
PATH_RESULTS = test_results/

BUILD_PATH_SRC = $(PATH_BUILD) $(PATH_DEPENDS) $(PATH_OBJS) $(PATH_RESULTS)

# ========================
# Source Files
# ========================
SRCT      = $(wildcard $(PATH_TEST)*.c)
SRCT_CORE = $(wildcard $(PATH_TEST)core/*.c)

# ========================
# Tools and Flags
# ========================
COMPILE = gcc -c -Wall -Werror -pedantic -std=c99 -g
LINK    = gcc
DEPEND  = gcc -MM -MG -MF
CFLAGS  = -I. -I$(PATH_UNITY) -I$(PATH_SRC) -DTEST

# ========================
# Test Output and Reporting
# ========================
RESULTS  = $(patsubst $(PATH_TEST)test_%.c,$(PATH_RESULTS)test_%.txt,$(SRCT))
RESULTS += $(patsubst $(PATH_TEST)core/test_%.c,$(PATH_RESULTS)test_%.txt,$(SRCT_CORE))

PASSED  = `grep -s PASS $(PATH_RESULTS)*.txt`
FAIL    = `grep -s FAIL $(PATH_RESULTS)*.txt`
IGNORE  = `grep -s IGNORE $(PATH_RESULTS)*.txt`

COLOUR_YELLOW = \033[0;33m
COLOUR_RED    = \033[0;31m
COLOUR_GREEN  = \033[0;32m
END_COLOUR    = \033[0m

# ========================
# Phony Targets
# ========================
.PHONY: all build test clean lint compdb check-submodules

# ========================
# Default Target
# ========================
all: check-submodules compdb lint test build

# ========================
# Build with Submodule Check
# ========================
build: $(BUILD_PATH_SRC)
	@echo "Building..."
	@echo "Done."

check-submodules:
	@if [ ! -f $(PATH_UNITY)unity.c ]; then \
		echo "Initializing Git submodules..."; \
		git submodule update --init --recursive; \
	else \
		echo "Git submodules already initialized."; \
	fi

# ========================
# Testing
# ========================
test: $(BUILD_PATH_SRC) $(RESULTS)
	@echo -e "$(COLOUR_YELLOW)"
	@echo -e "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo -e "$(COLOUR_RED)"
	@echo -e "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo -e "$(COLOUR_GREEN)"
	@echo -e "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo -e "$(END_COLOUR)"
	@echo -e "\nDONE"

$(PATH_RESULTS)%.txt: $(PATH_BUILD)%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

# ========================
# Compilation and Linking
# ========================
$(PATH_BUILD)test_%.$(TARGET_EXTENSION): $(PATH_OBJS)test_%.o $(PATH_OBJS)%.o $(PATH_OBJS)unity.o
	$(LINK) -o $@ $^

$(PATH_BUILD)test_%.$(TARGET_EXTENSION): $(PATH_OBJS)core/test_%.o $(PATH_OBJS)core/%.o $(PATH_OBJS)unity.o
	$(LINK) -o $@ $^

# ========================
# Object Compilation
# ========================
$(PATH_OBJS)%.o: $(PATH_TEST)%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_OBJS)core/%.o: $(PATH_TEST)core/%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_OBJS)%.o: $(PATH_SRC)%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_OBJS)core/%.o: $(PATH_SRC)core/%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_OBJS)%.o: $(PATH_UNITY)%.c $(PATH_UNITY)%.h
	$(COMPILE) $(CFLAGS) $< -o $@

# ========================
# Directory Creation
# ========================
$(PATH_BUILD):
	$(MKDIR) $(PATH_BUILD)

$(PATH_DEPENDS):
	$(MKDIR) $(PATH_DEPENDS)

$(PATH_OBJS):
	$(MKDIR) $(PATH_OBJS)
	$(MKDIR) $(PATH_OBJS)core/

$(PATH_RESULTS):
	$(MKDIR) $(PATH_RESULTS)

# ========================
# Linting
# ========================
lint:
	@echo "Linting..."
	@make compdb
	@find $(PATH_SRC) $(PATH_TEST) -name "*.c" -o -name "*.h" | xargs clang-format -i
	@find $(PATH_SRC) $(PATH_TEST) -name "*.c" -o -name "*.h" | xargs clang-tidy --quiet --warnings-as-errors=* --header-filter=$(PATH_SRC).* || true
	@echo "Done."

# ========================
# Compilation Database (compdb)
# ========================
compdb:
	@if [ -z "$$BEAR_EXECUTED" ]; then \
		echo "Generating compile_commands.json with bear..."; \
		bear -- make build BEAR_EXECUTED=1; \
	else \
		echo "Already under bear, skipping recursion."; \
	fi

# ========================
# Cleaning
# ========================
clean:
	@echo "Cleaning up..."
	@$(CLEANUP) $(PATH_OBJS)
	@$(CLEANUP) $(PATH_BUILD)
	@$(CLEANUP) $(PATH_RESULTS)
	@$(CLEANUP) compile_commands.json
	@echo "Done."

# ========================
# Precious Files
# ========================
.PRECIOUS: $(PATH_BUILD)test_%.$(TARGET_EXTENSION)
.PRECIOUS: $(PATH_OBJS)%.o
.PRECIOUS: $(PATH_RESULTS)%.txt
