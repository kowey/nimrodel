.PHONY: dist

TCAPP=nimrodel
TODAY=$(shell date +%Y-%m-%d)
VERSION=0.1-$(TODAY)
TARBALL=$(TCAPP)-$(VERSION).tar.bz2

dist:
	rm -f $(TARBALL)
	cd ..; tar czvf $(TCAPP)/$(TARBALL) --exclude="$(TCAPP)/.git/*" $(TCAPP)
