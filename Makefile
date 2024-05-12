ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # not in a bash-like shell
	CLEANUP = del /F /Q
	MKDIR = mkdir
  else # in a bash-like shell, like msys
	CLEANUP = rm -rf
	MKDIR = mkdir -p
  endif
	TARGET_EXTENSION=exe
else
	CLEANUP = rm -rf
	MKDIR = mkdir -p
	TARGET_EXTENSION=out
endif

.PHONY: clean
.PHONY: test

PATH_UNITY = lib/Unity/src/
PATH_SRC = src/
PATH_TEST = test/
PATH_BUILD = build/
PATH_DEPENDS = build/depends/
PATH_OBJS = build/objs/
PATH_RESULTS = test_results/

BUILD_PATH_SRC = $(PATH_BUILD) $(PATH_DEPENDS) $(PATH_OBJS) $(PATH_RESULTS)

SRCT = $(wildcard $(PATH_TEST)*.c)
SRCT_CORE = $(wildcard $(PATH_TEST)core/*.c)

COMPILE=gcc -c -Wall -Werror -pedantic -std=c99	-g
LINK=gcc
DEPEND=gcc -MM -MG -MF
CFLAGS=-I. -I$(PATH_UNITY) -I$(PATH_SRC) -DTEST

# Testing Related Rules
RESULTS = $(patsubst $(PATH_TEST)test_%.c,$(PATH_RESULTS)test_%.txt,$(SRCT))
RESULTS += $(patsubst $(PATH_TEST)core/test_%.c,$(PATH_RESULTS)test_%.txt,$(SRCT_CORE))

PASSED = `grep -s PASS $(PATH_RESULTS)*.txt`
FAIL = `grep -s FAIL $(PATH_RESULTS)*.txt`
IGNORE = `grep -s IGNORE $(PATH_RESULTS)*.txt`

COLOUR_YELLOW=\033[0;33m
COLOUR_RED=\033[0;31m
COLOUR_GREEN=\033[0;32m
END_COLOUR=\033[0m

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

build: $(BUILD_PATH_SRC)
	@echo "Building..."
	
	@echo "Done."

$(PATH_RESULTS)%.txt: $(PATH_BUILD)%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

# Build Related Rules
$(PATH_BUILD)test_%.$(TARGET_EXTENSION): $(PATH_OBJS)test_%.o $(PATH_OBJS)%.o $(PATH_OBJS)unity.o #$(PATH_DEPENDS)test_%.d
	$(LINK) -o $@ $^
$(PATH_BUILD)test_%.$(TARGET_EXTENSION): $(PATH_OBJS)core/test_%.o $(PATH_OBJS)core/%.o $(PATH_OBJS)unity.o #$(PATH_DEPENDS)core/test_%.d
	$(LINK) -o $@ $^

# Object Related Rules
$(PATH_OBJS)%.o:: $(PATH_TEST)%.c
	$(COMPILE) $(CFLAGS) $< -o $@
$(PATH_OBJS)core/%.o:: $(PATH_TEST)core/%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_OBJS)%.o:: $(PATH_SRC)%.c
	$(COMPILE) $(CFLAGS) $< -o $@
$(PATH_OBJS)core/%.o:: $(PATH_SRC)core/%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_OBJS)%.o:: $(PATH_UNITY)%.c $(PATH_UNITY)%.h
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_DEPENDS)%.d:: $(PATH_TEST)%.c
	$(DEPEND) $@ $<

$(PATH_BUILD):
	$(MKDIR) $(PATH_BUILD)

$(PATH_DEPENDS):
	$(MKDIR) $(PATH_DEPENDS)

$(PATH_OBJS):
	$(MKDIR) $(PATH_OBJS)
	$(MKDIR) $(PATH_OBJS)core/

$(PATH_RESULTS):
	$(MKDIR) $(PATH_RESULTS)

clean:
	@echo "Cleaning up..."
	@$(CLEANUP) $(PATH_OBJS)
	@$(CLEANUP) $(PATH_BUILD)
	@$(CLEANUP) $(PATH_RESULTS)
	@echo "Done."


.PRECIOUS: $(PATH_BUILD)Test%.$(TARGET_EXTENSION)
.PRECIOUS: $(PATH_DEPENDS)%.d
.PRECIOUS: $(PATH_OBJS)%.o
.PRECIOUS: $(PATH_RESULTS)%.txt
