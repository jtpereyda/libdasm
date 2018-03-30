
#
# Makefile for example programs
# Requires libdasm static lib (libdasm.a) 
#

CC      = gcc
CFLAGS  = -Wall -O3
BINDIR  = /usr/local/bin

all: das simple 

das: das.o
	$(CC) $(CFLAGS) -o das das.o -l dasm -L ../
simple: simple.o
	$(CC) $(CFLAGS) -o simple simple.o -l dasm -L ../
install: das
	install -p -D das $(DESTDIR)$(BINDIR)/das
clean:
	rm -f das simple *.o

