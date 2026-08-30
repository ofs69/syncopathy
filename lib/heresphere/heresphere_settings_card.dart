import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/focus_numeric_input.dart';
import 'package:syncopathy/heresphere/heresphere_controller.dart';
import 'package:syncopathy/heresphere/heresphere_mode.dart';
import 'package:syncopathy/heresphere/heresphere_server.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';

/// Bind value meaning every IPv4 interface.
const String _anyAddress = '0.0.0.0';

/// Settings and status for the HereSphere streaming server.
///
/// Kept out of the settings page itself: the feature is self-contained and
/// experimental, and the page is long enough already.
class HereSphereSettingsBody extends StatefulWidget {
  const HereSphereSettingsBody({super.key});

  @override
  State<HereSphereSettingsBody> createState() => _HereSphereSettingsBodyState();
}

class _HereSphereSettingsBodyState extends State<HereSphereSettingsBody> {
  /// Addresses to offer as the one to type into the headset. Loaded once:
  /// enumerating interfaces on every rebuild would be wasteful, and they do not
  /// change often enough to matter.
  List<String> _hosts = const [];

  @override
  void initState() {
    super.initState();
    _loadHosts();
  }

  Future<void> _loadHosts() async {
    final hosts = await hereSphereCandidateHosts();
    if (mounted) setState(() => _hosts = hosts);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsModel>();
    final controller = context.read<HereSphereController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _warning(context),
        const SizedBox(height: 12),
        SignalBuilder(
          builder: (context) => SwitchListTile(
            title: const Text('Enable HereSphere server'),
            subtitle: const Text(
              'Lets HereSphere browse and stream this library over the local '
              'network.',
            ),
            value: settings.hereSphereEnabled.value,
            onChanged: (value) => settings.hereSphereEnabled.value = value,
            secondary: const Icon(Icons.cast),
            isThreeLine: true,
          ),
        ),
        SignalBuilder(
          builder: (context) {
            if (!settings.hereSphereEnabled.value) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _binding(context, settings),
                const SizedBox(height: 16),
                _status(context, controller),
                const SizedBox(height: 16),
                _addresses(context, controller),
                const SizedBox(height: 16),
                _signIn(context, settings, controller),
                const Divider(height: 32),
                _library(context, settings),
                const Divider(height: 32),
                _deviceOwner(context, settings),
                _deviceConflictWarning(context, settings),
                if (settings.hereSphereDeviceOwner.value.drivesDevice) ...[
                  const SizedBox(height: 8),
                  _timestampChannel(context, settings, controller),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  /// How the library itself is presented in the headset.
  Widget _library(BuildContext context, SettingsModel settings) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Library', style: theme.textTheme.titleSmall),
        ),
        SwitchListTile(
          value: settings.hereSphereDecorateThumbnails.value,
          onChanged: (value) =>
              settings.hereSphereDecorateThumbnails.value = value,
          title: const Text('Draw badges and a heatmap on thumbnails'),
          subtitle: const Text(
            'Shows the same badges as the media library, plus a strip of the '
            'funscript along the bottom edge. Costs a little time the first '
            'time each thumbnail is requested.',
          ),
          secondary: const Icon(Icons.image),
          isThreeLine: true,
        ),
      ],
    );
  }

