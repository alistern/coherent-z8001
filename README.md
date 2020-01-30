# coherent-z8001
reconstruction of Coherent for Z8001 processor
After getting CPM-8000 running in an emulator I thought it was time to get a real operating system working on some old hardware. A Z8000 S100 system was an itch left unscratched from the 1980's, it's time to fix that. I got a couple of Z8002 a few years back but never really settled on a memory management design. I recently got a a couple of Z8001 CPUs and a couple of Z8010 MMUs so now out of excuses, time to start. I've had some success porting UNIX v7 in the emulator but with a tip from Udo Monk I think that Coherent may be a better choice. I picked up the Mark Williams repository from  http://www.nesssoftware.com/home/mwc/source.php and some disk images etc. from zimmers.net/anonftp/pub/cbm/firmware/computers/c900/.

I've reworked DDT from CPM-8000 to work natively on Linux and load the .out format of the coherent os executable, including the symbol table. From the dissassembled source and some guidance from the Intel chip base developement from the Wark Williams repositiory it is possible to reconstruct the C code.

Header files
Most of the required header files were in the disk images however these are user land headers and the lower level kernel headers are missing. Some of the missing headers can use the Intel headers as a template others have to be reconstructed from the code.

Source Files
The version of Coherent for the Z8001 is earlier than the Intel code. The initial build will be faithful to the Z8001 code with the exception of the device drivers that will have to be compatible with my S100 system.

Commit policy will be to commit files when there is reasonable confidence that they are a good reconstruction. Also need to work out a sensible directory structure.

Tools
Currently using Gmake  z8kgcc-jan-19-2009 and eclipse, this may change. Once it is all working I hope to be able to develope natively in coherent.
