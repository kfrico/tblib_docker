FROM debian:10

# 安裝OCR相關套件
RUN apt-get update -qq
RUN apt-get install -y -qq libtesseract-dev libleptonica-dev

ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata/

RUN apt-get install -y -qq \
  tesseract-ocr-eng \
  tesseract-ocr-deu \
  tesseract-ocr-jpn

# 安裝tblib
RUN apt-get update && apt-get install make git zlib1g-dev libssl-dev gperf php-cli cmake g++ -y

RUN git clone --branch master https://github.com/tdlib/td.git

RUN cd td

RUN cd td && rm -rf build && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../tdlib .. && \
    cmake --build . --target install && \
    cp -rf /td/tdlib/include/* /usr/local/include/ && \
    cp -rf /td/tdlib/lib/* /usr/local/lib/

# 安裝golang
RUN apt-get update && apt-get install wget -y

RUN wget https://golang.org/dl/go1.16.6.linux-amd64.tar.gz

RUN tar -C /usr/local -xzf go1.16.6.linux-amd64.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $PATH:$GOROOT/bin


WORKDIR "$GOPATH/src/code"

CMD ["tail", "-f", "/dev/null"]