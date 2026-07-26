import datetime
from typing import Any
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from google.adk.agents import Agent

CITY_TIMEZONE_MAP = {
    # New York region & aliases
    "new york": "America/New_York",
    "new york city": "America/New_York",
    "nyc": "America/New_York",
    "hoboken": "America/New_York",
    "jersey city": "America/New_York",
    "brooklyn": "America/New_York",
    "queens": "America/New_York",
    "manhattan": "America/New_York",
    "bronx": "America/New_York",
    "staten island": "America/New_York",
    "boston": "America/New_York",
    "philadelphia": "America/New_York",
    "washington dc": "America/New_York",
    "washington d c": "America/New_York",
    "miami": "America/New_York",
    "atlanta": "America/New_York",

    # US Central
    "chicago": "America/Chicago",
    "houston": "America/Chicago",
    "dallas": "America/Chicago",
    "austin": "America/Chicago",

    # US Mountain
    "denver": "America/Denver",
    "phoenix": "America/Phoenix",

    # US Pacific
    "los angeles": "America/Los_Angeles",
    "la": "America/Los_Angeles",
    "san francisco": "America/Los_Angeles",
    "sf": "America/Los_Angeles",
    "seattle": "America/Los_Angeles",
    "san jose": "America/Los_Angeles",

    # Europe
    "london": "Europe/London",
    "paris": "Europe/Paris",
    "berlin": "Europe/Berlin",
    "rome": "Europe/Rome",
    "madrid": "Europe/Madrid",
    "amsterdam": "Europe/Amsterdam",

    # Asia & Pacific
    "tokyo": "Asia/Tokyo",
    "beijing": "Asia/Shanghai",
    "shanghai": "Asia/Shanghai",
    "hong kong": "Asia/Hong_Kong",
    "singapore": "Asia/Singapore",
    "seoul": "Asia/Seoul",
    "sydney": "Australia/Sydney",
    "melbourne": "Australia/Melbourne",
}


def resolve_timezone(city: str) -> str | None:
    """Helper function to resolve a city name or alias to an IANA timezone string."""
    city_clean = city.strip().replace(".", "")
    city_lower = city_clean.lower()
    if city_lower in CITY_TIMEZONE_MAP:
        return CITY_TIMEZONE_MAP[city_lower]

    # Try formatted IANA timezone directly if user passed something like "America/New_York"
    try:
        ZoneInfo(city)
        return city
    except ZoneInfoNotFoundError:
        pass

    # Try capitalizing words and checking with standard regions
    formatted_city = city_clean.title().replace(" ", "_")
    for region in ["America", "Europe", "Asia", "Australia", "Africa", "Pacific"]:
        candidate = f"{region}/{formatted_city}"
        try:
            ZoneInfo(candidate)
            return candidate
        except ZoneInfoNotFoundError:
            pass

    return None


def get_weather(city: str) -> dict[str, Any]:
    """Retrieves the current weather report for a specified city.

    Args:
        city (str): The name of the city for which to retrieve the weather report.
    Returns:
        A structured error explaining that live weather is not configured.
    """
    return {
        "status": "error",
        "error_message": (
            f"Live weather information for '{city}' is not available because "
            "this demo has no weather data provider configured."
        ),
    }


def get_current_time(city: str) -> dict[str, Any]:
    """Returns the current time in a specified city.

    Args:
        city (str): The name of the city for which to retrieve the current time.
    Returns:
        A structured time report or error message.
    """
    tz_identifier = resolve_timezone(city)

    if not tz_identifier:
        return {
            "status": "error",
            "error_message": f"Sorry, I don't have timezone information for {city}.",
        }

    tz = ZoneInfo(tz_identifier)
    now = datetime.datetime.now(tz)
    report = f'The current time in {city} is {now.strftime("%Y-%m-%d %H:%M:%S %Z%z")}'
    return {"status": "success", "report": report}


root_agent = Agent(
    name="weather_time_agent",
    model="gemini-2.5-flash",
    description=(
        "Agent to answer questions about the time and weather in a city."
    ),
    instruction=(
        "You are a helpful agent who can answer questions about the current "
        "time in supported cities. The weather tool does not have a live data "
        "provider; clearly tell users when weather data is unavailable."
    ),
    tools=[get_weather, get_current_time],
)
