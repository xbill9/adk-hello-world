import importlib.util
import pathlib
import sys
import types
import unittest
from unittest import mock


AGENT_PATH = (
    pathlib.Path(__file__).parents[1]
    / "src"
    / "agents"
    / "adk_hello_world"
    / "agent.py"
)


class FakeAgent:
    def __init__(self, **kwargs):
        self.kwargs = kwargs


def load_agent_module():
    google = types.ModuleType("google")
    adk = types.ModuleType("google.adk")
    agents = types.ModuleType("google.adk.agents")
    agents.Agent = FakeAgent

    spec = importlib.util.spec_from_file_location("agent_under_test", AGENT_PATH)
    module = importlib.util.module_from_spec(spec)
    with mock.patch.dict(
        sys.modules,
        {
            "google": google,
            "google.adk": adk,
            "google.adk.agents": agents,
        },
    ):
        spec.loader.exec_module(module)
    return module


agent = load_agent_module()


class AgentToolTests(unittest.TestCase):
    def test_known_city_resolves_timezone(self):
        self.assertEqual(agent.resolve_timezone("NYC"), "America/New_York")

    def test_dotted_city_resolves_timezone(self):
        self.assertEqual(agent.resolve_timezone("Washington D.C."), "America/New_York")

    def test_iana_timezone_is_accepted(self):
        self.assertEqual(
            agent.resolve_timezone("Europe/London"),
            "Europe/London",
        )

    def test_unknown_city_returns_time_error(self):
        result = agent.get_current_time("Definitely Not A City")
        self.assertEqual(result["status"], "error")

    def test_time_uses_resolved_timezone(self):
        result = agent.get_current_time("Tokyo")
        self.assertEqual(result["status"], "success")
        self.assertIn("JST", result["report"])

    def test_weather_does_not_fabricate_observations(self):
        result = agent.get_weather("New York")
        self.assertEqual(result["status"], "error")
        self.assertIn("no weather data provider", result["error_message"])


if __name__ == "__main__":
    unittest.main()
