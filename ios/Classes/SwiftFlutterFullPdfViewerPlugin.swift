import Flutter
import UIKit
import PDFReader

public class SwiftFlutterFullPdfViewerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_full_pdf_viewer", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterFullPdfViewerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "launch":
        self.openPDF(call: call, result: result)
        break
      case "close":
        result("closing...");
        break
      case "resize":
        result("resizing...");
        break
      default: result(FlutterMethodNotImplemented)
    }
  }

  func openPDF(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
    guard
        let arguments = call.arguments as? [String: Any],
        let path = arguments["path"] as? String
        else { return }
    
    let url = URL(fileURLWithPath: path)
    // let rect = CGRect(x: data.rect['left'], y: data.rect['top'], width: data.rect['width'], height: data.rect['height'])
    
    
//    let controller = appDelegate.window!.rootViewController as? UIViewController

    guard let document = PDFDocument(url: url) else {return}
    let pdfViewController = PDFViewController.createNew(with: document, title: "Test Reader")
    
//    guard let collectionView = pdfViewController.collectionView else {return}
    
//    UIApplication.shared.keyWindow?.addSubview(pdfViewController.)
//    controller.
//    controller.add
    
    
//    navigationController?.pushViewController(controller, animated: true)
//    result(nil)
  }
}
