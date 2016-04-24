FROM buildpack-deps:jessie-scm

# Setup enviorment
ENV LANG C.UTF-8

ENV GOPATH /go

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH "$GEM_HOME" 
ENV BUNDLE_BIN "$GEM_HOME/bin" 
ENV BUNDLE_SILENCE_ROOT_WARNING 1 
ENV BUNDLE_APP_CONFIG "$GEM_HOME"

ENV PATH $BUNDLE_BIN:$GOPATH/bin:/usr/local/go/bin:$PATH

# Setup Versions and checks for everything that we can
ENV GOLANG_VERSION 1.6.2
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 e40c36ae71756198478624ed1bb4ce17597b3c19d243f3f0899bb5740d56212a

ENV PYTHON_GPG_KEY C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF
ENV PYTHON_VERSION 2.7.11
ENV PYTHON_PIP_VERSION 8.1.1

ENV RUBY_MAJOR 2.3
ENV RUBY_VERSION 2.3.0
ENV RUBY_DOWNLOAD_SHA256 ba5ba60e5f1aa21b4ef8e9bf35b9ddb57286cb546aac4b5a28c71f459467e507

ENV RUBYGEMS_VERSION 2.6.3
ENV BUNDLER_VERSION 1.11.2

ENV GRPC_RELEASE_TAG release-0_13_1
ENV GRPC_PYTHON_VERSION 0.13.1
ENV GRPC_RUBY_VERSION 0.13.1


# Cleanup for python
RUN apt-get purge -y python.*
# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    autotools-dev \
    bison \
    build-essential \
    bzip2 \
    ca-certificates \
    curl \
    g++ \
    gcc \
    git \
    libbz2-dev \
    libc6-dbg \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libgdbm3 \
    libgflags-dev \
    libglib2.0-dev \
    libssl-dev \
    libgtest-dev \
    libncurses-dev \
    libreadline-dev \
    libtool \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    make \
    ruby \
    procps \
    unzip \
    zlib1g-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install GO
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz \
    && mkdir -p "$GOPATH/src" "$GOPATH/bin" \
    && chmod -R 777 "$GOPATH"

# Install Python
RUN set -ex \
	&& curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
	&& curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" -o python.tar.xz.asc \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$PYTHON_GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& rm -r "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
	&& ./configure --enable-shared --enable-unicode=ucs4 \
	&& make -j$(nproc) \
	&& make install \
	&& ldconfig \
	&& curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
	&& pip install --no-cache-dir --upgrade pip==$PYTHON_PIP_VERSION \
	&& find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
	&& rm -rf /usr/src/python ~/.cache

# install "virtualenv", since the vast majority of users of this image will want it
RUN pip install --no-cache-dir virtualenv

# install ruby
# skip installing gem documentation
RUN set -ex \
    && mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc \
    && curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
    && echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/ruby \
    && tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
    && rm ruby.tar.gz \
    && cd /usr/src/ruby \
    && { echo '#define ENABLE_PATH_CHECK 0'; echo; cat file.c; } > file.c.new && mv file.c.new file.c \
    && autoconf \
    && ./configure --disable-install-doc \
    && make -j"$(nproc)" \
    && make install \
    && gem update --system $RUBYGEMS_VERSION \
    && rm -r /usr/src/ruby && cd / \
    && gem install bundler --version "$BUNDLER_VERSION" \
    && mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

# Install GRPC
RUN git clone https://github.com/grpc/grpc.git /var/local/git/grpc \
    && cd /var/local/git/grpc \
    && git checkout tags/${GRPC_RELEASE_TAG} \
    && git submodule update --init --recursive \
    && cd /var/local/git/grpc/third_party/protobuf \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make -j12 && make check && make install && make clean \
    && cd /var/local/git/grpc && make install
# Get the source from GitHub
RUN go get google.golang.org/grpc
# Install protoc-gen-go
RUN go get github.com/golang/protobuf/protoc-gen-go
RUN pip install grpcio==${GRPC_PYTHON_VERSION}
RUN gem install grpc -v ${GRPC_RUBY_VERSION}

