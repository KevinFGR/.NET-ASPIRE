FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
RUN dotnet workload install aspire
COPY . .

# Restaura pacotes incluindo o Aspire Linux x64
RUN dotnet restore /p:RuntimeIdentifier=linux-x64

RUN dotnet build -c Release

# Copia o pacote Aspire.Hosting.Orchestration para ser usado no container final
RUN mkdir -p /src/nuget_packages && \
    cp -r ~/.nuget/packages/aspire.hosting.orchestration.linux-x64 /src/nuget_packages/

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Instala Docker CLI no container
RUN apt-get update && \
    apt-get install -y --no-install-recommends docker.io && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /src/bin/Release/net8.0/ ./

# Copia o pacote Aspire.Hosting.Orchestration para o local esperado
COPY --from=build /src/nuget_packages/aspire.hosting.orchestration.linux-x64 /root/.nuget/packages/aspire.hosting.orchestration.linux-x64/

EXPOSE 80

# Variáveis para rodar sem HTTPS obrigatório
ENV ASPIRE_ALLOW_UNSECURED_TRANSPORT=true
ENV ASPNETCORE_URLS=http://0.0.0.0:80
ENV DOTNET_DASHBOARD_OTLP_HTTP_ENDPOINT_URL=http://localhost:5003

ENTRYPOINT ["dotnet", "aspire.AppHost.dll"]