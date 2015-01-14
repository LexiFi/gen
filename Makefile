# OASIS_START
# DO NOT EDIT (digest: a3c674b4239234cbbe53afe090018954)

SETUP = ocaml setup.ml

build: setup.data
	$(SETUP) -build $(BUILDFLAGS)

doc: setup.data build
	$(SETUP) -doc $(DOCFLAGS)

test: setup.data build
	$(SETUP) -test $(TESTFLAGS)

all:
	$(SETUP) -all $(ALLFLAGS)

install: setup.data
	$(SETUP) -install $(INSTALLFLAGS)

uninstall: setup.data
	$(SETUP) -uninstall $(UNINSTALLFLAGS)

reinstall: setup.data
	$(SETUP) -reinstall $(REINSTALLFLAGS)

clean:
	$(SETUP) -clean $(CLEANFLAGS)

distclean:
	$(SETUP) -distclean $(DISTCLEANFLAGS)

setup.data:
	$(SETUP) -configure $(CONFIGUREFLAGS)

configure:
	$(SETUP) -configure $(CONFIGUREFLAGS)

.PHONY: build doc test all install uninstall reinstall clean distclean configure

# OASIS_STOP

push_doc: all doc
	scp -r gen.docdir/* cedeela.fr:~/simon/root/software/gen/

qtest-gen:
	mkdir -p qtest
	qtest extract gen.ml > qtest/run_qtest.ml || true

test-all:
	./run_tests.native
	./run_qtest.native

VERSION=$(shell awk '/^Version:/ {print $$2}' _oasis)

update_next_tag:
	@echo "update version to $(VERSION)..."
	sed -i "s/NEXT_VERSION/$(VERSION)/g" *.ml *.mli
	sed -i "s/NEXT_RELEASE/$(VERSION)/g" *.ml *.mli

NAME_VERSION := gen.$(VERSION)
URL := https://github.com/c-cube/gen/archive/$(VERSION).tar.gz

release:
	git tag -a $(VERSION) -m "Version $(VERSION)."
	git push origin $(VERSION)
	opam publish prepare $(NAME_VERSION) $(URL)
	cp descr $(NAME_VERSION)
	echo "submit?"
	@read
	opam publish submit $(NAME_VERSION)

.PHONY: update_next_tag release
