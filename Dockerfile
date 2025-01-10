FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y git curl cmake make autoconf pkg-config automake g++ libtool libssl-dev libminiupnpc-dev libevent-dev

RUN git clone https://github.com/hyle-team/zano.git /zano/zano
RUN cd /zano/zano && git submodule update --init --recursive

WORKDIR /zano/zano
RUN curl -OL https://archives.boost.io/release/1.84.0/source/boost_1_84_0.tar.bz2
RUN echo "cc4b893acf645c9d4b698e9a0f08ca8846aa5d6c68275c14c3e7949c24109454  boost_1_84_0.tar.bz2" | shasum -c && tar -xjf boost_1_84_0.tar.bz2
RUN rm boost_1_84_0.tar.bz2
WORKDIR /zano/zano/boost_1_84_0
RUN ./bootstrap.sh --with-libraries=system,filesystem,thread,date_time,chrono,regex,serialization,atomic,program_options,locale,timer,log
RUN ./b2 install --prefix=/zano/zano/boost_1_84_0/install

WORKDIR /zano/zano
RUN git checkout tags/2.0.1.367
RUN mkdir build
WORKDIR /zano/zano/build
RUN cmake \
    -DBOOST_ROOT=/zano/zano/boost_1_84_0/install \
    -DBoost_NO_SYSTEM_PATHS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    .. && \
    make -j$(nproc)

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y pkg-config libtool libssl-dev libevent-dev
RUN addgroup --gid 1000 zano
RUN adduser --disabled-password --gecos "" --home /zano --ingroup zano --uid 1000 zano

USER zano
COPY --from=builder /zano /zano
COPY ./entrypoint.sh /

RUN mkdir /zano/.Zano
VOLUME /zano/.Zano
ENTRYPOINT ["/entrypoint.sh"]
# P2P
EXPOSE 11121/tcp
# RPC
EXPOSE 11211/tcp

