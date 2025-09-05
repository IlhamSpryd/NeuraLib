import 'package:flutter/material.dart';

class SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: Colors.deepPurpleAccent[200],
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey[300],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade700, height: 1.2),
        ),
      ),
      dense: false,
    );
  }
}
