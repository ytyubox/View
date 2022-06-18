//
/*
 *		Created by 游宗諭 in 2022/6/18
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 12.4
 */

import SwiftUI
protocol View_ {
  associatedtype Body: View_
  var body: Body { get }
}

struct ContentView: View {
  var body: some View {
    Text("Hello, world!")
      .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
