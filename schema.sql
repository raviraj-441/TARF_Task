CREATE TABLE Airports (
    AirportID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    IATA CHAR(3) UNIQUE,
    ICAO CHAR(4) UNIQUE,
    Country VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Latitude DECIMAL(10, 8),
    Longitude DECIMAL(11, 8)
);

CREATE TABLE Airlines (
    AirlineID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    IATA CHAR(2),
    ICAO CHAR(3)
);

CREATE TABLE Flights (
    FlightID SERIAL PRIMARY KEY,
    FlightNumber VARCHAR(10) NOT NULL,
    AirlineID INTEGER REFERENCES Airlines(AirlineID),
    OriginAirportID INTEGER REFERENCES Airports(AirportID),
    DestinationAirportID INTEGER REFERENCES Airports(AirportID),
    ScheduledDeparture TIMESTAMP NOT NULL,
    ScheduledArrival TIMESTAMP NOT NULL
);

CREATE TABLE FlightStatuses (
    StatusID SERIAL PRIMARY KEY,
    FlightID INTEGER NOT NULL REFERENCES Flights(FlightID),
    ActualDeparture TIMESTAMP,
    ActualArrival TIMESTAMP,
    DelayMinutes INTEGER DEFAULT 0,
    Status VARCHAR(50)
);

CREATE INDEX idx_flight_number ON Flights(FlightNumber);
CREATE INDEX idx_iata ON Airports(IATA);
CREATE INDEX idx_icao ON Airports(ICAO);