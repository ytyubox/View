// import AppKit
import SwiftUI

typealias RenderingContext = CGContext
typealias ProposedSize = CGSize

extension Never: View_ {
  typealias Body = Never
  var swiftUI: Never { fatalError("should never be called") }
}

extension View_ where Body == Never {
  var body: Never { fatalError("this should never be called") }
}


extension NSColor: View_ {
  var body: some View_ {
    ShapeView(shape: Rectangle_(), color: self)
  }

  var swiftUI: some View {
    Color(self)
  }
}

