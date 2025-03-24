import os
import requests
import time
from dotenv import load_dotenv
from datetime import datetime, timedelta
from supabase import create_client, Client
from typing import Optional, Dict, List

load_dotenv()

class FlightMonitor:
    def __init__(self):
        self.api_key = os.getenv('AVIATIONSTACK_API_KEY')
        supabase_url = os.getenv('SUPABASE_URL')
        supabase_key = os.getenv('SUPABASE_KEY')
        self.supabase: Client = create_client(supabase_url, supabase_key)
        self.monitoring_interval = 300  # 5 minutes in seconds
        self.last_update: Dict[str, datetime] = {}
        
    def fetch_flights(self, airport_code: str) -> Optional[List[Dict]]:
        """Fetch flight data for a specific airport with error handling and rate limiting."""
        # Check if we need to wait before making another request
        if airport_code in self.last_update:
            time_since_last_update = (datetime.now() - self.last_update[airport_code]).total_seconds()
            if time_since_last_update < self.monitoring_interval:
                wait_time = self.monitoring_interval - time_since_last_update
                print(f"Waiting {wait_time:.0f} seconds before next update for {airport_code}")
                time.sleep(wait_time)

        url = f'http://api.aviationstack.com/v1/flights?access_key={self.api_key}&dep_iata={airport_code}'
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            self.last_update[airport_code] = datetime.now()
            return response.json()['data']
        except requests.exceptions.RequestException as e:
            print(f"Error fetching data for {airport_code}: {e}")
            return None
        except (KeyError, ValueError) as e:
            print(f"Error parsing data for {airport_code}: {e}")
            return None

    def store_flight_data(self, flights: List[Dict]) -> None:
        """Store flight data with enhanced error handling and delay monitoring."""
        if not flights:
            return

        for flight in flights:
            try:
                flight_number = flight['flight']['number']
                delay_minutes = flight['departure'].get('delay', 0) or 0

                # First get the flight ID from the flights table
                flight_result = self.supabase.table('flights')\
                    .select('flightid')\
                    .eq('flightnumber', flight_number)\
                    .execute()
                
                if flight_result.data:
                    flight_id = flight_result.data[0]['flightid']
                    
                    # Insert flight status with enhanced data validation
                    status_data = {
                        'flightid': flight_id,
                        'actual_departure': flight['departure'].get('estimated'),
                        'delay_minutes': delay_minutes,
                        'status': flight['flight_status']
                    }

                    # Check for significant delays (> 2 hours)
                    if delay_minutes > 120:
                        print(f"⚠️ Flight {flight_number} is delayed by {delay_minutes} minutes!")
                        status_data['needs_review'] = True

                    self.supabase.table('flight_statuses').insert(status_data).execute()
                    print(f"✓ Updated status for flight {flight_number}")
                    
            except KeyError as e:
                print(f"Missing required data for flight: {e}")
            except Exception as e:
                print(f"Error storing flight {flight.get('flight', {}).get('number', 'unknown')}: {e}")

    def monitor_airport(self, airport_code: str, duration_minutes: int = 60) -> None:
        """Continuously monitor flights from a specific airport for a given duration."""
        end_time = datetime.now() + timedelta(minutes=duration_minutes)
        print(f"Starting flight monitoring for {airport_code} for {duration_minutes} minutes...")
        
        while datetime.now() < end_time:
            flights = self.fetch_flights(airport_code)
            if flights:
                self.store_flight_data(flights)
                print(f"Successfully processed {len(flights)} flights from {airport_code}")
            time.sleep(self.monitoring_interval)

if __name__ == "__main__":
    monitor = FlightMonitor()
    # Monitor Berlin airport for 1 hour
    monitor.monitor_airport('BER', duration_minutes=60)