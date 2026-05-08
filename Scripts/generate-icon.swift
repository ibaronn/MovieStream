#!/usr/bin/swift

import Cocoa

let s = CGSize(width: 1024, height: 1024)
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "MovieStream/Resources/Assets.xcassets/AppIcon.appiconset/icon.png"

let img = NSImage(size: s); img.lockFocus()
guard let ctx = NSGraphicsContext.current?.cgContext else { fatalError() }

// Deep gradient background
let bgColors = [
    CGColor(red: 0.15, green: 0.10, blue: 0.25, alpha: 1),
    CGColor(red: 0.05, green: 0.04, blue: 0.10, alpha: 1),
    CGColor(red: 0.02, green: 0.01, blue: 0.04, alpha: 1),
]
let bgGrad = CGGradient(colorsSpace: nil, colors: bgColors as CFArray, locations: [0, 0.5, 1])!
ctx.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: 0), end: CGPoint(x: s.width, y: s.height), options: [])

// Subtle radial glow behind icon
let glowGrad = CGGradient(colorsSpace: nil, colors: [
    CGColor(red: 0.95, green: 0.78, blue: 0.22, alpha: 0.15),
    CGColor(red: 0.95, green: 0.78, blue: 0.22, alpha: 0),
] as CFArray, locations: [0, 1])!
ctx.drawRadialGradient(glowGrad, startCenter: CGPoint(x: 512, y: 440), startRadius: 0, endCenter: CGPoint(x: 512, y: 440), endRadius: 380, options: [])

// Outer ring
ctx.setStrokeColor(CGColor(red: 0.95, green: 0.78, blue: 0.22, alpha: 0.3))
ctx.setLineWidth(4)
ctx.strokeEllipse(in: CGRect(x: 306, y: 234, width: 412, height: 412))

// Play button circle
ctx.setShadow(offset: .zero, blur: 40, color: CGColor(red: 0.95, green: 0.78, blue: 0.22, alpha: 0.5))
let circleGrad = CGGradient(colorsSpace: nil, colors: [
    CGColor(red: 1, green: 0.85, blue: 0.35, alpha: 1),
    CGColor(red: 0.95, green: 0.78, blue: 0.22, alpha: 1),
    CGColor(red: 0.85, green: 0.65, blue: 0.10, alpha: 1),
] as CFArray, locations: [0, 0.5, 1])!
ctx.saveGState()
ctx.addEllipse(in: CGRect(x: 312, y: 240, width: 400, height: 400))
ctx.clip()
ctx.drawLinearGradient(circleGrad, start: CGPoint(x: 312, y: 240), end: CGPoint(x: 712, y: 640), options: [])
ctx.restoreGState()

// Inner shadow effect on circle
ctx.setStrokeColor(CGColor(red: 1, green: 0.9, blue: 0.5, alpha: 0.6))
ctx.setLineWidth(3)
ctx.strokeEllipse(in: CGRect(x: 314, y: 242, width: 396, height: 396))

ctx.setShadow(offset: .zero, blur: 0, color: nil)

// Play triangle
ctx.setFillColor(CGColor(red: 0.08, green: 0.07, blue: 0.12, alpha: 1))
ctx.move(to: CGPoint(x: 465, y: 320))
ctx.addLine(to: CGPoint(x: 465, y: 560))
ctx.addLine(to: CGPoint(x: 630, y: 440))
ctx.closePath()
ctx.fillPath()

// Text "MOVE MK"
let text = "MOVE MK" as NSString
let font = NSFont(name: "HelveticaNeue-Bold", size: 80) ?? NSFont.boldSystemFont(ofSize: 80)
let shadow = NSShadow()
shadow.shadowColor = NSColor.black.withAlphaComponent(0.5)
shadow.shadowBlurRadius = 8
shadow.shadowOffset = NSSize(width: 0, height: 3)
let attrs: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor.white,
    .shadow: shadow
]
let tSize = text.size(withAttributes: attrs)
text.draw(in: NSRect(x: (s.width - tSize.width) / 2, y: 80, width: tSize.width, height: tSize.height), withAttributes: attrs)

// Bottom accent line
ctx.setFillColor(CGColor(red: 0.95, green: 0.78, blue: 0.22, alpha: 0.6))
ctx.fill(CGRect(x: (s.width - 120) / 2, y: 60, width: 120, height: 3))

img.unlockFocus()

guard let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else { fatalError() }
let bmp = NSBitmapImageRep(cgImage: cg)
let sz = min(bmp.representations.first?.pixelsWide ?? 1024, 1024)

// Generate all required sizes
let fm = FileManager.default
let dir = (out as NSString).deletingLastPathComponent
let sizes = [(1024, "icon.png")]

for (sz, name) in sizes {
    let o = "\(dir)/\(name)"
    guard let d = bmp.representation(using: .png, properties: [:]) else { continue }
    try? d.write(to: URL(fileURLWithPath: o))
    print("Generated: \(o)")
}
