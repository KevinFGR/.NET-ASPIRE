# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# WORKDIR /src

# COPY aspire.AppHost.csproj ./
# RUN dotnet restore

# COPY . ./
# RUN dotnet publish -c Release -o /app/publish

# FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
# WORKDIR /app
# COPY --from=build /app/publish ./
# ENV ASPNETCORE_URLS=http://+:80
# EXPOSE 80
# ENTRYPOINT ["dotnet", "aspire.AppHost.dll"]


# # Etapa 1: build
# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# WORKDIR /src

# RUN dotnet workload install aspire

# COPY . .
# RUN dotnet restore

# RUN dotnet publish aspire.AppHost.csproj -c Release -o /app/publish

# # Etapa 2: runtime
# FROM mcr.microsoft.com/dotnet/runtime:8.0 AS final
# WORKDIR /app

# COPY --from=build /app/publish .

# ENTRYPOINT ["dotnet", "aspire.AppHost.dll"]


# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# WORKDIR /src

# RUN dotnet workload install aspire
# COPY . .
# RUN dotnet build -c Release

# FROM mcr.microsoft.com/dotnet/aspnet:8.0
# WORKDIR /app

# COPY --from=build /src/bin/Release/net8.0/ ./

# EXPOSE 80

# ENTRYPOINT ["dotnet", "aspire.AppHost.dll"]

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

RUN dotnet workload install aspire
COPY . .
RUN dotnet build -c Release

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /src/bin/Release/net8.0/ ./

EXPOSE 80

# Para o dashboard
ENV ASPNETCORE_URLS=http://+:80
ENV DOTNET_DASHBOARD_OTLP_HTTP_ENDPOINT_URL=http://localhost:5003

ENTRYPOINT ["dotnet", "aspire.AppHost.dll"]