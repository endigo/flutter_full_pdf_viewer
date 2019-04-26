package com.alveliu.flutterfullpdfviewer;

import android.app.Activity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.github.barteksc.pdfviewer.PDFView;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * FlutterFullPdfViewerManager
 */
class FlutterFullPdfViewerManager {

    boolean closed = false;
    PDFView pdfView;
    Activity activity;

    FlutterFullPdfViewerManager (final Activity activity) {
        this.pdfView = new PDFView(activity, null);
        this.activity = activity;
    }

    void openPDF(String path, MethodCall call) {
        File file = new File(path);

        pdfView.fromFile(file)
            .enableSwipe(getBoolean(call, "enableSwipe"))
            .swipeHorizontal(getBoolean(call, "swipeHorizontal"))
            .password(getString(call,"password"))
            .nightMode(getBoolean(call,"nightMode"))
            .autoSpacing(getBoolean(call,"autoSpacing"))
            .pageFling(getBoolean(call,"pageFling"))
            .pageSnap(getBoolean(call,"pageSnap"))
            .enableDoubletap(true)
            .defaultPage(0)
            .load();
    }

    void resize(FrameLayout.LayoutParams params) {
        pdfView.setLayoutParams(params);
    }

    void close(MethodCall call, MethodChannel.Result result) {
        if (pdfView != null) {
            ViewGroup vg = (ViewGroup) (pdfView.getParent());
            vg.removeView(pdfView);
        }
        pdfView = null;
        if (result != null) {
            result.success(null);
        }

        closed = true;
        FlutterFullPdfViewerPlugin.channel.invokeMethod("onDestroy", null);
    }

    void close() {
        close(null, null);
    }

    Boolean getBoolean(MethodCall call, String key) {
        return call.hasArgument(key) ? (Boolean) call.argument(key): false;
    }

    String getString(MethodCall call, String key) {
        return call.hasArgument(key) ? (String) call.argument(key) : "";
    }
}