# ResizeSwapfile
Resize the Zram swapfile on the Jetson Nano

<h1>Work in Progress!</h1>

Starting with L4T 32.2.1/JetPack 4.2.2, the Jetson Nano by default has a 2GB swapfile. The swapfile allows for "extra memory" when there is memory pressure on main (physical) memory by swapping portions of memory to disk. Because the Jetson Nano has a relatively small amount of memory (4GB) this can be very useful, especially when say compiling large projects.

The swapfile method in use is Zram. You can examine the swapfile information:
<blockquote>
$ zramctl</blockquote>

You will notice that there are four entries (one for each CPU of the Jetson Nano) /dev/zram0 - /dev/zram3. Each entry has an allocated amount of swap file memory associated with it, by default 494.6M, for a total of around 2GB. This is half the size of the main memory. You will find this to be adequate for most tasks.

However, there are times ...

The configuration for the Zram allocation is done on startup. The file that controls this is /etc/systemd/nvzramconfig.sh

The size of the Zram for each CPU is calculated by the line:
<blockquote>
mem=$((("${totalmem}" / 2 / "${NRDEVICES}") * 1024))
</blockquote>

where totalmem is the total amount of memory, and NRDEVICES is the number of CPUs.

Basically it divides the amount of physical memory by the number of CPUS with a divisor, in this case 2 to get the 2GB total.
Note that you can simply edit this equation using a text editor. You should probably make a backup first, just in case.
<blockquote>
sudo gedit /etc/systemd/nvzramconfig.sh
</blockquote>

For example, you may remove the divisor to get a full 4GB.

You can also use the script in the repository.
<blockquote>
usage: ./setSwapFileSize [ [-g #gigabytes ] | [ -m #megabytes ] | [ -h ]<br>
  -g #gigabytes - #gigabytes total to use for swap area<br>
  -m #megabytes - #megabytes total to use for swap area<br>
  -h            - help
<br>  
</blockquote>

Example usage:<br>
<blockquote>
<br>  
$ ./setSwapFileSize -g 4<br>
<br></blockquote>

will set the entire swapfile size to 4GB.

This will modify the /etc/systemd/nvzramconfig.sh to set the requested memory for the swap file as specified.

You will need to reboot for the change to take effect.

<h3>Notes</h3>
<b>November 2019</b>
Initial Release
* Jetson Nano
* L4T 32.2.1/JetPack 4.2.2




