FROM centos:centos6
MAINTAINER 16yuki0702

#init
RUN yum install -y \
	wget \
	git \
	vim \
	make \
	gcc \
	g++ \
	mercurial \
	cmake \
	sudo \
	openssl-devel \
	c-ares-devel \
	libuuid-devel \
	zlib-devel \
	libffi-devel \
	readline-devel \
	python-setuptools \
	python-devel \
	yum-utils
RUN yum groupinstall -y "Development Tools" "Development Libraries"

#libwebsockets
RUN cd /usr/local/src && \
	wget https://github.com/warmcat/libwebsockets/archive/v2.1.0.tar.gz && \
	tar xf v2.1.0.tar.gz && \
	cd libwebsockets-2.1.0 && \
	mkdir build && \
	cd build && \
	cmake .. -DLIB_SUFFIX=64 && \
	make install && \
	echo "/usr/local/lib64" | tee -a /etc/ld.so.conf.d/libwebsockets.conf && \
	/sbin/ldconfig

#mosquitto
RUN useradd mosquitto
RUN cd /usr/local/src && \
	git clone https://github.com/eclipse/mosquitto.git && \
	cd mosquitto && \
	sed -i -e 's/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/g' config.mk && \
	sed -i -e 's/WITH_DOCS:=yes/WITH_DOCS:=no/g' config.mk && \
	sed -i -e 's/WITH_SRV:=yes/WITH_SRV:=no/g' config.mk && \
	make && \
	make install && \
	mkdir -p /var/lib/mosquitto/plugins && \
	mkdir -p /var/lib/mosquitto/logs && \
	mkdir -p /var/log/mosquitto
ADD mosquitto.conf /etc/mosquitto/
ADD mosquitto /etc/init.d/
RUN chkconfig --add mosquitto && \
	chkconfig mosquitto on

#mosquitto_pyauth
RUN cd /usr/local/src && \
	git clone https://github.com/mbachry/mosquitto_pyauth.git && \
	cd mosquitto_pyauth && \
	make MOSQUITTO_SRC=/usr/local/src/mosquitto && \
	cp auth_plugin_pyauth.so /var/lib/mosquitto/plugins/ && \
	cp testauth.py /var/lib/mosquitto/plugins/ && \
	chown -R mosquitto:mosquitto /var/lib/mosquitto && \
	chown -R mosquitto:mosquitto /var/log/mosquitto && \
	chmod 755 -R /var/log/mosquitto && \
	chmod 755 -R /var/lib/mosquitto/*

#python
RUN cd /usr/local/src && \
	wget http://peak.telecommunity.com/dist/ez_setup.py && \
	python ez_setup.py && \
	rm -rf ez_setup.py && \
	easy_install pip

#gtags
RUN cd /usr/local/src/ && \
	wget http://tamacom.com/global/global-6.5.6.tar.gz && \
	tar zxvf global-6.5.6.tar.gz && \
	cd global-6.5.6 && \
	./configure && \
	make && \
	make install && \
	mkdir -p ~/.vim/plugin/ && \
	cp gtags.vim ~/.vim/plugin/ && \
	cp /usr/local/src/global-6.5.6/gtags.conf /etc/ && \
	curl -kL https://bootstrap.pypa.io/get-pip.py | python && \
	pip install pygments && \
	sed -i -e 's/\*min\.css/\*min\.css,\*.mo/g' /etc/gtags.conf && \
	cd  /usr/local/src && \
	gtags --gtagslabel=pygments -v

#vim
ADD vimrc /root/.vimrc

#tmux
ADD tmux.conf /root/.tmux.conf
