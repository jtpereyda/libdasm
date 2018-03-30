DESTDIR=/
BINDIR=/usr/local/bin

all:
	python setup.py build

install:
	python setup.py install --skip-build --root $(DESTDIR)
	install -m 755 -p -D das.py $(DESTDIR)$(BINDIR)/das.py
