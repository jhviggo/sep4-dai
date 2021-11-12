FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["GatewayServer/GatewayServer.csproj", "GatewayServer/"]
RUN dotnet restore "GatewayServer/GatewayServer.csproj"
COPY . .
WORKDIR "/src/GatewayServer"
RUN dotnet build "GatewayServer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GatewayServer.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GatewayServer.dll"]