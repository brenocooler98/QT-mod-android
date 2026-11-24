package qtmod;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import org.haxe.extension.Extension;

public class ScreenStyle {
    private static boolean full = false;

    public static void apply(boolean value) {
        full = value;
        final Activity activity = Extension.mainActivity;
        if (activity == null)
            return;

        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    applyToWindow(activity);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private static void applyToWindow(Activity activity) {
        Window window = activity.getWindow();
        if (window == null)
            return;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            WindowManager.LayoutParams params = window.getAttributes();
            params.layoutInDisplayCutoutMode = full
                    ? WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
                    : WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_DEFAULT;
            window.setAttributes(params);
        }

        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_FULLSCREEN
                | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
    }

    public static void restart() {
        final Activity activity = Extension.mainActivity;
        if (activity == null)
            return;

        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    Intent launch = activity.getPackageManager().getLaunchIntentForPackage(activity.getPackageName());
                    if (launch == null || launch.getComponent() == null)
                        return;

                    Intent intent = Intent.makeRestartActivityTask(launch.getComponent());
                    activity.startActivity(intent);
                    activity.finishAffinity();
                    android.os.Process.killProcess(android.os.Process.myPid());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public static boolean isFull() {
        return full;
    }

    private static DisplayMetrics getRealMetrics() {
        DisplayMetrics metrics = new DisplayMetrics();
        try {
            Activity activity = Extension.mainActivity;
            if (activity != null)
                activity.getWindowManager().getDefaultDisplay().getRealMetrics(metrics);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return metrics;
    }

    public static int getScreenWidth() {
        DisplayMetrics metrics = getRealMetrics();
        return Math.max(metrics.widthPixels, metrics.heightPixels);
    }

    public static int getScreenHeight() {
        DisplayMetrics metrics = getRealMetrics();
        return Math.min(metrics.widthPixels, metrics.heightPixels);
    }
}
