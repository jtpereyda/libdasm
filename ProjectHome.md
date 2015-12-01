This was an up-to-date [libdasm](http://www.nologin.org/main.pl?action=codeView&codeId=49) fork, but I never got the time.

If you're looking for a good and open disassembly engine, you should check [Capstone](http://www.capstone-engine.org/)

It's **public domain**.

### updates ###
added opcodes :
  * 0xf6-0xf7 group 3 xx001xxx test
  * 0xc0-0xc1 group 2 xx110xxx sal

fixes :
  * 0xd9 0xd0-0xff fpu
  * 0x8c mov segment register
  * 0x0f 0xb6-0xb7 movzx

### test ###
```
libdasm\examples>das test32.bin
00000000  d9e0              fchs
00000002  d9e1              fabs
00000004  90                nop
00000005  f60000            test byte [eax],0x0
00000008  f60800            test byte [eax],0x0
0000000b  f70000000000      test dword [eax],0x0
00000011  f70800000000      test dword [eax],0x0
00000017  90                nop
00000018  8c00              mov [eax],es
0000001a  90                nop
0000001b  0fb700            movzx eax,[eax]
0000001e  0fb600            movzx eax,[eax]
00000021  0fb68000000000    movzx eax,[eax+0x0]
00000028  90                nop
00000029  c03000            sal byte [eax],0x0
0000002c  c13000            sal dword [eax],0x0
0000002f  90                nop
...
```

### credits and links ###
thanks to :
  * Georg Wicherski
  * Silvio Cesare
  * Ero Carrera
  * BeatriX
and of course, jt, the original author of libdasm.

other disassembly engines:
  * [Distorm64](http://www.ragestorm.net/distorm/)
  * [BeaEngine](http://beatrix2004.free.fr/BeaEngine/index1.php)
  * [libdisasm](http://bastard.sourceforge.net/libdisasm.html)
  * [Hacker Disassembler Engine](http://vx.netlux.org/vx.php?id=eh04)
  * [libdisassemble](http://www.immunitysec.com/resources-freesoftware.shtml)
  * [Udis86](http://udis86.sourceforge.net/)

documentation:
  * [Intel](http://www.intel.com/products/processor/manuals/)
  * [AMD](http://developer.amd.com/documentation/guides/pages/default.aspx)
  * [Sandpile.org](http://sandpile.org)
  * [x86 instruction reference](http://ref.x86asm.net/)