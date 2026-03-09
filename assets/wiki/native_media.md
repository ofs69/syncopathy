# Getting Started
  - Add a media library path under `Settings` -> `Media Library Paths` -> `Add Media Path`.
  - Click `Refresh` in the top-right corner of the `Media` tab to scan the path recursively for media and `.funscript` files.
  - Connect your device and play videos from the media library.
  - To skip media library management, start the application with `-s` or `--simple`.

# Video Players
  - Syncopathy has two video player modes: embedded and external.
  - External mode is the default. It opens `mpv` in a separate window that you can move freely.
  - Embedded mode shows the `mpv` video inside the `Video Player` tab instead of opening a separate window.

# Connecting your device
  - Choose one of four device backends.
  - If you use The Handy, choose Handy HSP (Bluetooth or Web).
    - Use exclusive Bluetooth mode (pulsing blue LED 🔵) or exclusive Wi-Fi mode (constant magenta LED 🟣).
    - Do not use hybrid mode, which alternates between blue 🔵 and magenta 🟣.
  - The Handy HDSP backend is similar to using The Handy with Buttplug, except it does not require Intiface.
  - For other devices, use Buttplug Stroker.
    - This requires Intiface, and your device must be connected through it.
