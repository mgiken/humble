prefix = ${shell arc --show-prefix}

libdir = $(DESTDIR)/$(prefix)/lib/arc/site

all:

install:
	mkdir -p $(libdir)
	cp ./lib/humble.arc $(libdir)/humble.arc
	cp -r ./lib/humble $(libdir)/

uninstall:
	rm -rf $(libdir)/humble.arc
	rm -rf $(libdir)/humble
