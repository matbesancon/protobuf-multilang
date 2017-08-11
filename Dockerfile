FROM swift:3.1.0

MAINTAINER Mathieu Besançon <mathieu.besancon@gmail.com>

RUN apt-get -q update
RUN apt-get -q install -y zip unzip wget

ENV SWIFT_TAG "0.9.904"
ENV GOVERSION "1.8.3"

# protobuf compiler
RUN wget https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip -O protobuf.zip
RUN unzip protobuf.zip -d ./protobuf
RUN rm -rf protobuf.zip
RUN cp ./protobuf/bin/protoc /usr/local/bin/protoc

# protobuf for Swift
RUN git clone --depth=1 -b $SWIFT_TAG https://github.com/apple/swift-protobuf.git
RUN cd ./swift-protobuf && swift build -c release # -Xswiftc -static-stdlib
RUN cp ./swift-protobuf/.build/release/protoc-gen-swift /usr/local/bin/protoc-gen-swift

# Golang and golang/protobuf
ENV GOVERSION 1.8.3
RUN cd /usr/local && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin/

RUN mkdir -p /go/src

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin

RUN go get -u github.com/golang/protobuf/proto github.com/golang/protobuf/protoc-gen-go

RUN mkdir -p /src/proto
