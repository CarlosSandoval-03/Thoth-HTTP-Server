ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # not in a bash-like shell
	CLEANUP = del /F /Q
	MKDIR = mkdir
  else # in a bash-like shell, like msys
	CLEANUP = rm -f
	MKDIR = mkdir -p
  endif
	TARGET_EXTENSION=exe
else
	CLEANUP = rm -f
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
PATH_RESULTS = build/results/

BUILD_PATH_SRC = $(PATH_BUILD) $(PATH_DEPENDS) $(PATH_OBJS) $(PATH_RESULTS)

SRCT = $(wildcard $(PATH_TEST)*.c)

COMPILE=gcc -c
LINK=gcc
DEPEND=gcc -MM -MG -MF
CFLAGS=-I. -I$(PATH_UNITY) -I$(PATH_SRC) -DTEST

# Testing Related Rules
RESULTS = $(patsubst $(PATH_TEST)Test%.c,$(PATH_RESULTS)Test%.txt,$(SRCT) )

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

$(PATH_RESULTS)%.txt: $(PATH_BUILD)%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

# Build Related Rules
$(PATH_BUILD)Test%.$(TARGET_EXTENSION): $(PATH_OBJS)Test%.o $(PATH_OBJS)%.o $(PATH_OBJS)unity.o #$(PATH_DEPENDS)Test%.d
	$(LINK) -o $@ $^

# Object Related Rules
$(PATH_OBJS)%.o:: $(PATH_TEST)%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATH_OBJS)%.o:: $(PATH_SRC)%.c
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

$(PATH_RESULTS):
	$(MKDIR) $(PATH_RESULTS)

clean:
	$(CLEANUP) $(PATH_OBJS)*.o
	$(CLEANUP) $(PATH_BUILD)*.$(TARGET_EXTENSION)
	$(CLEANUP) $(PATH_RESULTS)*.txt

.PRECIOUS: $(PATH_BUILD)Test%.$(TARGET_EXTENSION)
.PRECIOUS: $(PATH_DEPENDS)%.d
.PRECIOUS: $(PATH_OBJS)%.o
.PRECIOUS: $(PATH_RESULTS)%.txt
