file ?= main
folder ?= get_me_ports
out_file ?= get-me-ports

run: $(folder)/$(file).zig
	zig run $(folder)/$(file).zig $(args)

build-all:
	zig build-exe $(folder)/$(file).zig -fstrip -fsingle-threaded -target x86_64-linux -O ReleaseSafe

build-linux: $(folder)/$(file).zig
	zig build-exe $(folder)/$(file).zig -fstrip -fsingle-threaded -target x86_64-linux -O ReleaseSafe
	if [ ! -d $(folder)/linux ]; then mkdir $(folder)/linux; fi
	mv $(file) $(folder)/linux/
	rm $(file).o
	cp $(folder)/linux/$(file) $(folder)/linux/$(out_file)
	sudo mv $(folder)/linux/$(file) /usr/local/bin/$(out_file)

build-windows: $(folder)/$(file).zig
	zig build-exe $(folder)/$(file).zig -fstrip -fsingle-threaded -target x86_64-windows -O ReleaseSafe
	if [ ! -d $(folder)/windows ]; then mkdir $(folder)/windows; fi
	mv $(file).exe $(folder)/windows/
	cp $(folder)/windows/$(file).exe $(folder)/windows/$(out_file).exe
	rm $(file).exe.obj
	rm $(folder)/windows/$(file).exe

execute: $(folder)/$(file)
	./$(folder)/$(file) $(args)