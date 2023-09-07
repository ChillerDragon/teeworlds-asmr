# teeworlds but its asmr

[![asmr janina](https://i3.ytimg.com/vi/irZzz8Ul58Q/maxresdefault.jpg)](https://www.youtube.com/watch?v=irZzz8Ul58Q)

## deps

```
# debian / ubuntu
sudo apt install nasm make
```

# build

```bash
make
./teeworlds_asmr
```

## debug

```
strace ./teeworlds_asmr
```

## project goal

I want to see how far I can get. Trying to build a teeworlds 0.7 client (without graphics).
And planning to gain some asm skills along the way. Currently im looking at these ressources and copy pasting from stack overflow.

[https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)
[https://www.nasm.us/doc/nasmdoc3.html](https://www.nasm.us/doc/nasmdoc3.html)
[http://www.egr.unlv.edu/~ed/assembly64.pdf](http://www.egr.unlv.edu/~ed/assembly64.pdf)
[https://wiki.cdot.senecacollege.ca/wiki/X86_64_Register_and_Instruction_Quick_Start](https://wiki.cdot.senecacollege.ca/wiki/X86_64_Register_and_Instruction_Quick_Start)
[https://www.felixcloutier.com/x86/](https://www.felixcloutier.com/x86/)