  Widget _binding(BuildContext context, SettingsModel settings) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _interfacePicker(context, settings)),
        const SizedBox(width: 16),
        Expanded(
          child: FocusNumericInput(
            label: 'Port',
            value: settings.hereSpherePort.value.toDouble(),
            min: 1,
            max: 65535,
            onChanged: (value) => settings.hereSpherePort.value = value.round(),
          ),
        ),
      ],
    ),
  );

  /// Which address to bind.
  ///
  /// Binding one interface rather than all of them is the difference between
  /// offering the library to the network the headset is on and offering it to
  /// every network this machine is attached to.
  Widget _interfacePicker(BuildContext context, SettingsModel settings) {
    final selected = settings.hereSphereBindAddress.value;
    // An address the machine no longer has — a VPN that went away — would not
    // match any item, so it is kept in the list rather than silently changed.
    final options = <String>{_anyAddress, ..._hosts, selected}.toList();
    return DropdownButtonFormField<String>(
      initialValue: selected,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Listen on',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        for (final option in options)
          DropdownMenuItem(
            value: option,
            child: Text(
              option == _anyAddress ? 'All interfaces' : option,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null) settings.hereSphereBindAddress.value = value;
      },
    );
  }

  Widget _warning(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Experimental. While this is on, anyone who can reach the port '
              'and knows the address can stream your indexed media — the link '
              'is the only thing guarding it, so keep it to yourself and use '
              'it on a network you trust. Your firewall will ask to allow the '
              'connection.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The choice that decides which application commands the device.
  ///
  /// Presented as two mutually exclusive options rather than a toggle, because
  /// they are two different arrangements with different consequences — not one
  /// feature with an on and an off.
  Widget _deviceOwner(BuildContext context, SettingsModel settings) {
    final theme = Theme.of(context);
    final selected = settings.hereSphereDeviceOwner.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Funscript playback', style: theme.textTheme.titleSmall),
        ),
        const SizedBox(height: 4),
        RadioGroup<HereSphereDeviceOwner>(
          groupValue: selected,
          onChanged: (value) {
            if (value != null) settings.hereSphereDeviceOwner.value = value;
          },
          child: Column(
            children: [
              for (final owner in HereSphereDeviceOwner.values)
                RadioListTile<HereSphereDeviceOwner>(
                  value: owner,
                  title: Text(owner.label),
                  subtitle: Text(
                    owner.description,
                    style: theme.textTheme.bodySmall,
                  ),
                  isThreeLine: true,
                  dense: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Warns when both applications are set up to command the same device.
  ///
  /// Only one may. Syncopathy cannot tell what HereSphere is connected to, so
  /// it reports the half it does know — its own device connection — and offers
  /// to drop it, rather than leaving the user to work out why the strokes are
  /// fighting each other.
  Widget _deviceConflictWarning(BuildContext context, SettingsModel settings) {
    if (settings.hereSphereDeviceOwner.value.drivesDevice) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final playerModel = context.read<PlayerModel>();

    return SignalBuilder(
      builder: (context) {
        final backend = playerModel.playerBackend.value;
        if (backend == null || !backend.connected.value) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber,
                size: 20,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Syncopathy is still connected to a device. Two applications '
                  'commanding one device fight each other.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: playerModel.disconnectBackend,
                child: const Text('Disconnect'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Where to reach HereSphere's timestamp server, and whether we are reaching
  /// it. Only shown in the mode that needs it.
  Widget _timestampChannel(
    BuildContext context,
    SettingsModel settings,
    HereSphereController controller,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Timestamp connection', style: theme.textTheme.titleSmall),
          Text(
            'HereSphere publishes its clock on a port Syncopathy connects out '
            'to. Syncopathy follows that clock, and stops the device whenever '
            'the connection is lost.',
            style: theme.textTheme.bodySmall,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Find HereSphere automatically'),
            subtitle: Text(_autoDetectSubtitle(controller)),
            value: settings.hereSphereTimestampAutoDetect.value,
            onChanged: (value) =>
                settings.hereSphereTimestampAutoDetect.value = value,
            dense: true,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: settings.hereSphereTimestampAutoDetect.value
                    ? InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'HereSphere address',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        child: Text(
                          controller.timestampHost.value.isEmpty
                              ? 'Waiting for a headset to connect'
                              : controller.timestampHost.value,
                          style: controller.timestampHost.value.isEmpty
                              ? theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.disabledColor,
                                )
                              : null,
                        ),
                      )
                    : TextFormField(
                        initialValue: settings.hereSphereTimestampHost.value,
                        decoration: const InputDecoration(
                          labelText: 'HereSphere address',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (value) =>
                            settings.hereSphereTimestampHost.value = value,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FocusNumericInput(
                  label: 'Port',
                  value: settings.hereSphereTimestampPort.value.toDouble(),
                  min: 1,
                  max: 65535,
                  onChanged: (value) =>
                      settings.hereSphereTimestampPort.value = value.round(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _channelStatus(context, controller),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Let Syncopathy control HereSphere'),
            subtitle: const Text(
              'Sends seek, play/pause and speed back to the player. Off by '
              'default: watching a player and steering it are different '
              'things, and only this one reaches out.',
            ),
            value: settings.hereSphereAllowRemoteControl.value,
            onChanged: (value) =>
                settings.hereSphereAllowRemoteControl.value = value,
            isThreeLine: true,
            dense: true,
          ),
        ],
      ),
    );
  }

  /// Says what auto-detection has found, so the switch is not a claim the user
  /// has to take on trust.
  static String _autoDetectSubtitle(HereSphereController controller) {
    final found = controller.server.clientAddress.value;
    return found == null
        ? 'Uses the address of whichever headset signs in. None has yet.'
        : 'Using $found, the headset signed in to the media server.';
  }

  Widget _channelStatus(BuildContext context, HereSphereController controller) {
    final theme = Theme.of(context);
    return SignalBuilder(
      builder: (context) {
        final healthy = controller.timestamps.healthy.value;
        final socket = controller.timestamps.socketConnected.value;
        final error = controller.timestamps.lastError.value;
        final external = controller.externalPlaybackActive.value;

        final (icon, color, label) = switch ((healthy, socket)) {
          (true, _) => (
            Icons.check_circle,
            theme.colorScheme.primary,
            external
                ? 'Following HereSphere\'s clock.'
                : 'Connected. Waiting for HereSphere to open a video.',
          ),
          // A socket that is open but silent is no better than a closed one:
          // nothing is correcting the clock either way.
          (false, true) => (
            Icons.pause_circle_outline,
            theme.colorScheme.error,
            'Connected, but HereSphere has stopped reporting. The device is '
                'held until it resumes.',
          ),
          (false, false) => (
            Icons.error_outline,
            theme.colorScheme.error,
            error ?? 'Not connected. The device stays stopped.',
          ),
        };

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: color),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _status(BuildContext context, HereSphereController controller) {
    final theme = Theme.of(context);
    return SignalBuilder(
      builder: (context) {
        final state = controller.server.state.value;
        final error = controller.server.lastError.value;
        final client = controller.server.connectedClient.value;

        final (icon, color, label) = switch (state) {
          HereSphereServerState.running => (
            Icons.check_circle,
            theme.colorScheme.primary,
            client == null
                ? 'Listening. No client has connected yet.'
                : 'Listening. Connected to $client.',
          ),
          HereSphereServerState.starting => (
            Icons.hourglass_empty,
            theme.colorScheme.onSurfaceVariant,
            'Starting…',
          ),
          HereSphereServerState.failed => (
            Icons.error_outline,
            theme.colorScheme.error,
            error ?? 'Failed to start.',
          ),
          HereSphereServerState.stopped => (
            Icons.stop_circle_outlined,
            theme.colorScheme.onSurfaceVariant,
            'Stopped.',
          ),
        };

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _addresses(BuildContext context, HereSphereController controller) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Open this in HereSphere', style: theme.textTheme.titleSmall),
          SignalBuilder(
            builder: (context) => Text(
              // Which interface a headset can reach is not something this
              // machine can work out, so every address the server is listening
              // on is offered rather than one being guessed at.
              _reachableHosts(context).length > 1
                  ? 'Try the address on the same network as your headset. '
                        '127.0.0.1 only works on this machine.'
                  : 'Enter this address in HereSphere\'s web browser.',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          SignalBuilder(
            builder: (context) => Column(
              children: [
                for (final host in _reachableHosts(context))
                  _addressRow(context, controller, host),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The credentials HereSphere is prompted for, and what to do about them.
  ///
  /// The password is stored as a hash, so it cannot be shown again once set.
  /// That is the trade: a settings file that leaks reveals nothing usable, at
  /// the cost of having to set a new password rather than look the old one up.
  Widget _signIn(
    BuildContext context,
    SettingsModel settings,
    HereSphereController controller,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sign-in', style: theme.textTheme.titleSmall),
          Text(
            'HereSphere asks for these the first time it opens the address '
            'above, then remembers them.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: settings.hereSphereUsername.value,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => settings.hereSphereUsername.value = value,
          ),
          const SizedBox(height: 12),
          SignalBuilder(
            builder: (context) {
              final hasPassword = settings.hereSphereHasPassword.value;
              return Row(
                children: [
                  Icon(
                    hasPassword ? Icons.lock : Icons.lock_open,
                    size: 20,
                    color: hasPassword
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasPassword
                          ? 'Password set.'
                          // Not an open server: with no password nobody can
                          // log in at all, which is the safe end to fail at.
                          : 'No password set — nobody can connect until you '
                                'set one.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: hasPassword
                            ? theme.colorScheme.primary
                            : theme.colorScheme.error,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _setPassword(context, controller),
                    child: Text(hasPassword ? 'Change' : 'Set password'),
                  ),
                ],
              );
            },
          ),
          SignalBuilder(
            builder: (context) {
              final signedIn = controller.server.activeSessions.value;
              if (signedIn == 0) return const SizedBox.shrink();
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      signedIn == 1
                          ? '1 device signed in.'
                          : '$signedIn devices signed in.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.signOutAllDevices,
                    child: const Text('Sign out all'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Addresses that will actually answer, given what the server is bound to.
  ///
  /// Listing an interface the server is not listening on would hand the user a
  /// link that silently fails.
  List<String> _reachableHosts(BuildContext context) {
    final bound = context.read<SettingsModel>().hereSphereBindAddress.value;
    // Bound to one address, that address is the only one that answers —
    // whether or not it is still among this machine's interfaces.
    return bound == _anyAddress ? _hosts : [bound];
  }

  Widget _addressRow(
    BuildContext context,
    HereSphereController controller,
    String host,
  ) {
    final url = controller.urlFor(host);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              url,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            tooltip: 'Copy',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: url));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Address copied.')));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _setPassword(
    BuildContext context,
    HereSphereController controller,
  ) async {
    final password = await showDialog<String>(
      context: context,
      builder: (context) => const _PasswordDialog(),
    );
    if (password == null || password.isEmpty) return;
    await controller.setPassword(password);
  }
}

/// Asks for a new password, with a generator for people who would rather not
/// invent one.
///
/// Revealing is opt-in and only lasts while the dialog is open: after this the
/// password exists nowhere Syncopathy can read it, so anyone who needs it later
/// sets a new one.
class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog();

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _obscured = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set HereSphere password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You will type this into HereSphere once. Syncopathy stores only a '
            'hash of it, so it cannot be shown again — if you lose it, set a '
            'new one.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            obscureText: _obscured,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscured ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                ),
                tooltip: _obscured ? 'Show' : 'Hide',
                onPressed: () => setState(() => _obscured = !_obscured),
              ),
            ),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                // Revealed on generate: a password nobody can read is no use
                // when it has to be typed into a headset.
                setState(() {
                  _controller.text = generateHereSpherePassword();
                  _obscured = false;
                });
              },
              icon: const Icon(Icons.casino_outlined, size: 18),
              label: const Text('Generate one'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
