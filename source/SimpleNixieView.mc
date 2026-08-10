import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;
import Toybox.Time;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.SensorHistory;

class SimpleNixieView extends WatchUi.WatchFace {
    private var _nixieBitmaps as Array<WatchUi.BitmapResource> = new Array<WatchUi.BitmapResource>[10];
    private var _backgroundBitmap as WatchUi.BitmapResource?;
    private var _isAod as Boolean = false;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        _backgroundBitmap = WatchUi.loadResource(Rez.Drawables.BgImage) as WatchUi.BitmapResource;
        // Cache all 10 bitmaps in memory once to follow zero-allocation rules
        _nixieBitmaps[0] = WatchUi.loadResource(Rez.Drawables.Nixie0) as WatchUi.BitmapResource;
        _nixieBitmaps[1] = WatchUi.loadResource(Rez.Drawables.Nixie1) as WatchUi.BitmapResource;
        _nixieBitmaps[2] = WatchUi.loadResource(Rez.Drawables.Nixie2) as WatchUi.BitmapResource;
        _nixieBitmaps[3] = WatchUi.loadResource(Rez.Drawables.Nixie3) as WatchUi.BitmapResource;
        _nixieBitmaps[4] = WatchUi.loadResource(Rez.Drawables.Nixie4) as WatchUi.BitmapResource;
        _nixieBitmaps[5] = WatchUi.loadResource(Rez.Drawables.Nixie5) as WatchUi.BitmapResource;
        _nixieBitmaps[6] = WatchUi.loadResource(Rez.Drawables.Nixie6) as WatchUi.BitmapResource;
        _nixieBitmaps[7] = WatchUi.loadResource(Rez.Drawables.Nixie7) as WatchUi.BitmapResource;
        _nixieBitmaps[8] = WatchUi.loadResource(Rez.Drawables.Nixie8) as WatchUi.BitmapResource;
        _nixieBitmaps[9] = WatchUi.loadResource(Rez.Drawables.Nixie9) as WatchUi.BitmapResource;
    }

    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Clear screen with pure black for AMOLED power savings
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        if (!_isAod && _backgroundBitmap != null) {
            dc.drawBitmap(0, 0, _backgroundBitmap as WatchUi.BitmapResource);
        }
        
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;

        // Zero-allocation rule: do not instantiate new objects here.
        var h1 = hours / 10;
        var h2 = hours % 10;
        var m1 = minutes / 10;
        var m2 = minutes % 10;
        
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        var cx = screenWidth / 2;
        var lowerCenterY = screenHeight / 2;
        
        // Using "medium" digits scaled down to 95% (114x200)
        var imgW = 114;
        var w = 100; // Increased spacing (less overlap) to separate the tubes
        var h = 200; // Image height
        var colonW = 20; // Increased gap for the colon
        
        // Correct visual width calculation: 3 spaces of width 'w', plus colon, plus final image width
        var totalW = (w * 3) + colonW + imgW; // 365px total width
        var vfdStartX = cx - (totalW / 2);
        var vfdStartY = lowerCenterY - (h / 2);
        
        var primaryCol = 0xFF7A00; // Correct Theme 10 Amber color

        // AOD Burn-in Offset
        var aodOffsetX = 0;
        var aodOffsetY = 0;
        if (_isAod) {
            aodOffsetX = (minutes % 7) - 3;
            aodOffsetY = ((minutes / 7) % 7) - 3; 
        }

        // Draw Outer SOLID Heavy Amber Frame Border (4px solid stroke)
        // 12px padding on each side
        var frameWidth = totalW + 24; // 389
        var frameHeight = h + 24; // 203
        var frameY = lowerCenterY - (frameHeight / 2);

        // --- BATTERY WIDGET (Topmost) ---
        var showBatVal = Application.Properties.getValue("showBattery");
        var showBattery = (showBatVal != null) ? showBatVal as Boolean : true;
        if (!_isAod && showBattery) {
            var stats = System.getSystemStats();
            var batPct = stats.battery;
            var batStr = batPct.format("%d") + "%";
            var batFont = Graphics.FONT_XTINY; // Note: This is the smallest system font available
            var batTextW = dc.getTextWidthInPixels(batStr, batFont);
            
            var batIconW = 36; // 50% larger
            var batIconH = 18;
            var batGap = 8;
            var totalBatW = batIconW + batGap + batTextW;
            
            var batStartX = cx - (totalBatW / 2);
            var batStartY = 22; // Moved up, almost touching the top edge
            
            // Draw Battery Icon (Amber outline)
            dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
            dc.drawRectangle(batStartX, batStartY, batIconW, batIconH); // body
            dc.fillRectangle(batStartX + batIconW, batStartY + 5, 3, 8); // tip
            
            // Fill Battery (Amber)
            var fillW = ((batIconW - 2) * (batPct / 100.0)).toNumber();
            if (fillW > 0) {
                dc.fillRectangle(batStartX + 1, batStartY + 1, fillW, batIconH - 2);
            }
            
            // Draw Battery Text (White)
            var batTextY = batStartY + (batIconH / 2) - (dc.getFontHeight(batFont) / 2) - 1;
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(batStartX + batIconW + batGap, batTextY, batFont, batStr, Graphics.TEXT_JUSTIFY_LEFT);
        }

        // --- DATE WIDGET (Top) ---
        var showDateVal = Application.Properties.getValue("showDate");
        var showDate = (showDateVal != null) ? showDateVal as Boolean : true;
        if (!_isAod && showDate) {
            var dateTopY = frameY - 44; // Placed above the time frame
            
            var dateInfo = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
            var dayName = (dateInfo.day_of_week as String).toUpper();
            var dayNum = dateInfo.day.format("%02d");
            var monthName = (dateInfo.month as String).toUpper();
            
            var pillW = 86;
            var pillH = 36;
            var gap = 12;
            var totalDateW = (pillW * 3) + (gap * 2);
            var dateStartX = cx - (totalDateW / 2);
            
            // Draw 3 pills
            dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
            for (var i = 0; i < 3; i++) {
                var px = dateStartX + (i * (pillW + gap));
                dc.drawRoundedRectangle(px, dateTopY, pillW, pillH, 6);
            }
            
            // Draw text inside pills
            var font = Graphics.FONT_XTINY; // Much smaller font to fit inside pills
            var textY = dateTopY + (pillH / 2) - (dc.getFontHeight(font) / 2);
            
            // Day Name in White
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dateStartX + (pillW/2), textY, font, dayName, Graphics.TEXT_JUSTIFY_CENTER);
            
            // Day Number in Amber
            dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dateStartX + pillW + gap + (pillW/2), textY, font, dayNum, Graphics.TEXT_JUSTIFY_CENTER);
            
            // Month Name in White
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dateStartX + (pillW + gap)*2 + (pillW/2), textY, font, monthName, Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Draw Hours
        dc.drawBitmap(vfdStartX + aodOffsetX, vfdStartY + aodOffsetY, _nixieBitmaps[h1]);
        dc.drawBitmap(vfdStartX + w + aodOffsetX, vfdStartY + aodOffsetY, _nixieBitmaps[h2]);
        
        // Draw simple Amber colon (closer to Nixie filament color)
        var nixieGlowCol = 0xFF9900; // More yellowish orange for the glow
        dc.setColor(nixieGlowCol, Graphics.COLOR_TRANSPARENT);
        // Calculate exact center between the right edge of H2 and left edge of M1
        // (subtract 6 pixels because the visual center of the edited tubes is slightly offset)
        var colonX = vfdStartX + (w * 1.5) + (colonW / 2.0) + (imgW / 2.0) - 6 + aodOffsetX;
        dc.fillCircle(colonX, vfdStartY + 65 + aodOffsetY, 5);
        dc.fillCircle(colonX, vfdStartY + 135 + aodOffsetY, 5);
        
        // Draw Minutes
        dc.drawBitmap(vfdStartX + w*2 + colonW + aodOffsetX, vfdStartY + aodOffsetY, _nixieBitmaps[m1]);
        dc.drawBitmap(vfdStartX + w*3 + colonW + aodOffsetX, vfdStartY + aodOffsetY, _nixieBitmaps[m2]);

        // --- HEALTH WIDGETS (Bottom) - GRAPHS ---
        if (_isAod) { return; }
        
        var showGraphsVal = Application.Properties.getValue("showGraphs");
        var showGraphs = (showGraphsVal != null) ? showGraphsVal as Boolean : true;
        if (!showGraphs) { return; }

        var graphWidth = 150;
        var graphHeight = 75;
        var btmGap = 20;
        var btmTotalW = (graphWidth * 2) + btmGap;
        var btmStartX = cx - (btmTotalW / 2);
        var btmY = vfdStartY + h + 12; // Moved up to visually center between time and bottom edge

        // Graph Metrics
        var g1Val = Application.Properties.getValue("graph1Metric");
        var graph1Metric = (g1Val != null) ? g1Val as Number : 1;
        
        var g2Val = Application.Properties.getValue("graph2Metric");
        var graph2Metric = (g2Val != null) ? g2Val as Number : 2;

        // Graph 1 (Left)
        drawMetricGraph(dc, graph1Metric, btmStartX, btmY, graphWidth, graphHeight, primaryCol);

        // Graph 2 (Right)
        drawMetricGraph(dc, graph2Metric, btmStartX + graphWidth + btmGap, btmY, graphWidth, graphHeight, primaryCol);
    }

    private function drawMetricGraph(dc as Graphics.Dc, metric as Number, x as Number, y as Number, width as Number, height as Number, color as Number) as Void {
        if (metric == 0) { return; } // Off
        
        var iter = null;
        if (Toybox has :SensorHistory) {
            if (metric == 1 && Toybox.SensorHistory has :getHeartRateHistory) {
                iter = Toybox.SensorHistory.getHeartRateHistory({});
            } else if (metric == 2 && Toybox.SensorHistory has :getElevationHistory) {
                iter = Toybox.SensorHistory.getElevationHistory({});
            } else if (metric == 3 && Toybox.SensorHistory has :getPressureHistory) {
                iter = Toybox.SensorHistory.getPressureHistory({});
            } else if (metric == 4 && Toybox.SensorHistory has :getTemperatureHistory) {
                iter = Toybox.SensorHistory.getTemperatureHistory({});
            } else if (metric == 5 && Toybox.SensorHistory has :getBodyBatteryHistory) {
                iter = Toybox.SensorHistory.getBodyBatteryHistory({});
            } else if (metric == 6 && Toybox.SensorHistory has :getStressHistory) {
                iter = Toybox.SensorHistory.getStressHistory({});
            } else if (metric == 7 && Toybox.SensorHistory has :getOxygenSaturationHistory) {
                iter = Toybox.SensorHistory.getOxygenSaturationHistory({});
            }
        }
        
        if (iter != null) {
            drawHistoryGraph(dc, iter, x, y, width, height, color);
        }
    }

    private function drawHistoryGraph(dc as Graphics.Dc, iter as Toybox.SensorHistory.SensorHistoryIterator?, x as Number, y as Number, width as Number, height as Number, color as Number) as Void {
        if (iter == null) { return; }
        
        var min = 99999.0;
        var max = -99999.0;
        var samples = new [width] as Array<Float>;
        var count = 0;
        
        // Fetch up to 'width' samples (newest first)
        var sample = iter.next();
        while (sample != null && count < width) {
            var d = sample.data;
            if (d != null) {
                var val = 0.0;
                if (d instanceof Float) { val = d; }
                else if (d instanceof Number) { val = d.toFloat(); }
                samples[count] = val;
                if (val < min) { min = val; }
                if (val > max) { max = val; }
                count++;
            }
            sample = iter.next();
        }
        
        // Draw frame box
        dc.setColor(0x333333, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(x, y, width, height, 4);
        
        if (count < 2) { return; } // Not enough data
        
        var range = max - min;
        if (range <= 0) { range = 1.0; }
        
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        
        var prevPx = (x + width - 1) as Number;
        var prevPy = (y + height - 2 - (((samples[0] as Float - min) * (height - 4)) / range)).toNumber() as Number;
        
        for (var i = 1; i < count; i++) {
            var px = (x + width - 1 - i) as Number;
            var py = (y + height - 2 - (((samples[i] as Float - min) * (height - 4)) / range)).toNumber() as Number;
            // Draw line
            dc.drawLine(prevPx, prevPy, px, py);
            // Draw thick line by offset
            dc.drawLine(prevPx, prevPy + 1, px, py + 1);
            prevPx = px;
            prevPy = py;
        }
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
        _isAod = false;
        WatchUi.requestUpdate();
    }

    function onEnterSleep() as Void {
        _isAod = true;
        WatchUi.requestUpdate();
    }
}
