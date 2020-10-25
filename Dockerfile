FROM rust:1.47 as builder

RUN apt-get update; apt-get install -y \
  llvm \
  clang

WORKDIR /usr/src

RUN git clone https://github.com/RazrFalcon/resvg.git

RUN cd resvg ; cargo build --release

FROM debian:buster-slim

RUN apt-get update && apt-get install -y \
    fontconfig-config && \
    rm -rf /var/lib/apt/lists/*

COPY fonts /usr/local/share/fonts

RUN dpkg-reconfigure fontconfig-config

COPY --from=builder /usr/src/resvg/target/release/resvg /usr/local/bin/resvg

CMD ["resvg"]