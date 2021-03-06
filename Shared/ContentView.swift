//
/*
 *		Created by 游宗諭 in 2022/6/18
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.4
 */

import SwiftUI

func render<V: View_>(view: V, size: CGSize) -> Data {
  return CGContext.pdf(size: size) { context in
    view
      .frame(width: size.width, height: size.height)
      ._render(context: context, size: size)
  }
}

struct ContentView: View {
  let size = CGSize(width: 600, height: 400)
  @State var opacity: Double = 0.5
  var sample: some View_ {
    Ellipse_()
      .frame(width: 200, height: 100)
      .border(NSColor.blue, width: 3)
      .frame(width: 300, height: 50)
  }

  var body: some View {
    VStack {
      ZStack {
        Image(nsImage: NSImage(data: render(view: sample, size: size))!)
          .opacity(1-opacity)
        sample.swiftUI.frame(width: size.width, height: size.height)
          .opacity(opacity)
      }
      HStack {
        Text("View_")
        Slider(value: $opacity, in: 0 ... 1)
        Text("SwiftUI")
      }.padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

extension View_ {
  func border(_ color: NSColor, width: CGFloat) -> some View_ {
    Border(color: color, width: width, content: self)
  }
}

struct Border<Content: View_>: View_, BuiltinView {
  var color: NSColor
  var width: CGFloat
  var content: Content

  func size(proposed: ProposedSize) -> CGSize {
    content._size(proposed: proposed)
  }

  func render(context: RenderingContext, size: CGSize) {
    content._render(context: context, size: size)
    context.saveGState()
    context.setStrokeColor(color.cgColor)
    context.stroke(CGRect(origin: .zero, size: size).insetBy(dx: width/2, dy: width/2), width: width)
    context.restoreGState()
  }

  var swiftUI: some View {
    content.swiftUI.border(Color(color), width: width)
  }
}

struct FixedFrame<Content: View_>: View_, BuiltinView {
  var width: CGFloat?
  var height: CGFloat?
  var content: Content

  func render(context: RenderingContext, size: CGSize) {
    context.saveGState()
    let childSize = content._size(proposed: size)
    let x = (size.width-childSize.width)/2
    let y = (size.height-childSize.height)/2
    context.translateBy(x: x, y: y)
    content._render(context: context, size: childSize)
    context.restoreGState()
  }

  func size(proposed: ProposedSize) -> CGSize {
    let childSize = content._size(proposed: ProposedSize(width: width ?? proposed.width, height: height ?? proposed.height))
    return CGSize(width: width ?? childSize.width, height: height ?? childSize.height)
  }

  var swiftUI: some View {
    content.swiftUI.frame(width: width, height: height)
  }
}

extension View_ {
  func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View_ {
    FixedFrame(width: width, height: height, content: self)
  }
}
