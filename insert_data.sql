-- Insert 5 German Airports
INSERT INTO Airports (Name, IATA, ICAO, Country, City, Latitude, Longitude) VALUES
('Berlin Brandenburg Airport', 'BER', 'EDDB', 'Germany', 'Berlin', 52.3667, 13.5033),
('Frankfurt Airport', 'FRA', 'EDDF', 'Germany', 'Frankfurt', 50.0333, 8.5706),
('Munich Airport', 'MUC', 'EDDM', 'Germany', 'Munich', 48.3538, 11.7861),
('Hamburg Airport', 'HAM', 'EDDH', 'Germany', 'Hamburg', 53.6304, 9.9882),
('Cologne Bonn Airport', 'CGN', 'EDDK', 'Germany', 'Cologne', 50.8659, 7.1427);

-- Insert Airlines
INSERT INTO Airlines (Name, IATA, ICAO) VALUES
('Lufthansa', 'LH', 'DLH'),
('Eurowings', 'EW', 'EWG'),
('Ryanair', 'FR', 'RYR');

-- Insert 10 Sample Flights
INSERT INTO Flights (FlightNumber, AirlineID, OriginAirportID, DestinationAirportID, ScheduledDeparture, ScheduledArrival) VALUES
('LH123', 1, 1, 2, '2024-01-01T08:00:00Z', '2024-01-01T10:00:00Z'),
('EW456', 2, 2, 3, '2024-01-01T09:00:00Z', '2024-01-01T11:00:00Z'),
('FR789', 3, 3, 4, '2024-01-01T10:00:00Z', '2024-01-01T12:00:00Z'),
('LH234', 1, 4, 5, '2024-01-01T11:00:00Z', '2024-01-01T13:00:00Z'),
('EW567', 2, 5, 1, '2024-01-01T12:00:00Z', '2024-01-01T14:00:00Z'),
('FR890', 3, 1, 3, '2024-01-01T13:00:00Z', '2024-01-01T15:00:00Z'),
('LH345', 1, 2, 4, '2024-01-01T14:00:00Z', '2024-01-01T16:00:00Z'),
('EW678', 2, 3, 5, '2024-01-01T15:00:00Z', '2024-01-01T17:00:00Z'),
('FR901', 3, 4, 1, '2024-01-01T16:00:00Z', '2024-01-01T18:00:00Z'),
('LH456', 1, 5, 2, '2024-01-01T17:00:00Z', '2024-01-01T19:00:00Z');

-- Insert Flight Statuses with Delays
INSERT INTO FlightStatuses (FlightID, ActualDeparture, ActualArrival, DelayMinutes, Status) VALUES
(1, '2024-01-01T10:00:00Z', '2024-01-01T12:00:00Z', 120, 'delayed'),
(2, '2024-01-01T09:30:00Z', '2024-01-01T11:15:00Z', -30, 'arrived'),
(3, '2024-01-01T10:00:00Z', '2024-01-01T12:00:00Z', 0, 'on time'),
(5, '2024-01-01T12:30:00Z', '2024-01-01T14:45:00Z', 30, 'delayed'),
(7, '2024-01-01T14:15:00Z', '2024-01-01T16:30:00Z', 15, 'delayed'),
(9, '2024-01-01T16:30:00Z', '2024-01-01T18:45:00Z', 30, 'delayed');

-- Required Queries
-- 1. Retrieve all flights from Berlin (BER)
SELECT f.* FROM Flights f
JOIN Airports a ON f.OriginAirportID = a.AirportID
WHERE a.IATA = 'BER';

-- 2. Identify flights delayed by more than 2 hours
SELECT f.FlightNumber, s.DelayMinutes, f.ScheduledDeparture, s.ActualDeparture
FROM FlightStatuses s
JOIN Flights f ON s.FlightID = f.FlightID
WHERE s.DelayMinutes > 120;

-- 3. Fetch flight details using flight number
SELECT f.*, a1.Name AS Origin, a2.Name AS Destination
FROM Flights f
JOIN Airports a1 ON f.OriginAirportID = a1.AirportID
JOIN Airports a2 ON f.DestinationAirportID = a2.AirportID
WHERE f.FlightNumber = 'LH123';