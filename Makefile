
nullstring =
foo = $(nullstring) # end of line; there is a space here
GREP_FINDINGS = $(shell grep -s pycharm  $(HOME)/.desktop)
SHELL = /usr/bin/bash

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

mizu-install:
	curl -Lo mizu https://github.com/up9inc/mizu/releases/latest/download/mizu_linux_amd64
	sudo install mizu /usr/local/bin
	# to run -- mizu tap -A

kateyes-install-k3s:
	rm -rf /tmp/kateyes
	mkdir /tmp/kateyes
	pushd /tmp/kateyes
	git clone https://github.com/nagarkarv/k8s-kateyes
	cd k8s-kateyes
	KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl apply -f install
	popd

terraform-install:
	sudo apt-get update
	sudo apt-get install -y gnupg software-properties-common curl
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb https://apt.releases.hashicorp.com jammy main"
	sudo apt-get update
	sudo apt-get install terraform
	terraform -help

sudoedit-change:
	sudo update-alternatives --config editor

vagrant-install:
	wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt update && sudo apt install -y vagrant
