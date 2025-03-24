# Flight Monitoring System

A real-time flight monitoring system that tracks flights across European airports and identifies delays exceeding 2 hours.

## Features

- Real-time flight data collection from AviationStack API
- Continuous monitoring of multiple airports
- Automatic delay detection and flagging
- Data persistence using Supabase
- Rate limiting and error handling

## Prerequisites

- Python 3.8+
- Supabase account and credentials
- AviationStack API key

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Create a `.env` file with your credentials:
   ```
   AVIATIONSTACK_API_KEY=your_api_key
   SUPABASE_URL=your_supabase_url
   SUPABASE_KEY=your_supabase_key
   ```

## Usage

Run the flight monitor:
```bash
python flight_monitor.py
```

The system will:
- Monitor specified airports for flight updates
- Store flight data in Supabase
- Flag flights with delays > 2 hours
- Provide real-time status updates

## Database Schema

The system uses the following tables:
- Airports: Store airport information
- Airlines: Store airline information
- Flights: Store flight schedules
- FlightStatuses: Track real-time flight status and delays