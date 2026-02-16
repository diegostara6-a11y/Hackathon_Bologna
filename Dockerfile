# Usa l'immagine SDK ufficiale per build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copia tutto il progetto nella cartella /app
COPY . ./

# Restore pacchetti e publish in release
RUN dotnet restore
RUN dotnet publish -c Release -o /app/out

# Usa immagine runtime più leggera per eseguire l'app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Imposta la porta che il container ascolta
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# Comando per avviare l'app
ENTRYPOINT ["dotnet", "Hackathon_Bologna.dll"]
