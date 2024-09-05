-include .env

.PHONY: hi

hi:
	@echo "Hi, $(arg)!" # make hi arg=yourname