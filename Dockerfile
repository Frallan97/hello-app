FROM hashicorp/http-echo:0.2.3

CMD ["-text=Hello from hello-app!", "-listen=:5678"]

EXPOSE 5678 