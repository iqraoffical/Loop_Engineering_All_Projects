import datetime

def send_heartbeat(component_name: str):
    """Logs a heartbeat signal for a given component."""
    timestamp = datetime.datetime.now().isoformat()
    print(f"[{timestamp}] Heartbeat: {component_name} is alive.")

if __name__ == "__main__":
    send_heartbeat("Heartbeat_Test")
