# cmix — Tony's cmus configuration, plus the machinery to build his
# patched cmus (github.com/tonyfischetti/cmus, default branch — the
# goodies/ patch file is the same changes, kept for reference against
# upstream 600fa4bbde / v2.9.1).
#
#   make deps      build dependencies (sudo apt build-dep; linux)
#   make setup     idempotent: ~/music, patched cmus if missing (linux)
#   make cmus      force a (re)build of the patched cmus
#   make doctor    check the install and report, loud + colorful
#
# This repo must live at ~/cmus: zix's .zshrc exports CMUS_HOME=$HOME/cmus
# and cmus reads its config from there.  Cloning it IS the config
# install — no symlinks.
#
# NB: written to run on the macOS system make (GNU Make 3.81) as well
# as Debian's — so no .ONESHELL.

SHELL := /bin/bash

CMIX      := $(CURDIR)
UNAME_S   := $(shell uname -s)
CMUS_REPO := https://github.com/tonyfischetti/cmus
BUILD_DIR := /tmp/cmix-cmus-build

# the patched build installs here; presence = "already done"
CMUS_BIN := /usr/local/bin/cmus

.PHONY: help deps setup cmus doctor

help:
	@echo "cmix setup — targets:"
	@echo "  make deps      build dependencies (sudo; linux)"
	@echo "  make setup     ensure ~/music + build patched cmus if missing"
	@echo "  make cmus      force a (re)build of the patched cmus"
	@echo "  make doctor    check the install and report"

# ---- build dependencies ---------------------------------------------- #
# `apt build-dep cmus` needs the deb-src lines in sources.list (risa's
# etc.apt.sources.list has them).
deps:
ifeq ($(UNAME_S),Darwin)
	brew install pkg-config ffmpeg flac libvorbis opusfile mad faad2 libcue
else
	sudo apt-get update -qq -o Acquire::Retries=3
	sudo apt-get install -qq -y -o Acquire::Retries=3 git build-essential
	sudo apt build-dep -y cmus
endif

# ---- full install ---------------------------------------------------- #
setup:
	mkdir -p $(HOME)/music
	@if [ -x "$(CMUS_BIN)" ]; then \
	  echo "patched cmus already installed at $(CMUS_BIN) ('make cmus' to rebuild)"; \
	else \
	  $(MAKE) cmus; \
	fi
	@echo "setup complete — run 'make doctor' to verify."

cmus:
	rm -rf $(BUILD_DIR)
	git clone -q --depth 1 $(CMUS_REPO) $(BUILD_DIR)
	cd $(BUILD_DIR) && ./configure && $(MAKE)
	cd $(BUILD_DIR) && sudo $(MAKE) install
	rm -rf $(BUILD_DIR)

# ---- doctor: report, never mutate ------------------------------------ #
doctor:
	@bash $(CMIX)/doctor.sh
