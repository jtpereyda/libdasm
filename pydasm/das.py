#!/usr/bin/python2
#
# das.py -- simple 32-bit example disassembler program
# Copyright (c) 2005       Ero Carrera Ventura <ero / dkbza.org> (Python adaptation)
# Copyright (c) 2004-2007  Jarkko Turkulainen <jt / nologin.org> <turkja / github.com>
# Copyright (c) 2009-2010  Ange Albertini <angea / github.com>
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1) Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# 2) Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

import os
from pydasm import *

def main():

    if len(os.sys.argv) < 2:
        print "Usage: %s <file> [-a|-i] [bytes]\n"              \
            "  file    file to be disassembled (required)\n"    \
            "  -a      format: ATT (optional)\n"                \
            "  -i      format: INTEL (optional, default)\n"     \
            "  bytes   show raw instruction data (optional, default 8)\n" % \
               (os.sys.argv[0])
        os.sys.exit(1)
        
    fd = file(os.sys.argv[1], 'rb')
    data = fd.read()
    fd.close()
    
    bytes = 8
    format = FORMAT_INTEL
    
    if len(os.sys.argv)>2:
        if os.sys.argv[2] == '-a':
            format = FORMAT_ATT
        elif os.sys.argv[2] == '-i':
            format = FORMAT_INTEL
        else:
            bytes = int(os.sys.argv[2])
        if len(os.sys.argv)>3:
            bytes = int(os.sys.argv[3])

    offset = 0
    while offset < len(data):
		#
		# get_instruction() has the following parameters:
		#
		# - data: data to be disassembled
		# - disassemble in 32-bit mode: MODE_32 
		#
        instruction = get_instruction(data[offset:], MODE_32)

        str = '%.8x ' % (offset)
        
        # Illegal opcode or opcode longer than remaining buffer
        if not instruction or instruction.length+offset>len(data):
            if bytes:
                str += '%.2x  ' % ord(data[offset]) + ' '*(bytes-1)*2
            if format == FORMAT_INTEL:
                str += 'db 0x%.2x' % ord(data[offset])
            else:
                str += '.byte 0x%.2x' % ord(data[offset])
            print str
            offset += 1
            continue
            
        ilen = instruction.length
        
        #
        # Print absolute offset and raw data bytes up to 'bytes'
        # (not needed, but looks nice).
        #
        if bytes:
            for i in range(min(bytes, ilen)):
                str += '%.2x' % ord(data[offset+i])
            str += '  '
            for i in range(min(bytes, ilen), bytes*2-ilen):
                str += ' '

        #
        # Print the parsed instruction, format using user-supplied
        # format. We could of course format the instruction in some
        # other way by accessing struct INSTRUCTION members directly.
        #
        str += get_instruction_string(instruction, format, offset);
        print str

        offset += ilen

if __name__ == '__main__':
    main()
