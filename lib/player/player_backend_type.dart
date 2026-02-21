enum PlayerBackendType {
  handyStrokerStreamingBluetooth,
  handyStrokerCommand,
  buttplugStrokerCommand;
  // handyStrokerStreamingWeb ??

  String toDisplayString() {
    switch (this) {
      case PlayerBackendType.buttplugStrokerCommand:
        return "Buttplug Stroker";
      case PlayerBackendType.handyStrokerCommand:
        return "Handy Native (Command Based)";
      case PlayerBackendType.handyStrokerStreamingBluetooth:
        return "Handy Native HSP (Recommended)";
    }
  }
}
