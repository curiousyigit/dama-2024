// reference: https://github.com/mitchkoko/FlutterCompass

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  bool _hasPermission = false;
  Position? currentLocation;

  @override
  void initState() {
    super.initState();

    _fetchPermissionStatus();
    _locateDevice();
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() {
          _hasPermission = (status == PermissionStatus.granted);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.compass),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Builder(builder: (context) {
        if (_hasPermission) {
          return _buildCompass();
        } else {
          return _buildPermissionScreen(context);
        }
      }),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error reading compass!');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          double? direction = snapshot.data!.heading;

          if (direction == null) {
            return const Center(child: Text('Device does not have compass!'));
          }



          return LayoutBuilder(
            builder: (context, constraints) {
              final double imageSize = constraints.maxWidth * 0.6;
              final double trueAngle =
                  direction < 0 ? 360 + direction : direction;

              return Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding:
                        const EdgeInsets.all(20), // Adjust padding if necessary
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: direction * (math.pi / 180) * -1,
                          child: Image.asset(
                            'assets/images/compass.png',
                            width: imageSize, // Use calculated size
                            height: imageSize, // Maintain aspect ratio
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${trueAngle.toStringAsFixed(0)}º',
                          style: TextStyle(
                            fontSize: constraints.maxWidth *
                                0.05, // Adjust text size based on screen width
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (currentLocation != null) ...{
                          Text('${currentLocation!.latitude.abs()}º ${currentLocation!.latitude >= 0 ? 'N' : 'S'}, ${currentLocation!.longitude.abs()}º ${currentLocation!.longitude >= 0 ? 'E' : 'W'}'),
                        } else ... {
                          Text(AppLocalizations.of(context)!.loadingLocation),
                        }
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _buildPermissionScreen(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(AppLocalizations.of(context)!.grantPermission),
        onPressed: () {
          Permission.locationWhenInUse.request().then((value) {
            _fetchPermissionStatus();
          });
        },
      ),
    );
  }

  _locateDevice() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      setState(() async {
        currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      });
    }
  }
}
