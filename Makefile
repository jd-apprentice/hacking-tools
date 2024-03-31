file ?= main
folder ?= get_me_ports

run: $(folder)/$(file).zig
	zig run $(folder)/$(file).zig $(args)

build-linux: $(folder)/$(file).zig
	zig build-exe $(folder)/$(file).zig -fstrip -fsingle-threaded -target x86_64-linux -O ReleaseSafe
	mv $(file) $(folder)/$(file)
	rm $(file).o

build-windows: $(folder)/$(file).zig
	zig build-exe $(folder)/$(file).zig -fstrip -fsingle-threaded -target x86_64-windows -O ReleaseSafe
	mv $(file).exe $(folder)/$(file).exe
	rm $(file).exe.obj

execute: $(folder)/$(file)
	./$(folder)/$(file) $(args)