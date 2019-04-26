import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PDFViewState { shouldStart, startLoad, finishLoad }

/// Represents a general configuration object for tweaking how the PDF is viewed.
///
/// - [password]
///     The password in case of a password protected PDF.
/// - [xorDecryptKey]
///     The encryption key for a XOR encrypted file.
/// - [nightMode]
///     Whether to display PDF in night mode, with inverted colors.
/// - [enableSwipe]
///     Whether to allow swipe gesture to navigate across pages.
/// - [swipeHorizontal]
///     Whether to enable horizontal, instead of default, vertical navigation.
/// - [autoSpacing]
///     Whether to add dynamic spacing to fit each page on its own on the screen.
/// - [pageFling]
///     Whether to make a fling gesture change only a single page like ViewPager
/// - [pageSnap]
///     Whether to snap pages to screen boundaries.
/// - [enableImmersive]
///     Enables immersive mode, that hides the system UI.
///     This requires an API level of at least 19 (Kitkat 4.4).
/// - [videoPages]
///     A list of [VideoPage] objects, to be played as an overlay on the pdf.
/// - [pages]
///     A list of integers that indicates which pages have to be shown.
///     (page numbers start from 0)
///
///     If this is not supplied, then all pages are shown.
/// - [autoPlay]
///     Whether to automatically play the video when the user arrives at the page associated with the video.
///     This may lead to bad UX if used without [slideShow] enabled.
/// - [slideShow]
///     Emulate a slideshow like view, by enabling [swipeHorizontal], [autoSpacing], [pageFling] & [pageSnap].
class PdfViewerConfig {
  String password;
  String xorDecryptKey;
  bool nightMode;
  bool enableSwipe;
  bool swipeHorizontal;
  bool autoSpacing;
  bool pageFling;
  bool pageSnap;
  bool enableImmersive;
  bool autoPlay;
  List<int> pages;
  bool forceLandscape;

  PdfViewerConfig({
    this.password,
    this.xorDecryptKey,
    this.nightMode: false,
    this.enableSwipe: true,
    this.swipeHorizontal: false,
    this.autoSpacing: false,
    this.pageFling: false,
    this.pageSnap: false,
    this.enableImmersive: false,
    this.autoPlay: false,
    this.forceLandscape: false,
    slideShow: false,
    this.pages,
  }) {
    if (slideShow) {
      swipeHorizontal = autoSpacing = pageFling = pageSnap = true;
    }
  }

  /// creates a shallow copy of this config object.
  PdfViewerConfig copy() {
    return PdfViewerConfig(
      password: password,
      xorDecryptKey: xorDecryptKey,
      nightMode: nightMode,
      enableSwipe: enableSwipe,
      swipeHorizontal: swipeHorizontal,
      autoSpacing: autoSpacing,
      pageFling: pageFling,
      pageSnap: pageSnap,
      enableImmersive: enableImmersive,
      pages: pages,
      forceLandscape: forceLandscape,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'xorDecryptKey': xorDecryptKey,
      'nightMode': nightMode,
      'enableSwipe': enableSwipe,
      'swipeHorizontal': swipeHorizontal,
      'autoSpacing': autoSpacing,
      'pageFling': pageFling,
      'pageSnap': pageSnap,
      'enableImmersive': enableImmersive,
      'autoPlay': autoPlay,
      'pages': pages != null ? Int32List.fromList(pages) : null,
      'forceLandscape': forceLandscape,
    };
  }
}

class PDFViewerPlugin {
  final _channel = const MethodChannel("flutter_full_pdf_viewer");
  static PDFViewerPlugin _instance;

  factory PDFViewerPlugin() => _instance ??= new PDFViewerPlugin._();
  PDFViewerPlugin._() {
    _channel.setMethodCallHandler(_handleMessages);
  }

  final _onDestroy = new StreamController<Null>.broadcast();
  Stream<Null> get onDestroy => _onDestroy.stream;
  Future<Null> _handleMessages(MethodCall call) async {
    switch (call.method) {
      case 'onDestroy':
        _onDestroy.add(null);
        break;
    }
  }

  Future<Null> launch(String path, {Rect rect, PdfViewerConfig config}) async {
    final Map<String, dynamic> args = {'path': path};
    if (rect != null) {
      args['rect'] = {
        'left': rect.left,
        'top': rect.top,
        'width': rect.width,
        'height': rect.height
      };
    }
    if (config == null) {
      config = PdfViewerConfig();
    }
    args.addAll(config.toMap());

    await _channel.invokeMethod('launch', args);
  }

  /// Close the PDFViewer
  /// Will trigger the [onDestroy] event
  Future close() => _channel.invokeMethod('close');

  /// adds the plugin as ActivityResultListener
  /// Only needed and used on Android
  Future registerAcitivityResultListener() =>
      _channel.invokeMethod('registerAcitivityResultListener');

  /// removes the plugin as ActivityResultListener
  /// Only needed and used on Android
  Future removeAcitivityResultListener() =>
      _channel.invokeMethod('removeAcitivityResultListener');

  /// Close all Streams
  void dispose() {
    _onDestroy.close();
    _instance = null;
  }

  /// resize PDFViewer
  Future<Null> resize(Rect rect) async {
    final args = {};
    args['rect'] = {
      'left': rect.left,
      'top': rect.top,
      'width': rect.width,
      'height': rect.height
    };
    await _channel.invokeMethod('resize', args);
  }
}
