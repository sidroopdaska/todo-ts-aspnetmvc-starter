FROM microsoft/dotnet:2.0-sdk
RUN apt-get update && \
	apt-get install -y --no-install-recommends make && \
	rm -rf /var/lib/apt/lists/*
COPY . /builddir
RUN dotnet restore /builddir && rm -rf /builddir
WORKDIR /app
