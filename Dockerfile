FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim-arm64v8 as base
#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim-arm32v7 AS base

WORKDIR /app
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
##FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim-arm64v8 AS build
#FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore

COPY . ./
WORKDIR /app
#RUN dotnet build  -c Release -o /app/build -r "linux-arm64"

FROM build AS publish
RUN dotnet publish  -c Release -o out -r "linux-arm64"
##--self-contained false --no-restore


FROM base AS final
WORKDIR /app
COPY --from=publish /app/out .
ENTRYPOINT ["dotnet", "M2R_WS.dll"]
