# SDRangel Makefile
This Makefile is written to make the process of compiling SDRangel server simpler.  It is based on the instructions at https://github.com/f4exb/sdrangel/wiki/Compile-from-source-in-Linux.  This is useful for compiling SDRangel server and platforms not supported by binary distrubutions such as 32 Bit architectures, e.g. older Raspberry PIs, older PCs and portables, or 64 bit portables with 32 bit operating systems.

By default it will compile for the RTL-SDR USB stick.  Other hardware is supported but these targets must be specified before all on the command line.  The focus is running this on Debian derivatives.
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
## Make targets
by defaul the `all` target will build with all the modules, but only for the RTL-SDR hardware.  This includes the SoapySDR for RTL-SDR.  Currently the following hardware also has additional make targets and work is on going to make the Makefile smoother to use. 

|Module/hardware|Makefile target |
|airspy||
|PlutoSDR||
|BladeRF||
|HackRF||
|LimeSDR||
|AirspyHF||
|Perseus||
|USRP||
|XTRX||

To add in specific hardware add the Makefile target from the above table and follow it with the all target.
