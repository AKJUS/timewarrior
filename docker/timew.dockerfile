FROM ubuntu:24.04 AS base

FROM base AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y \
            asciidoctor \
            cmake \
            g++ \
            git

# Setup language environment
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Add source directory
ADD .. /root/code/
WORKDIR /root/code/

# Build Timewarrior
RUN git clean -dfx && \
    git submodule init && \
    git submodule update && \
    cmake -DCMAKE_BUILD_TYPE=release . && \
    make -j8

FROM base AS runner

RUN ( apt-get update && yes | unminimize )
RUN apt install -y man-db

# Install Timewarrior
COPY --from=builder --chown=0:0 /root/code/src/timew /usr/local/bin
COPY --from=builder --chown=0:0 /root/code/ChangeLog /usr/local/share/doc/timew/ChangeLog
COPY --from=builder --chown=0:0 /root/code/README.md /usr/local/share/doc/timew/README.md
COPY --from=builder --chown=0:0 /root/code/INSTALL /usr/local/share/doc/timew/INSTALL
COPY --from=builder --chown=0:0 /root/code/AUTHORS /usr/local/share/doc/timew/AUTHORS
COPY --from=builder --chown=0:0 /root/code/LICENSE /usr/local/share/doc/timew/LICENSE
COPY --from=builder --chown=0:0 /root/code/doc/holidays/README /usr/local/share/doc/timew/holidays/README
COPY --from=builder --chown=0:0 /root/code/doc/holidays/holidays.en-US /usr/local/share/doc/timew/holidays/holidays.en-US
COPY --from=builder --chown=0:0 /root/code/doc/holidays/refresh /usr/local/share/doc/timew/holidays/refresh
COPY --from=builder --chown=0:0 /root/code/doc/themes/README /usr/local/share/doc/timew/themes/README
COPY --from=builder --chown=0:0 /root/code/doc/themes/dark.theme /usr/local/share/doc/timew/themes/dark.theme
COPY --from=builder --chown=0:0 /root/code/doc/themes/dark_blue.theme /usr/local/share/doc/timew/themes/dark_blue.theme
COPY --from=builder --chown=0:0 /root/code/doc/themes/dark_green.theme /usr/local/share/doc/timew/themes/dark_green.theme
COPY --from=builder --chown=0:0 /root/code/doc/themes/dark_red.theme /usr/local/share/doc/timew/themes/dark_red.theme
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-annotate.1 /usr/local/share/man/man1/timew-annotate.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-cancel.1 /usr/local/share/man/man1/timew-cancel.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-chart.1 /usr/local/share/man/man1/timew-chart.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-config.1 /usr/local/share/man/man1/timew-config.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-continue.1 /usr/local/share/man/man1/timew-continue.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-delete.1 /usr/local/share/man/man1/timew-delete.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-diagnostics.1 /usr/local/share/man/man1/timew-diagnostics.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-export.1 /usr/local/share/man/man1/timew-export.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-extensions.1 /usr/local/share/man/man1/timew-extensions.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-fill.1 /usr/local/share/man/man1/timew-fill.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-gaps.1 /usr/local/share/man/man1/timew-gaps.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-get.1 /usr/local/share/man/man1/timew-get.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-help.1 /usr/local/share/man/man1/timew-help.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-import.1 /usr/local/share/man/man1/timew-import.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-join.1 /usr/local/share/man/man1/timew-join.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-lengthen.1 /usr/local/share/man/man1/timew-lengthen.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-modify.1 /usr/local/share/man/man1/timew-modify.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-move.1 /usr/local/share/man/man1/timew-move.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-report.1 /usr/local/share/man/man1/timew-report.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-resize.1 /usr/local/share/man/man1/timew-resize.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-retag.1 /usr/local/share/man/man1/timew-retag.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-shorten.1 /usr/local/share/man/man1/timew-shorten.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-show.1 /usr/local/share/man/man1/timew-show.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-split.1 /usr/local/share/man/man1/timew-split.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-start.1 /usr/local/share/man/man1/timew-start.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-stop.1 /usr/local/share/man/man1/timew-stop.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-summary.1 /usr/local/share/man/man1/timew-summary.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-tag.1 /usr/local/share/man/man1/timew-tag.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-tags.1 /usr/local/share/man/man1/timew-tags.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-track.1 /usr/local/share/man/man1/timew-track.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-undo.1 /usr/local/share/man/man1/timew-undo.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew-untag.1 /usr/local/share/man/man1/timew-untag.1
COPY --from=builder --chown=0:0 /root/code/doc/man1/timew.1 /usr/local/share/man/man1/timew.1
COPY --from=builder --chown=0:0 /root/code/doc/man7/timew-config.7 /usr/local/share/man/man7/timew-config.7
COPY --from=builder --chown=0:0 /root/code/doc/man7/timew-dates.7 /usr/local/share/man/man7/timew-dates.7
COPY --from=builder --chown=0:0 /root/code/doc/man7/timew-dom.7 /usr/local/share/man/man7/timew-dom.7
COPY --from=builder --chown=0:0 /root/code/doc/man7/timew-durations.7 /usr/local/share/man/man7/timew-durations.7
COPY --from=builder --chown=0:0 /root/code/doc/man7/timew-hints.7 /usr/local/share/man/man7/timew-hints.7
COPY --from=builder --chown=0:0 /root/code/doc/man7/timew-ranges.7 /usr/local/share/man/man7/timew-ranges.7
COPY --from=builder --chown=0:0 /root/code/ext/on-modify.timewarrior /usr/local/share/doc/timew/ext/on-modify.timewarrior
COPY --from=builder --chown=0:0 /root/code/ext/totals.py /usr/local/share/doc/timew/ext/totals.py

# Initialize Timewarrior
RUN timew :yes
