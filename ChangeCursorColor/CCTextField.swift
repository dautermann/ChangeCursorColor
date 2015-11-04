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
        
        customizeCaretColor()
    }
    
    override func resetCursorRects() {
        if let colorCursor = myColorCursor {
            self.addCursorRect(self.bounds, cursor: colorCursor)
        }
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        self.mouseIn = true
        
        customizeCaretColor()
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

    func customizeCaretColor() {
        // change the insertion caret to another color
        let fieldEditor = self.window?.fieldEditor(true, forObject: self) as! NSTextView

        fieldEditor.insertionPointColor = NSColor.redColor()
    }
    
    override func becomeFirstResponder() -> Bool {
        let rect = self.bounds
        let trackingArea = NSTrackingArea.init(rect: rect, options: [NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveAlways], owner: self, userInfo: nil)
        
        // keep track of where the mouse is within our text field
        self.setArea(trackingArea)
        
        if let ev = NSApp.currentEvent {
            if NSPointInRect(self.convertPoint(ev.locationInWindow, fromView: nil), self.bounds) {
                self.mouseIn = true
                myColorCursor?.set()
            }
        }
        
        return true
    }
}
