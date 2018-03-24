FROM microsoft/dotnet:2.0-sdk
COPY . /builddir
RUN dotnet restore && rm -rf /builddir
WORKDIR /app
