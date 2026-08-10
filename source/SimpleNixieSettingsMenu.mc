import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Main settings menu shown when user selects "Customize" on the watch face
class SimpleNixieSettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => WatchUi.loadResource(Rez.Strings.AppName) as String});

        // 1. Show Battery
        var showBatt = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("showBattery");
            if (val != null) { showBatt = val as Boolean; }
        }
        var battLabel = WatchUi.loadResource(Rez.Strings.ShowBatteryTitle) as String;
        addItem(new WatchUi.ToggleMenuItem(battLabel, null, :showBattery, showBatt, null));

        // 2. Show Date
        var showDate = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("showDate");
            if (val != null) { showDate = val as Boolean; }
        }
        var dateLabel = WatchUi.loadResource(Rez.Strings.ShowDateTitle) as String;
        addItem(new WatchUi.ToggleMenuItem(dateLabel, null, :showDate, showDate, null));

        // 3. Show Graphs
        var showGraphs = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("showGraphs");
            if (val != null) { showGraphs = val as Boolean; }
        }
        var graphsLabel = WatchUi.loadResource(Rez.Strings.ShowGraphsTitle) as String;
        addItem(new WatchUi.ToggleMenuItem(graphsLabel, null, :showGraphs, showGraphs, null));

        // 4. Graph 1 Metric
        var graph1Metric = 1;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("graph1Metric");
            if (val != null) { graph1Metric = val as Number; }
        }
        var g1Label = WatchUi.loadResource(Rez.Strings.Graph1MetricTitle) as String;
        addItem(new WatchUi.MenuItem(g1Label, getMetricName(graph1Metric), :graph1Metric, null));

        // 4. Graph 2 Metric
        var graph2Metric = 2;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("graph2Metric");
            if (val != null) { graph2Metric = val as Number; }
        }
        var g2Label = WatchUi.loadResource(Rez.Strings.Graph2MetricTitle) as String;
        addItem(new WatchUi.MenuItem(g2Label, getMetricName(graph2Metric), :graph2Metric, null));
    }
}

function getMetricName(id as Number) as String {
    var resId = Rez.Strings.MetricOff;
    switch(id) {
        case 0: resId = Rez.Strings.MetricOff; break;
        case 1: resId = Rez.Strings.MetricHR; break;
        case 2: resId = Rez.Strings.MetricElev; break;
        case 3: resId = Rez.Strings.MetricPress; break;
        case 4: resId = Rez.Strings.MetricTemp; break;
        case 5: resId = Rez.Strings.MetricBodyBat; break;
        case 6: resId = Rez.Strings.MetricStress; break;
        case 7: resId = Rez.Strings.MetricPulseOx; break;
    }
    return WatchUi.loadResource(resId) as String;
}

// Delegate for the main settings menu
class SimpleNixieSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id == :showBattery) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showBattery", toggleItem.isEnabled());
            }
        } else if (id == :showDate) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showDate", toggleItem.isEnabled());
            }
        } else if (id == :showGraphs) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showGraphs", toggleItem.isEnabled());
            }
        } else if (id == :graph1Metric) {
            var title = WatchUi.loadResource(Rez.Strings.Graph1MetricTitle) as String;
            WatchUi.pushView(new MetricPickerMenu("graph1Metric", title), new MetricPickerDelegate("graph1Metric"), WatchUi.SLIDE_LEFT);
        } else if (id == :graph2Metric) {
            var title = WatchUi.loadResource(Rez.Strings.Graph2MetricTitle) as String;
            WatchUi.pushView(new MetricPickerMenu("graph2Metric", title), new MetricPickerDelegate("graph2Metric"), WatchUi.SLIDE_LEFT);
        }
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

// Reusable Sub-menu listing all metric options
class MetricPickerMenu extends WatchUi.Menu2 {
    function initialize(propertyKey as String, title as String) {
        Menu2.initialize({:title => title});
        
        var currentMetric = 0;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue(propertyKey);
            if (val != null) { currentMetric = val as Number; }
        }
        
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.MetricOff) as String, null, 0, currentMetric == 0, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.MetricHR) as String, null, 1, currentMetric == 1, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.MetricElev) as String, null, 2, currentMetric == 2, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.MetricPress) as String, null, 3, currentMetric == 3, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.MetricTemp) as String, null, 4, currentMetric == 4, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.MetricBodyBat) as String, null, 5, currentMetric == 5, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.MetricStress) as String, null, 6, currentMetric == 6, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.MetricPulseOx) as String, null, 7, currentMetric == 7, null));
    }
}

class MetricPickerDelegate extends WatchUi.Menu2InputDelegate {
    private var _propertyKey as String;

    function initialize(propertyKey as String) {
        Menu2InputDelegate.initialize();
        _propertyKey = propertyKey;
    }
    
    function onSelect(item as WatchUi.MenuItem) as Void {
        var selected = item.getId() as Number;
        if (Toybox.Application has :Properties) {
            Toybox.Application.Properties.setValue(_propertyKey, selected);
        }
        // Return all the way to the watchface
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
    
    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
