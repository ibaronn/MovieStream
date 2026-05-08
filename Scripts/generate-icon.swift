#!/usr/bin/swift

import Cocoa

let size = CGSize(width: 1024, height: 1024)
let outputPath = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "MovieStream/Resources/Assets.xcassets/AppIcon.appiconset/icon.png"

guard let ctx = CGContext(
    data: nil, width: Int(size.width), height: Int(size.height),
    bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpace(name: CGColorSpace.sRGB)!,
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
) else { fatalError() }

// Dark background
ctx.setFillColor(CGColor(red: 0.05, green: 0.05, blue: 0.10, alpha: 1))
ctx.fill(CGRect(origin: .zero, size: size))

// Gradient overlay
let colors = [
    CGColor(red: 0.05, green: 0.05, blue: 0.10, alpha: 1),
    CGColor(red: 0.93, green: 0.76, blue: 0.18, alpha: 0.15),
]
let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])

// Gold circle
ctx.setFillColor(CGColor(red: 0.93, green: 0.76, blue: 0.18, alpha: 0.95))
ctx.fillEllipse(in: CGRect(x: 262, y: 260, width: 500, height: 500))

// Play triangle inside circle
ctx.setFillColor(CGColor(red: 0.05, green: 0.05, blue: 0.10, alpha: 1))
ctx.move(to: CGPoint(x: 430, y: 370))
ctx.addLine(to: CGPoint(x: 430, y: 650))
ctx.addLine(to: CGPoint(x: 660, y: 510))
ctx.closePath()
ctx.fillPath()

// Load font for "MOVE MK"
let font = CTFontCreateWithName("Helvetica-Bold" as CFString, 90, nil)
let text = "MOVE MK" as CFString
let attributed = CFAttributedStringCreate(nil, text, [(
    kCTFontAttributeName: font,
    kCTForegroundColorAttributeName: CGColor(red: 1, green: 1, blue: 1, alpha: 1)
) as CFDictionary] as CFDictionary)!
let line = CTLineCreateWithAttributedString(attributed)
let textWidth = CTLineGetTypographicBounds(line, nil, nil, nil)
ctx.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
ctx.textPosition = CGPoint(
    x: (size.width - CGFloat(textWidth)) / 2,
    y: 200
)
CTLineDraw(line, ctx)

// Save
guard let cgImage = ctx.makeImage() else { fatalError() }
let bitmap = NSBitmapImageRep(cgImage: cgImage)
guard let pngData = bitmap.representation(using: .png, properties: [:]) else { fatalError() }
try pngData.write(to: URL(fileURLWithPath: outputPath))
print("Icon generated: \(outputPath)")
