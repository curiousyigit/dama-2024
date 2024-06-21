import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:weight_app/app_view.dart';
import 'package:weight_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:weight_app/data/services/weight_app_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<WeightAppService> weightAppServiceFuture;

  @override
  void initState() {
    super.initState();
    weightAppServiceFuture = initWeightAppService();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeightAppService>(
      future: weightAppServiceFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return RepositoryProvider<AuthBloc>(
            create: (context) {
              final authBloc = AuthBloc(weightAppService: snapshot.data!);
              authBloc.add(AuthInitialized());
              return authBloc;
            },
            child: const MyAppView(),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<WeightAppService> initWeightAppService() async {
    String deviceName = await getDeviceName();

    if (kDebugMode) {
      return WeightAppService(
          apiBaseUrl: 'http://10.0.2.2:8000/api',
          deviceName: deviceName); // local
    }

    return WeightAppService(
        apiBaseUrl: 'http://3.71.87.226/api', deviceName: deviceName); // prod
  }
}

Future<String> getDeviceName() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  try {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  } catch (e) {
    log('Not Android');
  }

  try {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
  } catch (e) {
    log('Not iOS');
  }

  return 'Unknown Device';
}
