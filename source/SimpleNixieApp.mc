import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SimpleNixieApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [ new SimpleNixieView() ];
    }

    // Triggered when settings are changed from Garmin Connect
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    // On-device settings: shows "Customize" in the watch face long-press menu
    function getSettingsView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] or Null {
        return [ new SimpleNixieSettingsMenu(), new SimpleNixieSettingsDelegate() ];
    }
}

function getApp() as SimpleNixieApp {
    return Application.getApp() as SimpleNixieApp;
}
