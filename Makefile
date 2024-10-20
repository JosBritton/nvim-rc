.SILENT:
.DEFAULT_GOAL := install

GIT_DIR := $(shell git rev-parse --git-dir)

.PHONY: clean
clean:
	(. .venv/bin/activate && pre-commit uninstall) || true
	rm -rf .venv/

.PHONY: lint
lint:
	stylua --verify --check .

.PHONY: format
format:
	stylua --verify .

.PHONY: install
install: $(GIT_DIR)/hooks/pre-commit

.venv/lock: requirements.txt
	python3 -m venv .venv/

	. .venv/bin/activate && \
	python3 -m pip install -U -r requirements.txt

	touch .venv/lock

$(GIT_DIR)/hooks/pre-commit: .pre-commit-config.yaml .venv/lock
	. .venv/bin/activate && \
	pre-commit install --hook-type pre-commit && \
	touch $(GIT_DIR)/hooks/pre-commit

.gitignore:
	touch .gitignore
