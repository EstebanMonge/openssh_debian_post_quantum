#!/bin/bash

openssh_version='10.2p1'
build_dir=$HOME/build_package

if [[ -f /usr/bin/tar ]]
then
	tar_path="/usr/bin/tar"
else
	tar_path="/bin/tar"
fi

sudo /usr/bin/apt-get install build-essential zlib1g-dev libssl-dev libpam0g-dev libedit-dev libaudit-dev dh-make devscripts
if [[ ! -d ${build_dir} ]]
then
	mkdir ${build_dir}
fi
cd ${build_dir} 
if [[ ! -f openssh-${openssh_version}.tar.gz ]]
then
	/usr/bin/wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${openssh_version}.tar.gz
fi
${tar_path} -zxvf openssh-${openssh_version}.tar.gz
cp openssh-${openssh_version}.tar.gz openssh_${openssh_version}.orig.tar.gz
cd ${build_dir}/openssh-${openssh_version}
/usr/bin/dh_make -y -s -f ../openssh-${openssh_version}.tar.gz
cat > ${build_dir}/openssh-${openssh_version}/debian/rules << EOF
#!/usr/bin/make -f
# -*- makefile -*-
export DH_VERBOSE = 1

%:
	dh \$@ --without=usrlocal

override_dh_auto_configure:
	dh_auto_configure -- \\
	        --disable-strip \\
	        --with-mantype=doc \\
	        --with-4in6 \\
	        --with-libs=-lcrypt \\
	        --with-tcp-wrappers \\
	        --with-pam \\
	        --with-libedit \\
	        --with-ssl-engine \\
	        --with-audit=linux \\
	        --with-systemd \\
	        --prefix=/usr/local \\
	        --sysconfdir=/etc/ssh


override_dh_auto_install:
	# Install under debian/tmp but preserve /usr/local structure
	dh_auto_install --destdir=\$(CURDIR)/debian/tmp

override_dh_install:
	# Copy from debian/tmp to package dir
	dh_install --sourcedir=debian/tmp

# Disable dh_usrlocal entirely
override_dh_usrlocal:
	@echo "Skipping dh_usrlocal because we intentionally install to /usr/local"

#override_dh_systemd_enable:
#	dh_systemd_enable -popenssh-server --name ssh ssh-local.service
#	dh_systemd_enable -popenssh-server --name ssh --no-enable ssh-local.socket
EOF
cat > ${build_dir}/openssh-${openssh_version}/debian/openssh.install << EOF
#! /usr/bin/dh-exec

usr/local/bin/*
usr/local/sbin/*
usr/local/lib/x86_64-linux-gnu/*
usr/local/share/man/*
EOF
cat > ${build_dir}/openssh-${openssh_version}/debian/control << EOF
Source: openssh
Section: unknown
Priority: optional
Maintainer: Esteban Monge <estebanmonge@riseup.net>
Build-Depends: debhelper (>= 10), autotools-dev
Standards-Version: 4.1.3
Homepage: <insert the upstream URL, if relevant>
#Vcs-Browser: https://salsa.debian.org/debian/openssh
#Vcs-Git: https://salsa.debian.org/debian/openssh.git

Package: openssh
Architecture: any
Depends: ${shlibs:Depends}, ${misc:Depends}
Description: <insert up to 60 chars description>
 <insert long description, indented with spaces>
EOF
/usr/bin/debuild -k'Esteban Monge <estebanmonge@riseup.net>'
