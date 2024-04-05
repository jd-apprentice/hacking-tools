folder ?= mks
out_file ?= mks
route ?= ./apps

run:
	zig run $(route)/$(out_file).zig -- $(args)

build: $(route)/$(out_file).zig
	zig build-exe $(route)/$(out_file).zig -fstrip -fsingle-threaded -target x86_64-linux -O ReleaseSafe
	if [ ! -d $(route)/$(folder)/linux ]; then mkdir $(route)/$(folder)/linux; fi
	mv $(out_file) $(route)/$(folder)/linux/
	rm $(out_file).o
	cp $(route)/$(folder)/linux/$(out_file) $(route)/$(folder)/linux/$(out_file)_x86_64
	sudo mv $(route)/$(folder)/linux/$(out_file) /usr/local/bin/$(out_file)

execute: $(folder)/$(file)
	./$(folder)/$(file) $(args)