FROM alpine:3.13.3 AS builder

ENV TRANG_VERSION=20181222
ENV TRANG_SHA1SUM=56971f0e32156ed7ec608d5ffd0947b8c0b2519c

RUN apk add --no-cache wget openssl

RUN wget https://github.com/relaxng/jing-trang/releases/download/V${TRANG_VERSION}/trang-${TRANG_VERSION}.zip

RUN echo "${TRANG_SHA1SUM}  trang-${TRANG_VERSION}.zip" | sha1sum -c
RUN unzip trang-${TRANG_VERSION}.zip && mv trang-${TRANG_VERSION} trang
RUN ls -la /trang/

FROM alpine:3.13.3

COPY requirements.txt .

RUN apk add --no-cache make openjdk11-jre py3-pip py-lxml && \
    pip install -r requirements.txt

COPY --from=builder /trang/trang.jar /usr/share/java/
COPY trang /usr/bin/
