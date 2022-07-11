FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["BasicCoreApp/BasicCoreApp.csproj", "BasicCoreApp/"]
RUN dotnet restore "BasicCoreApp/BasicCoreApp.csproj"
COPY . .
WORKDIR "/src/BasicCoreApp"
RUN dotnet build "BasicCoreApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BasicCoreApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BasicCoreApp.dll"]