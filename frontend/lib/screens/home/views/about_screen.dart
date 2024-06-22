import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.aboutText, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.studentName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Text('Shoaib Feda', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.studentNo,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Text('20895', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.librariesUsed,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Text('- bloc', style: TextStyle(fontSize: 16)),
              const Text('- flutter_bloc', style: TextStyle(fontSize: 16)),
              const Text('- equatable', style: TextStyle(fontSize: 16)),
              const Text('- flutter_localizations', style: TextStyle(fontSize: 16)),
              const Text('- intl', style: TextStyle(fontSize: 16)),
              const Text('- shared_preferences', style: TextStyle(fontSize: 16)),
              const Text('- cupertino_icons', style: TextStyle(fontSize: 16)),
              const Text('- http', style: TextStyle(fontSize: 16)),
              const Text('- device_info_plus', style: TextStyle(fontSize: 16)),
              const Text('- flutter_compass', style: TextStyle(fontSize: 16)),
              const Text('- permission_handler', style: TextStyle(fontSize: 16)),
              const Text('- geolocator', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}