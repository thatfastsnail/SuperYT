import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:songtube/internal/global.dart';
import 'package:songtube/languages/languages.dart';
import 'package:songtube/providers/content_provider.dart';
import 'package:songtube/providers/media_provider.dart';
import 'package:songtube/providers/playlist_provider.dart';
import 'package:songtube/providers/ui_provider.dart';
import 'package:songtube/screens/home/home.dart';
import 'package:songtube/screens/intro/intro.dart';
import 'package:songtube/ui/components/fancy_scaffold.dart';
import 'package:songtube/ui/components/nested_will_pop_scope.dart';
import 'package:songtube/ui/players/music_player.dart';
import 'package:songtube/ui/players/video_player.dart';
import 'package:songtube/ui/themes/dark.dart';
import 'package:songtube/ui/themes/light.dart';

final internalNavigatorKey = GlobalKey<NavigatorState>();
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Initialize WidgetsBinding
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Global Variables
  await initGlobals();

  // Run App
  runApp(const SongTube());
}

class SongTube extends StatefulWidget {
  const SongTube({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_SongTubeState>();
    state!.setLocale(newLocale);
  }

  @override
  State<SongTube> createState() => _SongTubeState();
}

class _SongTubeState extends State<SongTube> {

  // Language
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UiProvider>(
          create: (context) => UiProvider()
        ),
        ChangeNotifierProvider<MediaProvider>(
          create: (context) => MediaProvider()
        ),
        ChangeNotifierProvider<PlaylistProvider>(
          create: (context) => PlaylistProvider()
        ),
        ChangeNotifierProvider<ContentProvider>(
          create: (context) => ContentProvider()
        ),
      ],
      child: Builder(
        builder: (context) {
    
          List<Locale> supportedLocales = [];
          for (var element in supportedLanguages) {
            supportedLocales.add(Locale(element.languageCode, ''));
          }

          // Load Providers
          UiProvider uiProvider = Provider.of(context);
          ContentProvider contentProvider = Provider.of(context);

          return MaterialApp(
    
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',
    
            // Locale Related Stuff
            locale: _locale,
            supportedLocales: supportedLocales,
            localizationsDelegates: [
              FallbackLocalizationDelegate(),
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
          
            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: lightTheme(),
            darkTheme: darkTheme(),
            themeMode: uiProvider.themeMode,
            home: StreamBuilder<MediaItem?>(
              stream: audioHandler.mediaItem,
              builder: (context, media) {
                return FancyScaffold(
                  resizeToAvoidBottomInset: false,
                  key: internalNavigatorKey,
                  body: NestedWillPopScope(
                    onWillPop: () async {
                      if (navigatorKey.currentState?.canPop() ?? false) {
                        navigatorKey.currentState?.pop();
                        return false;
                      }
                      return true;
                    },
                    child: Navigator(
                      key: navigatorKey,
                      onGenerateRoute: (settings) {
                        Widget widget;
                        // Manage your route names here
                        switch (settings.name) {
                          case 'intro':
                            widget = const IntroScreen();
                            break;
                          case 'home':
                            widget = const HomeScreen();
                            break;
                          default:
                            throw Exception('Invalid route: ${settings.name}');
                        }
                        // You can also return a PageRouteBuilder and
                        // define custom transitions between pages
                        return PageRouteBuilder(
                          settings: settings,
                          barrierColor: Colors.transparent,
                          transitionDuration: const Duration(milliseconds: 500),
                          reverseTransitionDuration: const Duration(milliseconds: 500),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return SharedAxisTransition(
                              fillColor: Colors.transparent,
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType: SharedAxisTransitionType.scaled,
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return widget;
                          }
                        );
                      },
                      initialRoute: initialRoute,
                    ),
                  ),
                  floatingWidgetConfig: const FloatingWidgetConfig(
                    backdropColor: Colors.black,
                    backdropEnabled: true,
                  ),
                  floatingWidgetController: uiProvider.fwController,
                  musicFloatingWidget: media.hasData && media.data != null ? const MusicPlayer() : null,
                  videoFloatingWidget: contentProvider.playingContent != null ? const VideoPlayer() : null,
                );
              }
            )
          );
        }
      ),
    );
  }
}