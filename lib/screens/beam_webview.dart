import 'dart:async';

import 'package:beam/provider/theme_provider.dart';
import 'package:beam/widgets/welcome_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// import '../widgets/molecules/debug_menu.dart';

class CustomWebChromeClient {
  static const MethodChannel _channel =
      MethodChannel('com.example.beam/webview');

  static Future<void> setDefaultVideoPoster() async {
    await _channel.invokeMethod('setDefaultVideoPoster');
  }
}

class BeamWebview extends StatefulWidget {
  const BeamWebview({super.key});

  @override
  State<BeamWebview> createState() => _BeamWebviewState();
}

class _BeamWebviewState extends State<BeamWebview> {
  late final WebViewController _controller;
  bool _isWebViewLoaded = false; // Add this line

  @override
  void initState() {
    super.initState();

    // platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (WebViewPermissionRequest request) {
        request.grant();
      },
    );
    // platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');

            // Call once when the app just loaded.
            if (!_isWebViewLoaded) {
              FlutterNativeSplash.remove();
              startPollingForThemeChange();
              removeDefaultVideoPoster();
              setState(() {
                _isWebViewLoaded = true;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
            onScanPage(change.url);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Debug',
        onMessageReceived: (JavaScriptMessage message) {
          printWrapped(message.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..addJavaScriptChannel(
        'THEME',
        onMessageReceived: (JavaScriptMessage message) {
          final themeMode = _parseThemeMode(message.message);
          Provider.of<ThemeProvider>(context, listen: false)
              .setThemeMode(themeMode);
          _saveThemePreference(themeMode);
        },
      )
      ..loadRequest(Uri.parse('https://beam.eco'));

    CustomWebChromeClient.setDefaultVideoPoster();

    // platform_features
    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }
    // platform_features

    // platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // platform_features

    _controller = controller;

    removeVideoPlayIcon();
  }

  ThemeMode _parseThemeMode(String themeStr) {
    switch (themeStr) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  // FIXME:
  void printWrapped(String text) =>
      RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2D2E30),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  // Use Theme.of(context).brightness to check if the theme is dark or light
                  // and adjust the color accordingly.
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xff1C1E21) // Dark theme color
                      : const Color(
                          0xFFF9F9F9), // Light theme color, adjust as needed
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  // Similarly, adjust this color based on the theme.
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xff2D2E30) // Dark theme color
                      : const Color(
                          0xFFFFFFFF), // Light theme color, adjust as needed
                ),
              ),
            ],
          ),
          SafeArea(
            child: WebViewWidget(controller: _controller),
          ),
          FutureBuilder(
            future: seenWelcomeSheet(),
            builder: (x, y) {
              if (!y.hasData) return const WelcomeSheet();
              return y.data! ? const SizedBox.shrink() : const WelcomeSheet();
            },
          )
        ],
      ),
      // floatingActionButton: DebugMenu(webViewController: _controller),
    );
  }

  void onScanPage(String? page) async {
    if (page != "https://beam.eco/scan") return;
    removeVideoPlayIcon();
  }

  Future<bool> seenWelcomeSheet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var storedTheme = preferences.getString('seenWelcomeSheet');
    return storedTheme == "true";
  }

  Future<void> _saveThemePreference(ThemeMode themeMode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('theme', themeMode.toString().split('.').last);
  }

  Future<void> removeVideoPlayIcon() async {
    const String removeVideoPlayIconScript = """
      (function() {
        // Select all video elements
        const videoElements = document.querySelectorAll('video');

        // Set the poster attribute for each video element
        videoElements.forEach(video => {
          // Option 1: Set a transparent GIF as the poster
          video.poster = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

          // Option 2: Set the video tag color to black
          video.style.backgroundColor = 'black';
        });
      })();
    """;

    // Use the flag to check if the webview is ready before running the script
    if (_isWebViewLoaded) {
      _controller.runJavaScript(removeVideoPlayIconScript);
    }
  }

  Future<void> reloadWindow() async {
    const String reloadScript = """
    window.location.reload();
  """;

    if (_isWebViewLoaded) {
      await _controller.runJavaScript(reloadScript);
    }
  }

  Future<void> startPollingForThemeChange() async {
    const String checkThemeScript = """
    (function() {
      const currentTheme = localStorage.getItem('theme');
      THEME.postMessage(currentTheme);
    })();
  """;

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      // Use the flag to check if the webview is ready before running the script
      if (_isWebViewLoaded) {
        _controller.runJavaScript(checkThemeScript);
      }
    });
  }

  removeDefaultVideoPoster() {
    const String setupMutationObserver = """
    (() => {
      const observer = new MutationObserver((mutationsList, observer) => {
        for (let mutation of mutationsList) {
          if (mutation.type === 'childList') {
            const addedNodes = mutation.addedNodes;
            for (let node of addedNodes) {
              if (node.nodeType === Node.ELEMENT_NODE) {
                const videoElements = node.querySelectorAll('video');
                videoElements.forEach(video => {
                  video.setAttribute('poster', 'nope');
                });
              }
            }
          }
        }
      });

      // Configure the observer options
      const observerOptions = {
        childList: true,
        subtree: true
      };

      // Start observing the target node (e.g., document.body) with the configured options
      observer.observe(document.body, observerOptions);
    })()
  """;

    _controller.runJavaScript(setupMutationObserver);
  }
}
