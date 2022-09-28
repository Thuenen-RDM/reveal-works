ifeq (${nocache}, true)
  nc = --no-cache
else
  nc =
endif

f := $(wildcard ${PWD}/index.html)

.PHONY: help
help:
	@echo ${f}
	@echo "Manages a reveal.js - presentation"
	@echo
	@echo "make init"
	@echo "  Copy an initial index.html, demo.html,"
	@echo "  (empty) 'assets' and 'dist' directories to"
	@echo "  be mounted into the container."
	@echo
	@echo "make run"
	@echo "  Start dev. webserver @ port 8000"
	@echo "  Current directory is source directory"
	@echo
	@echo "make stop"
	@echo "  Stop and remove the container"
	@echo
	@echo "make build [nocache=true]"
	@echo "  (re-builds) container"
	@echo

.PHONY: init
init:
ifeq (${f}, ${PWD}/index.html)
	@echo "Found index.html - not initializing!"
else
	@docker run -d --rm --name reveal reveal
	@docker cp reveal:/reveal.js/presentation/index.html ${PWD}
	@docker cp reveal:/reveal.js/presentation/demo.html ${PWD}
	@docker cp reveal:/reveal.js/presentation/assets ${PWD}
	@docker cp reveal:/reveal.js/presentation/dist ${PWD}
	@docker cp reveal:/reveal.js/presentation/plugin ${PWD}
	@docker kill reveal
endif

.PHONY: run
run:
	@docker run -d --rm -p 8000:8000 -p 35729:35729 -v ${PWD}:/reveal.js/presentation --name reveal reveal
	@echo "The presentation is being served at http://localhost:8000."

.PHONY: stop
stop:
	@docker kill reveal
	@echo "reveal.js container was killed."

build: Dockerfile
	@echo "(Re-)building reveal.js container."
	@docker build -t reveal ${nc} .

