enum PlayerBackendType {
  handyStrokerStreamingBluetooth,
  handyStrokerStreamingWeb,
  handyStrokerCommand,
  buttplugStrokerCommand;

  String toDisplayString() {
    switch (this) {
      case PlayerBackendType.buttplugStrokerCommand:
        return "Buttplug Stroker";
      case PlayerBackendType.handyStrokerCommand:
        return "Handy HDSP (Command Based)";
      case PlayerBackendType.handyStrokerStreamingBluetooth:
        return "Handy HSP Bluetooth (Recommended)";
      case PlayerBackendType.handyStrokerStreamingWeb:
        return "Handy HSP Web";
    }
  }
}
