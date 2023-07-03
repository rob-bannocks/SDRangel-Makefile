nproc=1
BUILDROOT=/opt/build
INSTALLROOT=/opt/install
USER=robert
# common: setup APT CM256cc LibDAB MBElib SerialDV DSDcc FreeDV SGP4 LibSigMF RTL-SDR SoapySDR-RTL-SDR
common: setup APT CM256cc LibDAB MBElib SerialDV DSDcc FreeDV SGP4 LibSigMF RTL-SDR
common-all-all: airspy PlutoSDR BladeRF LimeSDR AirspyHF Perseus USRP XTRX
all: common SDRangel
gui: common SDRangel-gui
srv: common SDRangel-srv
all-all-hardware: common common-all-all SDRangel LimeSDR-tidy
gui-all-hardware: common common-all-all SDRangel-gui LimeSDR-tidy
srv-all-hardware: common common-all-all SDRangel-srv LimeSDR-tidy

setup:
	sudo mkdir -p /opt/build && sudo chown $(USER). /opt/build && sudo mkdir -p $(INSTALLROOT) && sudo chown $(USER). $(INSTALLROOT) && sudo apt-get install cmake 

APT: aptdec
	cd $(BUILDROOT)/aptdec && git checkout libaptdec && git submodule update --init --recursive && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/aptdec .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf aptdec

aptdec:
	sudo apt-get install libsndfile-dev -y
	cd $(BUILDROOT) && git clone https://github.com/srcejon/aptdec.git 

CM256cc: cm256cc
	cd $(BUILDROOT) && cd cm256cc && git reset --hard c0e92b92aca3d1d36c990b642b937c64d363c559 && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/cm256cc .. && make -j $(nproc) && cd $(BUILDROOT) && rm -rf cm256cc

#	cd $(BUILDROOT) && cd cm256cc && git reset --hard c0e92b92aca3d1d36c990b642b937c64d363c559 && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/cm256cc .. && make -j $(nproc) install

cm256cc:
	cd $(BUILDROOT) && git clone https://github.com/f4exb/cm256cc.git

LibDAB: dab-cmdline
	cd $(BUILDROOT) && cd dab-cmdline/library && git checkout msvc && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libdab .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf dab-cmdline

dab-cmdline:
	cd $(BUILDROOT) && git clone https://github.com/srcejon/dab-cmdline

MBElib: mbelib
	cd $(BUILDROOT) && cd mbelib && git reset --hard 9a04ed5c78176a9965f3d43f7aa1b1f5330e771f && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/mbelib .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf mbelib

mbelib:
	cd $(BUILDROOT) && git clone https://github.com/szechyjs/mbelib.git

SerialDV:
	cd $(BUILDROOT) && git clone https://github.com/f4exb/serialDV.git && cd serialDV && git reset --hard "v1.1.4" && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/serialdv .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf serialDV

DSDcc:
	cd $(BUILDROOT) && git clone https://github.com/f4exb/dsdcc.git && cd dsdcc && git reset --hard "v1.9.3" && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/dsdcc -DUSE_MBELIB=ON -DLIBMBE_INCLUDE_DIR=$(INSTALLROOT)/mbelib/include -DLIBMBE_LIBRARY=$(INSTALLROOT)/mbelib/lib/libmbe.so -DLIBSERIALDV_INCLUDE_DIR=$(INSTALLROOT)/serialdv/include/serialdv -DLIBSERIALDV_LIBRARY=$(INSTALLROOT)/serialdv/lib/libserialdv.so .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf dsdcc


FreeDV Codec2: codec2
	sudo apt-get -y install libspeexdsp-dev libsamplerate0-dev -y
	cd $(BUILDROOT) && cd codec2 && git reset --hard 76a20416d715ee06f8b36a9953506876689a3bd2 && mkdir -p build_linux && cd build_linux && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/codec2 .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf codec2

codec2:
	cd $(BUILDROOT) && git clone https://github.com/drowe67/codec2.git

SGP4: sgp4
	cd $(BUILDROOT) && cd sgp4 && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/sgp4 .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf sgp4

