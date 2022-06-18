//
/*
 *		Created by 游宗諭 in 2022/6/18
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.4
 */

import SwiftUI

let sample = ShapeView(shape: Ellipse_())

struct ContentView: View {
//  let sample = ShapeView(shape: Rectangle_())
  let sample = NSColor.blue

  var body: some View {
    Image(nsImage: NSImage(data: render(view: sample))!)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
