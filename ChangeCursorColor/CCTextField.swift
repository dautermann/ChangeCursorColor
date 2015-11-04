//
//  CCTextField.swift
//  ChangeCursorColor
//
//  Created by Michael Dautermann on 11/4/15.
//  Copyright © 2015 Michael Dautermann. All rights reserved.
//

import Cocoa

class CCTextField: NSTextField {

    var myColorCursor : NSCursor?
    
    var mouseIn : Bool = false
    
    var trackingArea : NSTrackingArea?
    
    override func awakeFromNib()
    {
        myColorCursor = NSCursor.init(image: NSImage(named:"heart")!, hotSpot: NSMakePoint(0.0, 0.0))
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func resetCursorRects() {
        if let colorCursor = myColorCursor {
            self.addCursorRect(self.bounds, cursor: colorCursor)
        }
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        self.mouseIn = true
    }

    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent)
        self.mouseIn = false
    }

    override func mouseMoved(theEvent: NSEvent) {
        if self.mouseIn {
            myColorCursor?.set()
        }
        super.mouseMoved(theEvent)
    }
    
    func setArea(areaToSet: NSTrackingArea?)
    {
        if let formerArea = trackingArea {
            self.removeTrackingArea(formerArea)
        }
        
        if let newArea = areaToSet {
            self.addTrackingArea(newArea)
        }
        trackingArea = areaToSet
    }
    
    override func becomeFirstResponder() -> Bool {
        let rect = self.bounds
        let trackingArea = NSTrackingArea.init(rect: rect, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveAlways], owner: self, userInfo: nil)
        
        self.setArea(trackingArea)
        
        if let ev = NSApp.currentEvent {
            if NSPointInRect(self.convertPoint(ev.locationInWindow, fromView: nil), self.bounds) {
                self.mouseIn = true
                
                // This is a workaround for the private call that resets the IBeamCursor
                myColorCursor?.performSelector("set")
            }
        }
        return true
    }
}
