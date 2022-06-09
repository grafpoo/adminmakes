
nullstring =
foo = $(nullstring) # end of line; there is a space here
GREP_FINDINGS = $(shell grep -s pycharm  $(HOME)/.desktop)

.ONESHELL:

define desktoptmpl =
[Desktop Entry]
  Name=<NAME OF THE APPLICATION>
  Comment=<A SHORT DESCRIPTION>
  Exec=<COMMAND-OR-FULL-PATH-TO-LAUNCH-THE-APPLICATION>
  Type=Application
  Terminal=false
  Icon=<ICON NAME OR PATH TO ICON>
  NoDisplay=false
endef
export dts = $(value desktoptmpl)

desktop-exists:
	@touch $(HOME)/.desktop

pycharm-menu: desktop-exists
ifeq ($(strip $(GREP_FINDINGS)),)
	@echo $$dts >> /tmp/eggs
	cat >> $(HOME)/pycharm.desktop <<EOF

		[Desktop Entry]
		Name=Pycharm
		Comment=Python IDE
		Exec=$(HOME)/pycharm/pycharm.sh
		Type=Application
		Terminal=false
		Icon=$(HOME)/pycharm/pycharm.png
		NoDisplay=false

	EOF
else
	@echo Pycharm menu already defined
endif
