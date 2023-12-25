import SwiftUI

struct Changelog: View {
    var body: some View {
        List {
            Section(header: Text("v0.2.4")) {
                Text("""
- added FluidGradient
- added mostlikely the exploit fix
- removed cooldown, because i found a better technique
- added auto download procursus strap
  - made cache not deletable when user has no internet
  - made documents container visible from download try
""")
            }
        }
    }
}
