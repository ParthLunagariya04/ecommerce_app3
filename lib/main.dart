import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/exceptions/async_error_logger.dart';
import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/sembast_cart_repository.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();
  // * For more info on error handling, see:
  // * https://docs.flutter.dev/testing/errors
  WidgetsFlutterBinding.ensureInitialized();
  // turn off the # in the URLs on the web
  //GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  // * Entry point of the app
  final localCartRepository = await SembastCartRepository.makeDefault();
  final container = ProviderContainer(
    overrides: [
      localCartRepositoryProvider.overrideWithValue(localCartRepository),
    ],
    observers: [AsyncErrorLogger()],
  );
  container.read(cartSyncServiceProvider);
  final errorLogger = container.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);
  // * Entry point of the app
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );

  // * This code will present some error UI if any uncaught exception happens
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.presentError(details);
  // };
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.red,
  //       title: Text('An error occurred'.hardcoded),
  //     ),
  //     body: Center(child: Text(details.toString())),
  //   );
  // };

  // (Object error, StackTrace stack) {
  //   // * Log any errors to console
  //   debugPrint(error.toString());
  // });
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
