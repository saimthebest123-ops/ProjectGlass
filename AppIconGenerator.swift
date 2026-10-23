import AppKit
import CoreGraphics

let size = 1024
let image = NSImage(size: NSSize(width: size, height: size))
image.lockFocus()
NSColor.black.setFill()
NSBezierPath(rect: NSRect(x: 0, y: 0, width: size, height: size)).fill()
NSColor.white.setFill()

func polygon(_ points: [(CGFloat, CGFloat)]) {
    let path = NSBezierPath()
    guard let first = points.first else { return }
    path.move(to: NSPoint(x: first.0, y: first.1))
    for point in points.dropFirst() { path.line(to: NSPoint(x: point.0, y: point.1)) }
    path.close()
    path.fill()
}
// Three clean white faces of the geometric ProjectGlass mark.
polygon([(512, 800), (735, 671), (512, 542), (289, 671)])
polygon([(270, 639), (487, 513), (487, 234), (270, 359)])
polygon([(537, 513), (754, 639), (754, 359), (537, 234)])
// Two black cutouts form the distinctive double-line detail.
polygon([(590, 472), (706, 539), (706, 492), (590, 425)])
polygon([(590, 402), (706, 469), (706, 422), (590, 355)])
image.unlockFocus()
let rect = NSRect(x: 0, y: 0, width: size, height: size)
guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil),
      let data = NSBitmapImageRep(cgImage: cgImage).representation(using: .png, properties: [:]) else {
    fatalError("Could not render ProjectGlass app icon")
}
try data.write(to: URL(fileURLWithPath: "Assets.xcassets/AppIcon.appiconset/AppIcon.png"))
