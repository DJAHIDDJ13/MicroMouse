# name of output program
TARGET=MM_brain

CC=gcc

# projects dirs and configuration files
BINDIR=bin
SRCDIR=src
INCDIR=include
TESTDIR=tests
OBJDIR=obj

CFLAGS=-Wall -I$(INCDIR) -lpthread -g
# getting source files and obj names
SOURCES  := $(wildcard $(SRCDIR)/*.c)
INCLUDES := $(wildcard $(INCDIR)/*.h)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
TESTS    := $(wildcard $(TESTDIR)/*.c)
TESTBINS := $(TESTS:$(TESTDIR)/%.c=$(BINDIR)/%)
TESTOBJ  := $(TESTS:$(TESTDIR)/%.c=$(OBJDIR)/%.o)

# flags to be used
LFLAGS=-lm -std=c99 -lpthread

# make main executable
$(BINDIR)/$(TARGET): $(OBJECTS) | $(BINDIR)
	$(CC) $^ $(LFLAGS) -o $@

# make obj files	$(CC) $^ $(LFLAGS) -o $@	$(CC) $^ $(LFLAGS) -o $@
$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# compile tests
test: $(TESTBINS)

$(TESTBINS): $(TESTOBJ) $(OBJECTS) | $(BINDIR)
	$(CC) $(filter-out $(OBJDIR)/main.o $(filter-out $(patsubst $(BINDIR)/%,$(OBJDIR)/%.o,$@), $(TESTOBJ)), $(OBJECTS) $(TESTOBJ)) -o $@ $(LFLAGS)

$(TESTOBJ): $(TESTS) | $(OBJDIR)
	$(CC) $(CFLAGS) -c $(patsubst $(OBJDIR)/%.o,$(TESTDIR)/%.c,$@) -o $@

# Create the directories if they don't exist
# https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
$(OBJDIR):
	mkdir -p $@

$(BINDIR):
	mkdir -p $@


.PHONY: clean
clean:
	rm -f obj/* bin/*
