# SDRangel Makefile
This Makefile is written to make the process of compiling SDRangel server simpler.  It is based on the instructions at https://github.com/f4exb/sdrangel/wiki/Compile-from-source-in-Linux.  This is useful for compiling SDRangel server on distrubutions for which the server is not supplied with in packages and on platforms not supported by binary distrubutions such as 32 Bit architectures, e.g. older Raspberry PIs, older PCs and portables, or 64 bit machines with 32 bit operating systems.

By default it will compile for the RTL-SDR USB stick both server and gui.  Other hardware is supported but these targets must be specified before all on the command line.  The focus is running this on Debian derivatives.
## Use
To use the file clone the repro:

    cd /opt
    git clone https://github.com/rob-bannocks/SDRangel-Makefile.git
   
Then rename the `SDRangel-Makefile` directory to `build`:

    mv SDRangel-Makefile build

Now change directory into build and run the make file:

    cd build
    make
You will need make installed and a C and C++ compiler.  

For install on PI Zero (not PI Zero 2) you will likely need to add additional swap space.  This can be done as the root user as follows: 
   
    fallocate -l 1G /swapfile2
    chmod 600 /swapfile2
    mkswap /swapfile2
    swapon /swapfile2

or as describer here: https://chargedwarrior.com/how-to-increase-memory-on-raspberry-pi-increase-swap-size/?utm_content=cmp-true.
## Make targets
by defaul the `all` target will build with all the modules, but only for the RTL-SDR hardware.  This includes the SoapySDR for RTL-SDR.  Currently the following hardware also has additional make targets and work is on going to make the Makefile smoother to use. 

|Module/hardware|Makefile target|Comment|
|--|--|--|
|GUI|gui|Build only the GUI not the server|
|Server|server|Only build the server|
|all|all|build both server and GUI (the default) for RTL-SDR hardware only|
|all hardware|all-all|build both server and GUI (the default) for all hardware|
|AirSpy|airspy||
|Pluto SDR|PlutoSDR||
|Blade RF (all versions)|BladeRF||
|Hack RF|HackRF||
|LimeSDR|LimeSDR||
|Airspy HF|AirspyHF||
|Perseus|Perseus||
|USRP|USRP||
|XTRX|XTRX||

To add in specific hardware add the Makefile target from the above table and follow it with the all target. E.g.:
	make LimeSDR server

At present the make file is a work in progress, it work on a PI Zero, but the compile takes over a day.  It is in testing on Ubuntu, but the Makefile canot overcome issues with the compilability of SDRangel on different platforms.
