SHELL := /bin/zsh
STOW := stow
STOW_FLAGS := --dotfiles --target=$(HOME)

PACKAGES := $(dir $(wildcard */))

.PHONY: all install uninstall list clean help

all: install

install:
	@for package in $(PACKAGES); do \
		echo "Installing $$package..."; \
		$(STOW) $(STOW_FLAGS) $$package; \
	done

uninstall:
	@for package in $(PACKAGES); do \
		echo "Uninstalling $$package..."; \
		$(STOW) -D $(STOW_FLAGS) $$package; \
	done

list:
	@echo "Available packages:"
	@for package in $(PACKAGES); do \
		echo "  - $$package"; \
	done

clean:
	@for package in $(PACKAGES); do \
		$(STOW) -D $(STOW_FLAGS) $$package 2>/dev/null || true; \
	done
