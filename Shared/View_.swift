import SwiftUI

protocol View_ {
  associatedtype Body: View_
  var body: Body { get }
  associatedtype SwiftUIView: SwiftUI.View
  var swiftUI: SwiftUIView { get }
}

extension View_ {
  func _render(context: RenderingContext, size: CGSize) {
    if let builtin = self as? BuiltinView {
      builtin.render(context: context, size: size)
    } else {
      body._render(context: context, size: size)
    }
  }

  func _size(proposed: ProposedSize) -> CGSize {
    if let builtin = self as? BuiltinView {
      return builtin.size(proposed: proposed)
    } else {
      return body._size(proposed: proposed)
    }
  }
}
