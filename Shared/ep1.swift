import AppKit
typealias RenderingContext = CGContext
typealias ProposedSize = CGSize

protocol View_ {
  associatedtype Body: View_
  var body: Body { get }
}

protocol BuiltinView {
  func render(context: RenderingContext, size: ProposedSize)
  typealias Body = Never
}

extension View_ {
  func _render(context: RenderingContext, size: ProposedSize) {
    if let builtin = self as? BuiltinView {
      builtin.render(context: context, size: size)
    }
    else {
      body._render(context: context, size: size)
    }
  }
}

extension Never: View_ {
  typealias Body = Never
}

extension View_ where Body == Never {
  var body: Never { fatalError("this should never be called") }
}

protocol Shape_: View_ {
  func path(in rect: CGRect) -> CGPath
}

extension Shape_ {
  var body: some View_ {
    ShapeView(shape: self)
  }
}

extension NSColor: View_ {
  var body: some View_ {
    ShapeView(shape: Rectangle_(), color: self)
  }
}

struct ShapeView<S: Shape_>: BuiltinView, View_ {
  var shape: S
  var color: NSColor = .red

  func render(context: RenderingContext, size: ProposedSize) {
    context.saveGState()
    context.setFillColor(color.cgColor)
    context.addPath(shape.path(in: CGRect(origin: .zero, size: size)))
    context.fillPath()
    context.restoreGState()
  }
}

struct Rectangle_: Shape_ {
  func path(in rect: CGRect) -> CGPath {
    CGPath(rect: rect, transform: nil)
  }
}

struct Ellipse_: Shape_ {
  func path(in rect: CGRect) -> CGPath {
    CGPath(ellipseIn: rect, transform: nil)
  }
}


func render<V: View_>(view: V) -> Data {
  let size = CGSize(width: 600, height: 400)
  return CGContext.pdf(size: size) { context in
    view._render(context: context, size: size)
  }
}

extension CGContext {
  static func pdf(size: CGSize, render: (CGContext) -> ()) -> Data {
    let pdfData = NSMutableData()
    let consumer = CGDataConsumer(data: pdfData)!
    var mediaBox = CGRect(origin: .zero, size: size)
    let pdfContext = CGContext(consumer: consumer, mediaBox: &mediaBox, nil)!
    pdfContext.beginPage(mediaBox: &mediaBox)
    render(pdfContext)
    pdfContext.endPage()
    pdfContext.closePDF()
    return pdfData as Data
  }
}
