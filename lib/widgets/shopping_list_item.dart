import 'package:flutter/material.dart';
import '../models/shopping_item.dart';

class ShoppingListItem extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const ShoppingListItem({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggle,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, right: 12),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.primary.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  item.isDone
                      ? Icons.shopping_cart_checkout
                      : Icons.shopping_cart_outlined,
                  color: item.isDone ? color.primary : color.outline,
                  size: 32,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 0,
                  ),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.isDone
                          ? TextDecoration.lineThrough
                          : null,
                      color: item.isDone ? color.outline : color.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: item.isDone
                    ? Padding(
                        key: const ValueKey('done'),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: color.primary,
                          size: 28,
                        ),
                      )
                    : const SizedBox(width: 44),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: onDelete,
                color: color.error,
                splashRadius: 24,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
