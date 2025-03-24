from fastapi import FastAPI, HTTPException
from dotenv import load_dotenv
import os
from fastapi.middleware.cors import CORSMiddleware
from supabase import create_client, Client
from datetime import datetime

load_dotenv()
app = FastAPI()

# Supabase connection
supabase_url = os.getenv('SUPABASE_URL')
supabase_key = os.getenv('SUPABASE_KEY')
supabase: Client = create_client(supabase_url, supabase_key)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/flights")
async def get_flights(date: str):
    result = supabase.table('flights')\
        .select('*, origin:airports!flights_originairportid_fkey(name), destination:airports!flights_destinationairportid_fkey(name)')\
        .filter('scheduleddeparture', 'gte', f'{date}T00:00:00')\
        .filter('scheduleddeparture', 'lt', f'{date}T23:59:59')\
        .execute()
    return result.data

@app.get("/airports/{iata}")
async def get_airport(iata: str):
    result = supabase.table('airports')\
        .select('*')\
        .eq('iata', iata)\
        .execute()
    
    if not result.data:
        raise HTTPException(status_code=404, detail="Airport not found")
    return result.data[0]

@app.get("/delays")
async def get_delayed_flights():
    result = supabase.table('flightstatuses')\
        .select('flightid, flights!inner(*), delayminutes, actualdeparture')\
        .gt('delayminutes', 120)\
        .execute()
    return result.data