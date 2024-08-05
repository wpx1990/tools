ARG base_image=golang:alpine
FROM $base_image

COPY ./go_code/pause_linux_amd64 /pause_linux_amd64
COPY ./go_code/pause_linux_arm64 /pause_linux_arm64
ENTRYPOINT ["/pause_linux_amd64 || /pause_linux_amd64"]