
/*
 * simple.c -- very simple 32-bit example disassembler program
 * Copyright (c) 2004-2007  Jarkko Turkulainen <jt / nologin.org> <turkja / github.com>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1) Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * 2) Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * How to compile in MSVC environment:
 *   cl simple.c ../libdasm.c
 *
 * In Unix environment, use the supplied Makefile
 *
 *
 * Check out "das.c" for more featured example.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

// step 0: include libdasm
#include "../libdasm.h"


// disassembled data buffer
unsigned char data[] = "\x01\x02";

int main() {
	// step 1: declare struct INSTRUCTION
	INSTRUCTION inst;
	char string[256];

	// step 2: fetch instruction
	get_instruction(&inst, data, MODE_32);

	// step 3: print it
	get_instruction_string(&inst, FORMAT_ATT, 0, string, sizeof(string));
	printf("%s\n", string);

	return 0;
}

