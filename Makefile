
#
# makefile for compiling libdasm and examples
#

CC     = gcc
CFLAGS = -Wall -O3 -fPIC
PREFIX = /usr/local
LIBDIR = $(PREFIX)/lib
INCDIR = $(PREFIX)/include
DESTDIR = /


all: libdasm.o
	$(CC) $(CFLAGS) -shared -fPIC -Wl,-soname,libdasm.so.1 -o libdasm.so libdasm.c
	ar rc libdasm.a libdasm.o && ranlib libdasm.a
	make -C examples
	make -C pydasm

install:
	install -p -D libdasm.so $(DESTDIR)$(LIBDIR)/libdasm.so.1.0
	ln -s "libdasm.so.1.0"   $(DESTDIR)$(LIBDIR)/libdasm.so.1
	ln -s "libdasm.so.1.0"   $(DESTDIR)$(LIBDIR)/libdasm.so
	install -d $(DESTDIR)$(INCDIR)
	install -m 644 -p libdasm.h     $(DESTDIR)$(INCDIR)/libdasm.h
	install -m 644 -p -D libdasm.a  $(DESTDIR)$(LIBDIR)/libdasm.a
	make -C examples install DESTDIR=$(DESTDIR)
	make -C pydasm   install DESTDIR=$(DESTDIR)

uninstall:
	rm -f $(DESTDIR)$(INCDIR)/libdasm.h
	rm -f $(DESTDIR)$(LIBDIR)/libdasm.a
	rm -f $(DESTDIR)$(LIBDIR)/libdasm.so.1.0 $(DESTDIR)$(LIBDIR)/libdasm.so

clean:
	rm -f libdasm.o libdasm.so libdasm.a
	make -C examples clean
	make -C pydasm clean