sgp4:
	cd $(BUILDROOT) && git clone https://github.com/dnwrnr/sgp4.git

LibSigMF: libsigmf
	cd $(BUILDROOT) && cd libsigmf && git checkout "new-namespaces" && mkdir -p build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libsigmf .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf libsigmf

libsigmf:
	cd $(BUILDROOT) && git clone https://github.com/f4exb/libsigmf.git

RTL-SDR: librtlsdr
	cd $(BUILDROOT) && cd librtlsdr && git reset --hard be1d1206bfb6e6c41f7d91b20b77e20f929fa6a7 && mkdir -p build && cd build && cmake -Wno-dev -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/librtlsdr .. && make -j $(nproc) install&& cd $(BUILDROOT) && rm -rf librtlsdr

librtlsdr:
	cd $(BUILDROOT) && git clone https://github.com/osmocom/rtl-sdr.git librtlsdr

SoapySDR:
	cd $(BUILDROOT) && git clone https://github.com/pothosware/SoapySDR.git

soapy-SDR: SoapySDR-RTL-SDR SoapySDR
	 cd $(BUILDROOT) && cd SoapySDR && git reset --hard "soapy-sdr-0.7.1" && mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/SoapySDR .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf SoapySDR  && cd $(BUILDROOT) && rm -rf SoapySDR

SoapySDR-RTL-SDR: SoapyRTLSDR-git
	cd $(BUILDROOT) && cd SoapyRTLSDR && mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/SoapySDR -DRTLSDR_INCLUDE_DIR=$(INSTALLROOT)/librtlsdr/include -DRTLSDR_LIBRARY=$(INSTALLROOT)/librtlsdr/lib/librtlsdr.so -DSOAPY_SDR_INCLUDE_DIR=$(INSTALLROOT)/SoapySDR/include -DSOAPY_SDR_LIBRARY=$(INSTALLROOT)/SoapySDR/lib/libSoapySDR.so .. && make -j $(nproc) install
#	&& cd $(BUILDROOT) && rm -rf SoapyRTLSDR

SoapyRTLSDR-git:
	cd $(BUILDROOT) && git clone https://github.com/pothosware/SoapyRTLSDR.git

$(INSTALLROOT)/libhackrf: HackRF

Soapy-HackRF: $(INSTALLROOT)/libhackrf
	cd $(BUILDROOT) && git clone https://github.com/pothosware/SoapyHackRF.git && cd SoapyHackRF && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/SoapySDR -DLIBHACKRF_INCLUDE_DIR=$(INSTALLROOT)/libhackrf/include/libhackrf -DLIBHACKRF_LIBRARY=$(INSTALLROOT)/libhackrf/lib/libhackrf.so -DSOAPY_SDR_INCLUDE_DIR=$(INSTALLROOT)/SoapySDR/include -DSOAPY_SDR_LIBRARY=$(INSTALLROOT)/SoapySDR/lib/libSoapySDR.so .. && make -j $(nproc) install  && cd $(BUILDROOT) && rm -rf SoapyHackRF

Soapy-LimeSDR: $(BUILDROOT)/LimeSuite
	cd $(BUILDROOT) && cd LimeSuite/builddir && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/LimeSuite -DCMAKE_PREFIX_PATH=/opt/install/SoapySDR .. && make -j $(nproc) install && cp /opt/install/LimeSuite/lib/SoapySDR/modules0.7/libLMS7Support.so /opt/install/SoapySDR/lib/SoapySDR/modules0.7 && cd $(BUILDROOT) && rm -rf LimeSuite

airspy:
	cd $(BUILDROOT) && git clone https://github.com/airspy/airspyone_host.git libairspy && cd libairspy && git reset --hard 37c768ce9997b32e7328eb48972a7fda0a1f8554 && mkdir build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libairspy .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf libairspy

SDRplay-RSP1:
	cd $(BUILDROOT) && git clone https://github.com/f4exb/libmirisdr-4.git && cd libmirisdr-4 && mkdir build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libmirisdr .. && make -j $(nproc) install

SDRplayV3API:
	cd $(BUILDROOT) && git clone https://github.com/srcejon/sdrplayapi.git && cd sdrplayapi && sudo ./install_lib.sh

