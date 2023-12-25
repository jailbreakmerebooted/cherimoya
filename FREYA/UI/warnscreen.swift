import SwiftUI
import FluidGradient

struct WarnScreen: View {
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    @Binding var paniced: Bool
    @Binding var settings: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            FluidGradient(blobs: [.orange, .yellow, .red],
                          highlights: [.red, .red],
                          speed: 0.3,
                          blur: 0.75)
            .background(.quaternary)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Spacer().frame(height: 20)
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(width: deviceWidth - 240)
                Spacer().frame(height: 40)
                List {
                    Section {
                        Text("Opps Something went wrong")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.red)
                    }
                    Section(header: Text("Info")) {
                        Text("""
Your Device seems to have paniced. Please contact SeanIsTethered on Twitter if these troubleshootings doesnt work.
""")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.orange)
                    }
                    Section(header: Text("Troubleshoot")) {
                        Text("""
Here are some Troubleshooting ways :)

1. Reboot Device manually
2. Clear Resources Cache
3. Enable Cooldown
4. Contact me -> ceo@polcom.de
""")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.yellow)
                    }
                }
                .frame(width: deviceWidth - 50, height: deviceHeight / 2)
                .cornerRadius(15)
                Spacer().frame(height: 20)
                Button(action: {
                    paniced = false
                    settings = false
                    deleteFile()
                }) {
                    ZStack {
                        Rectangle()
                            .frame(width: deviceWidth - 50, height: 50)
                            .foregroundColor(.yellow)
                            .cornerRadius(10)
                            .overlay {
                                Text("Continue")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                    }
                }
                Spacer()
            }
        }
    }
}
