#import "FlutterFullPdfViewerPlugin.h"
#import <flutter_full_pdf_viewer/flutter_full_pdf_viewer-Swift.h>

@implementation FlutterFullPdfViewerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFullPdfViewerPlugin registerWithRegistrar:registrar];
}
@end