PlutoSDR:
	cd $(BUILDROOT) && cd /opt/build && git clone https://github.com/analogdevicesinc/libiio.git && cd libiio && git reset --hard v0.21 && mkdir build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libiio -DINSTALL_UDEV_RULE=OFF .. && make -j $(nproc) install && rm -rf libiio

BladeRF:
	cd $(BUILDROOT) && git clone https://github.com/Nuand/bladeRF.git && cd bladeRF/host && git reset --hard "2023.02" && mkdir build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libbladeRF -DINSTALL_UDEV_RULES=OFF .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf bladeRF

HackRF:
	cd $(BUILDROOT) && git clone https://github.com/greatscottgadgets/hackrf.git && cd hackrf/host && git reset --hard "v2022.09.1" && mkdir build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libhackrf -DINSTALL_UDEV_RULES=OFF .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf hackrf

LimeSDR: $(INSTALLROOT)/LimeSuite
	LimeSDR-compile LimeSDR-install

$(BUILDROOT)/LimeSuite: LimeSDR-compile

LimeSDR-compile:
	cd $(BUILDROOT) && git clone https://github.com/myriadrf/LimeSuite.git && cd LimeSuite && git reset --hard "v20.01.0" && mkdir builddir && cd builddir && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/LimeSuite ..

LimeSDR-install: LimeSDR-compile
	cd $(BUILDROOT) && cd LimeSuite && make -j $(nproc) install

LimeSDR-tidy:
	cd $(BUILDROOT) && rm -rf LimeSuite

Soapy-Remote:
	sudo apt-get -y install libavahi-client-dev && cd $(BUILDROOT) && git clone https://github.com/pothosware/SoapyRemote.git && cd SoapyRemote && git reset --hard "soapy-remote-0.5.1" && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..  && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf SoapyRemote

AirspyHF:
	cd $(BUILDROOT) && git clone https://github.com/airspy/airspyhf && cd airspyhf && git reset --hard 1af81c0ca18944b8c9897c3c98dc0a991815b686 && mkdir build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libairspyhf .. && make -j $(nproc) install && cd $(BUILDROOT) && rm -rf airspyhf

Perseus:
	cd $(BUILDROOT) && git clone https://github.com/f4exb/libperseus-sdr.git && cd libperseus-sdr && git checkout fixes && git reset --hard afefa23e3140ac79d845acb68cf0beeb86d09028 && mkdir build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/libperseus .. && make -j $(nproc) && make install && cd $(BUILDROOT) && rm -rf libperseus-sdr

USRP:
	sudo apt install libboost-all-dev libusb-1.0-0-dev python3-mako doxygen python3-docutils build-essential && cd $(BUILDROOT) && git clone https://github.com/EttusResearch/uhd.git && git reset --hard v4.3.0.0 && cd uhd/host && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/uhd ../ && make -j $(nproc) && make install
	$(INSTALLROOT)/uhd/lib/uhd/utils/uhd_images_downloader.py
	# The following aren't required if installed to /
	echo $(INSTALLROOT)/uhd/lib | sudo dd of=/etc/ld.so.conf.d/uhd.conf && sudo ldconfig && export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$(INSTALLROOT)/uhd/lib/pkgconfig
	# Enable USB access from user accounts
	cd $(INSTALLROOT)/uhd/lib/uhd/utils && sudo cp uhd-usrp.rules /etc/udev/rules.d/ && sudo udevadm control --reload-rules && sudo udevadm trigger

XTRX:
	sudo apt-get -y install build-essential libusb-1.0-0-dev dkms python python3-cheetah && cd $(BUILDROOT) && git clone https://github.com/f4exb/images.git xtrx-images && cd xtrx-images && git submodule init && git submodule update && cd sources && mkdir build && cd build && cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/xtrx-images -DENABLE_SOAPY=NO .. && make -j $(nproc) && make install && cd $(BUILDROOT) && rm -rf xtrx-images/

sdrangel:
	cd $(BUILDROOT) && git clone https://github.com/f4exb/sdrangel.git

