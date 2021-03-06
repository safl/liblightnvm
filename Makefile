BUILD_TYPE?=Release
BUILD_DIR?=build

#
# Traditional build commands
#

default: configure make

debug:
	$(eval BUILD_TYPE := Debug)

cmake_check:
	@cmake --version || (echo "\n** Please install 'cmake' **\n" && exit 1)

configure: cmake_check
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) ../
	@echo "Modify build configuration in '$(BUILD_DIR)'"

make:
	cd $(BUILD_DIR) && make

install:
	cd $(BUILD_DIR) && make install

clean:
	rm -r $(BUILD_DIR) || true

all: clean default install

#
# Packages (currently debian/.deb)
#
pkg:
	cd $(BUILD_DIR) && make package

pkg_install:
	sudo dpkg -i $(BUILD_DIR)/*.deb

pkg_uninstall:
	sudo apt-get --yes remove liblightnvm || true

#
# Commands useful for development
#
#
tags:
	ctags * -R
	cscope -b `find . -name '*.c'` `find . -name '*.h'`

# Invoking tests ...
test_mgmt:
	sudo nvm_test_mgmt nvme0n1 test_target dflash

test_dev:
	sudo nvm_test_dev

test_tgt:
	sudo nvm_test_tgt

test_vblock:
	sudo nvm_test_vblock nvme0n1

test_beam:
	sudo nvm_test_beam nvme0n1

# ... all of them
test: test_mgmt test_dev test_tgt test_vblock test_beam

# Invoking examples ...

ex_vblock:
	sudo lnvm create -d nvme0n1 -n nvm_ex_tgt -t dflash
	sudo nvm_ex_vblock nvm_ex_tgt
	sudo lnvm remove -n nvm_ex_tgt

ex_vblock_rw:
	sudo lnvm create -d nvme0n1 -n nvm_ex_tgt -t dflash
	sudo nvm_ex_vblock_rw nvme0n1 nvm_ex_tgt
	sudo lnvm remove -n nvm_ex_tgt

example: ex_vblock ex_vblock_rw

# ... all of them

# Removes everything, build and install package
dev: pkg_uninstall clean configure make pkg pkg_install
