import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final void Function() onTap;
  final IconData icon;
  final Color color;

  const ActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.color,
    });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    // Botão com apenas ícone clicável
    return GestureDetector(
      onTap: widget.onTap,
      child: Icon(widget.icon, color: widget.color, size: 30),
    );
  }
}
