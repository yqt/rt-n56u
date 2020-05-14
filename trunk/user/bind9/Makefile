SRC_NAME=bind-9.11.18
SRC_URL=https://downloads.isc.org/isc/bind9/9.11.18/bind-9.11.18.tar.gz

THISDIR = $(shell pwd)

CFLAGS  += -ffunction-sections -fdata-sections
CXXFLAGS += -ffunction-sections -fdata-sections
LDFLAGS += -Wl,--gc-sections,--as-needed

all: download_test extract_test config_test
	$(MAKE) -j$(HOST_NCPU) -C $(SRC_NAME)

download_test:
	( if [ ! -f $(THISDIR)/$(SRC_NAME).tar.gz ]; then \
		wget -t5 --timeout=20 --no-check-certificate -O $(SRC_NAME).tar.gz $(SRC_URL); \
	fi )

extract_test:
	( if [ ! -d $(THISDIR)/$(SRC_NAME) ]; then \
		tar zxf $(SRC_NAME).tar.gz; \
	fi )

config_test:
	( if [ -f ./config_done ]; then \
		echo "the same configuration"; \
	else \
		make configure && touch config_done; \
	fi )

configure:
	( cd $(SRC_NAME) ; \
	BUILD_CC=gcc \
	./configure \
		--prefix=/usr \
		--disable-linux-caps \
		--disable-threads \
		--disable-atomic \
		--enable-epoll \
		--with-json-c=no \
		--with-libxml2=no \
		--without-lmdb \
		--without-gssapi \
		--without-readline \
		--without-python \
		--without-openssl \
		--with-randomdev="/dev/urandom" \
		--sysconfdir=/etc/storage/bind \
		--host=$(HOST_TARGET) \
		--build=$(HOST_BUILD) ; \
	)

clean:
	if [ -f $(SRC_NAME)/Makefile ] ; then \
		$(MAKE) -C $(SRC_NAME) distclean ; \
	fi ; \
	rm -f config_done

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/$(SRC_NAME)/bin/dig/dig /usr/bin/dig

