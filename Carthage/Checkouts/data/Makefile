# Makefile
#
# Targets:
#
# `make all`
# Compile all targets.
#
# `make swift`
# Compile the protobuf files for Swift only.
#
# `make clean`
# Remove compiled protobuf files for both Python and Swift.
#

SRC = ./

all: swift

swift:
	protoc --swift_opt=Visibility=Public --swift_out=Sources/CentigradeData/ $(SRC)*.proto

clean:
	find . -name '*.pb.swift' | xargs rm -f

.PHONY: all clean swift
