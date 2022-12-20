FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /Game
# Copy everything
COPY . ./
# Restore as distinct layers
RUN cd Game && dotnet restore
# Build and publish a release
RUN cd Game && dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/sdk:6.0
WORKDIR /Game
# Copy everything
COPY . ./
# Run all test cases
RUN cd Game && dotnet test

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /Game
COPY --from=build-env /Game/out .
ENV ASPNETCORE_URLS=http://+:7021
ENTRYPOINT ["dotnet", "KOF.dll"]