import AppKit
protocol BuiltinView {
  func render(context: RenderingContext, size: CGSize)
  func size(proposed: ProposedSize) -> CGSize
  typealias Body = Never
}
