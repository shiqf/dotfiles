env:
	bash envInstall.sh

cmd:
	bash install.sh cmds

gui:
	bash install.sh guis

npm:
	bash install.sh npms

pip:
	bash install.sh pips

all: cmd gui npm pip

uninstall:
	bash uninstall.sh

