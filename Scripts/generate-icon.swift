#!/usr/bin/swift

import Cocoa

let size = CGSize(width: 1024, height: 1024)
let outputPath = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "MovieStream/Resources/Assets.xcassets/AppIcon.appiconset/icon.png"

let image = NSImage(size: size)
image.lockFocus()

guard let ctx = NSGraphicsContext.current?.cgContext else { fatalError() }

// Dark background
ctx.setFillColor(CGColor(red: 0.05, green: 0.05, blue: 0.10, alpha: 1))
ctx.fill(CGRect(origin: .zero, size: size))

// Gold circle
ctx.setFillColor(CGColor(red: 0.93, green: 0.76, blue: 0.18, alpha: 0.95))
ctx.fillEllipse(in: CGRect(x: 262, y: 260, width: 500, height: 500))

// Play triangle
ctx.setFillColor(CGColor(red: 0.05, green: 0.05, blue: 0.10, alpha: 1))
ctx.move(to: CGPoint(x: 430, y: 370))
ctx.addLine(to: CGPoint(x: 430, y: 650))
ctx.addLine(to: CGPoint(x: 660, y: 510))
ctx.closePath()
ctx.fillPath()

// Draw "MOVE MK" text
let text = "MOVE MK" as NSString
let font = NSFont(name: "Helvetica-Bold", size: 90)!
let textAttrs: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor.white
]
let textSize = text.size(withAttributes: textAttrs)
let textRect = NSRect(
    x: (size.width - textSize.width) / 2,
    y: 170 - textSize.height / 2,
    width: textSize.width,
    height: textSize.height
)
text.draw(in: textRect, withAttributes: textAttrs)

image.unlockFocus()

// Save as PNG
guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { fatalError() }
let bitmap = NSBitmapImageRep(cgImage: cgImage)
guard let pngData = bitmap.representation(using: .png, properties: [:]) else { fatalError() }
try pngData.write(to: URL(fileURLWithPath: outputPath))
print("Icon generated: \(outputPath)")
