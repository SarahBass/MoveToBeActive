//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application.Storage;

class AnalogSettingsView extends WatchUi.Menu2InputDelegate {

 	function initialize() {
        Menu2InputDelegate.initialize();
    }
	
	function onSelect(item) {
        // For IconMenuItems, we will change to the next icon state.
        // This demonstates a custom toggle operation using icons.
        // Static icons can also be used in this layout.
        System.println(item.getId());
        if(item instanceof IconMenuItem) {
            item.setSubLabel(item.getIcon().nextState());
        } else {
            Storage.setValue(item.getId(), item.isEnabled());       
        }
        
        WatchUi.requestUpdate();
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onDone() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
      
}

class AnalogSettingsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    
	// Add menu items for demonstrating toggles, checkbox and icon menu items
    //menu.addItem(new WatchUi.MenuItem("Toggles", "sublabel", "toggle", null));
    //menu.addItem(new WatchUi.MenuItem("Checkboxes", null, "check", null));
    //menu.addItem(new WatchUi.MenuItem("Icons", null, "icon", null));
    //menu.addItem(new WatchUi.MenuItem("Custom", null, "custom", null));
    //WatchUi.pushView(menu, new AnalogSettingsDelegate(), WatchUi.SLIDE_UP );

    // Generate a new Menu with a Text Title
    var iconMenu = new WatchUi.Menu2({:title=>"Config"});
    var drawable1 = new CustomIcon();
//    var drawable2 = new CustomIcon();
//    var drawable3 = new CustomIcon();
    iconMenu.addItem(new WatchUi.IconMenuItem("Accent Color", drawable1.getString(), 1, drawable1, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
    
    var boolean;
    if (Storage.getValue(3) != null ){
    	boolean = Storage.getValue(3);
    } else {
    	boolean = true;
    } 
    //ToggleMenuItem(label, subLabel, identifier, enabled, options)
    iconMenu.addItem(new WatchUi.ToggleMenuItem("Garmin Logo", {:enabled=>"ON", :disabled=>"OFF"}, 3, boolean, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
    boolean;
    if (Storage.getValue(4) != null ){
    	boolean = Storage.getValue(4);
    } else {
    	boolean = true;
    } 
    iconMenu.addItem(new WatchUi.ToggleMenuItem("Bluetooth Logo", {:enabled=>"ON", :disabled=>"OFF"}, 4, boolean, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
    iconMenu.addItem(new WatchUi.ToggleMenuItem("3,6,9,12 Numbers", {:enabled=>"ON", :disabled=>"OFF"}, 5, boolean, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
//    iconMenu.addItem(new WatchUi.IconMenuItem("Icon 2", drawable2.getString(), "right", drawable2, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
//    iconMenu.addItem(new WatchUi.IconMenuItem("Icon 3", drawable3.getString(), "default", drawable3, null));
    WatchUi.pushView(iconMenu, new AnalogSettingsView(), WatchUi.SLIDE_UP );  
		
	}

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }  

}


// This is the custom Icon drawable. It fills the icon space with a color to
// to demonstrate its extents. It changes color each time the next state is
// triggered, which is done when the item is selected in this application.
class CustomIcon extends WatchUi.Drawable {

    // This constant data stores the color state list.
    const mColors = [0x55FF00, 0xAAFF00, 0xFFFF00, Graphics.COLOR_BLUE, 0x00FFFF, 0xAA55FF, 0xFFAA00/*0xFF5500*/, 0xFF0000, 0xFF55FF, Graphics.COLOR_WHITE];
    const mColorStrings = ["Green", "Vivomove", "Yellow", "Blue", "Cyan", "Violet", "Orange", "Red", "Pink", "White"];
    var mIndex;

    function initialize() {
        Drawable.initialize({});
        if (Storage.getValue(2) == false or Storage.getValue(2) == null){ 
        	mIndex = 0;
        } else {
        	mIndex=Storage.getValue(2);
        }
    }

    // Return the color string for the menu to use as it's sublabel
    function getString() {
        return mColorStrings[mIndex];
    }
    
    // Return the color code to save in Storage
    function getColor() {
        return mColors[mIndex];
    }

    // Advance to the next color state for the drawable
    function nextState() {
        mIndex++;
        if(mIndex >= mColors.size()) {
            mIndex = 0;
        }
		Storage.setValue(1, getColor());
		Storage.setValue(2, mIndex);
        return mColorStrings[mIndex];
    }

    // Set the color for the current state and use dc.clear() to fill
    // the drawable area with that color
    function draw(dc) {
        var color = mColors[mIndex];
        dc.setColor(color, color);
        dc.clear();
    }
}
