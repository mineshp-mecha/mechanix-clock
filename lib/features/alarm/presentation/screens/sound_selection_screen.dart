import 'package:flutter/material.dart';
import 'package:mechanix_clock/core/theme/app_theme.dart';
import 'package:mechanix_clock/l10n/app_localizations.dart';

class SoundSelectionScreen extends StatefulWidget {
  final String initialSound;
  const SoundSelectionScreen({super.key, required this.initialSound});

  @override
  State<SoundSelectionScreen> createState() => _SoundSelectionScreenState();
}

class _SoundSelectionScreenState extends State<SoundSelectionScreen> {
  late final ValueNotifier<String> _selectedSound;

  static const List<String> _sounds = [
    'Wakeup',
    'Siren',
    'Chasing Stars - Beyond the Horizon',
    'Dancing Flames (Urban Pulse)',
    'Silent Echo - Reflections of Time (Time mus...)',
    'Lost in Dreams - The Sound of Silence',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSound = ValueNotifier(widget.initialSound);
  }

  @override
  void dispose() {
    _selectedSound.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sound),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: _sounds.length,
        itemBuilder: (context, index) => _SoundTile(
          key: Key('sound_${_sounds[index]}'),
          sound: _sounds[index],
          selectedNotifier: _selectedSound,
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: AppColors.surface,
        child: Center(
          child: IconButton(
            key: const Key('sound_done_button'),
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedSound.value),
          ),
        ),
      ),
    );
  }
}

class _SoundTile extends StatelessWidget {
  final String sound;
  final ValueNotifier<String> selectedNotifier;

  const _SoundTile({
    super.key,
    required this.sound,
    required this.selectedNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(sound),
      leading: ValueListenableBuilder<String>(
        valueListenable: selectedNotifier,
        builder: (_, selected, _) => Icon(
          selected == sound ? Icons.check_circle : Icons.radio_button_unchecked,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: () => selectedNotifier.value = sound,
    );
  }
}
