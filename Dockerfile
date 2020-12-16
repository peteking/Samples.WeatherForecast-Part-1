FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app
COPY . .

WORKDIR /app/src/Samples.WeatherForecast.Api

RUN dotnet restore "Samples.WeatherForecast.Api.csproj"

RUN dotnet build "Samples.WeatherForecast.Api.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "Samples.WeatherForecast.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Samples.WeatherForecast.Api.dll"]
