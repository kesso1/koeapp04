#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["koeapp04.csproj", ""]
RUN dotnet restore "./koeapp04.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "koeapp04.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "koeapp04.csproj" -c Release -o /app/publish

FROM base AS final
COPY koeapp04.pfx /root/.aspnet/https/
COPY secrets.json /root/.microsoft/usersecrets/8df05b1d-e07b-4b82-bee6-798316ced0a1/
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "koeapp04.dll"]
