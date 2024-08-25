# teeworlds but its asmr

[![asmr janina](https://i3.ytimg.com/vi/irZzz8Ul58Q/maxresdefault.jpg)](https://www.youtube.com/watch?v=irZzz8Ul58Q)

## deps

```
# debian / ubuntu
sudo apt install nasm make
```

It requires nasm 2.16 or newer.

## build and connect to server

```bash
make
./teeworlds_asmr "connect 127.0.0.1:8303"
```

## debug

To debug syscalls you can use strace
to see args passed to kernel calls
and also see the error message the linux kernel gives you back.

```
strace ./teeworlds_asmr
```

For full on assembly debugging.
You can turn on symbols and step instruction by instruction.

```
make clean
make debug
gdb ./teeworlds_asmr
(gdb) layout asm
(gdb) set disassembly-flavor intel
(gdb) break _start
(gdb) stepi
```

After the last stepi just spam enter to "run" the program.

The gdb extension [peda](https://github.com/longld/peda) is quite helpful. It shows useful details while stepping.

## project goal

Implement enough client side teeworlds 0.7 protocol to have a headless (without graphics) client that can connect to
real teeworlds servers. Written in pure assembly without depending on any external library not even libc.

## ressources

Thanks to these blog posts and documentations. They helped a lot.

- [https://x64.syscall.sh/](https://x64.syscall.sh/)
- [http://ansonliu.com/si485-site/lec/15/lec.html](http://ansonliu.com/si485-site/lec/15/lec.html)
- [https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)
- [https://www.nasm.us/doc/nasmdoc3.html](https://www.nasm.us/doc/nasmdoc3.html)
- [http://www.egr.unlv.edu/~ed/assembly64.pdf](http://www.egr.unlv.edu/~ed/assembly64.pdf)
- [https://wiki.cdot.senecacollege.ca/wiki/X86_64_Register_and_Instruction_Quick_Start](https://wiki.cdot.senecacollege.ca/wiki/X86_64_Register_and_Instruction_Quick_Start)
- [https://www.felixcloutier.com/x86/](https://www.felixcloutier.com/x86/)
- [https://cs.lmu.edu/~ray/notes/nasmtutorial/](https://cs.lmu.edu/~ray/notes/nasmtutorial/)
- [https://web.stanford.edu/class/cs107/resources/x86-64-reference.pdf](https://web.stanford.edu/class/cs107/resources/x86-64-reference.pdf)
- [https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf](https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf)
- [https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html](https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html)
- [https://lwn.net/Articles/604287/](https://lwn.net/Articles/604287/)
