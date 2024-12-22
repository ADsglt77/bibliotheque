import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? jacketPath;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final String? userRole;
  final bool displayJacket;

  const CustomCard({
    required this.title,
    required this.subtitle,
    this.jacketPath,
    this.onTap,
    this.onDelete,
    super.key,
    this.userRole,
    this.displayJacket = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: displayJacket && jacketPath != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            File(jacketPath!),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.red,
              );
            }
          ),
        )
            : (displayJacket
            ? const Icon(
          Icons.book,
          size: 50,
          color: Colors.blueGrey,
        )
            : null),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userRole == 'admin')
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onTap,
              ),
            if (userRole == 'admin')
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: onDelete,
              ),
          ],
        )
      ),
    );
  }
}