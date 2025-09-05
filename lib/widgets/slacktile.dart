import 'package:flutter/material.dart';

class SlackTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String valueLabel;
  final VoidCallback onTap;

  const SlackTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.valueLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade700, height: 1.2),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(valueLabel, style: TextStyle(color: Colors.grey.shade800)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}

class SlackOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SlackOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(label),
      trailing: selected ? const Icon(Icons.check) : null,
    );
  }
}