SDRangel: sdrangel
	cd $(BUILDROOT) && cd sdrangel && mkdir -p build && cd build && cmake -Wno-dev -DDEBUG_OUTPUT=ON -DRX_SAMPLE_24BIT=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DMIRISDR_DIR=$(INSTALLROOT)/libmirisdr -DRTLSDR_DIR=$(INSTALLROOT)/librtlsdr -DIIO_DIR=$(INSTALLROOT)/libiio -DPERSEUS_DIR=$(INSTALLROOT)/libperseus -DXTRX_DIR=$(INSTALLROOT)/xtrx-images -DUHD_DIR=$(INSTALLROOT)/uhd -DAPT_DIR=$(INSTALLROOT)/aptdec -DCM256CC_DIR=$(INSTALLROOT)/cm256cc -DDSDCC_DIR=$(INSTALLROOT)/dsdcc -DSERIALDV_DIR=$(INSTALLROOT)/serialdv -DMBE_DIR=$(INSTALLROOT)/mbelib -DCODEC2_DIR=$(INSTALLROOT)/codec2 -DSGP4_DIR=$(INSTALLROOT)/sgp4 -DLIBSIGMF_DIR=$(INSTALLROOT)/libsigmf -DDAB_DIR=$(INSTALLROOT)/libdab -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/sdrangel .. && make -j $(nproc) install

SDRangel-srv: sdrangel
	cd $(BUILDROOT) && cd sdrangel && mkdir -p build && cd build && cmake -Wno-dev -DDEBUG_OUTPUT=ON -DRX_SAMPLE_24BIT=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DMIRISDR_DIR=$(INSTALLROOT)/libmirisdr -DRTLSDR_DIR=$(INSTALLROOT)/librtlsdr -DIIO_DIR=$(INSTALLROOT)/libiio -DPERSEUS_DIR=$(INSTALLROOT)/libperseus -DXTRX_DIR=$(INSTALLROOT)/xtrx-images -DUHD_DIR=$(INSTALLROOT)/uhd -DAPT_DIR=$(INSTALLROOT)/aptdec -DCM256CC_DIR=$(INSTALLROOT)/cm256cc -DDSDCC_DIR=$(INSTALLROOT)/dsdcc -DSERIALDV_DIR=$(INSTALLROOT)/serialdv -DMBE_DIR=$(INSTALLROOT)/mbelib -DCODEC2_DIR=$(INSTALLROOT)/codec2 -DSGP4_DIR=$(INSTALLROOT)/sgp4 -DLIBSIGMF_DIR=$(INSTALLROOT)/libsigmf -DDAB_DIR=$(INSTALLROOT)/libdab -DBUILD_SERVER=ON -DBUILD_GUI=OFF -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/sdrangel .. && make -j $(nproc) install

SDRangel-gui: sdrangel
	cd $(BUILDROOT) && cd sdrangel && mkdir -p build && cd build && cmake -Wno-dev -DDEBUG_OUTPUT=ON -DRX_SAMPLE_24BIT=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DMIRISDR_DIR=$(INSTALLROOT)/libmirisdr -DRTLSDR_DIR=$(INSTALLROOT)/librtlsdr -DIIO_DIR=$(INSTALLROOT)/libiio -DPERSEUS_DIR=$(INSTALLROOT)/libperseus -DXTRX_DIR=$(INSTALLROOT)/xtrx-images -DUHD_DIR=$(INSTALLROOT)/uhd -DAPT_DIR=$(INSTALLROOT)/aptdec -DCM256CC_DIR=$(INSTALLROOT)/cm256cc -DDSDCC_DIR=$(INSTALLROOT)/dsdcc -DSERIALDV_DIR=$(INSTALLROOT)/serialdv -DMBE_DIR=$(INSTALLROOT)/mbelib -DCODEC2_DIR=$(INSTALLROOT)/codec2 -DSGP4_DIR=$(INSTALLROOT)/sgp4 -DLIBSIGMF_DIR=$(INSTALLROOT)/libsigmf -DDAB_DIR=$(INSTALLROOT)/libdab -DBUILD_SERVER=OFF -DCMAKE_INSTALL_PREFIX=$(INSTALLROOT)/sdrangel .. && make -j $(nproc) install
