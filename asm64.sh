#!/bin/bash
# ------------------------------------------------------
# x86-64 ASM in OSX
# This script takes care of assembling, linking, and running
# To use: call "./asm64.sh [filename]"
# Do NOT include file extension! This was done for the sake of brevity.
# If you get a "permission denied" error, run "chmod 777 asm64.sh" to fix permissions.
# ------------------------------------------------------

function error_exit
{
	echo "$1"
	exit 1
}

function helpme
{
	echo "usage: filename (no extension)"
	exit 0
}

function run
{
	nasm -f macho64 ${OUTFILE}.asm
	if [ "$?" = "1" ]; then
		error_exit "--- nasm fails. exiting."
	fi
	ld -macosx_version_min 10.6 ${OUTFILE}.o
	if [ "$?" = "1" ]; then
		error_exit "--- linking fails. exiting."
	fi
	./a.out
	if [ "$?" = "1" ]; then
		error_exit "--- final run call fails. exiting."
	fi
	echo "-------------------------------"
	exit 0
}

echo "--- x86_64 assembly on OSX using NASM"
if [ "$1" = "-h" ]; then
	helpme
else
	OUTFILE="$1"

	# let ARGS = $# - 1
	echo "--- running on ${OUTFILE}.asm..."
	echo "-------------------------------"
	run
fi