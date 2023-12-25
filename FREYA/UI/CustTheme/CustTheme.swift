import SwiftUI
import SwiftUIX
import FluidGradient

struct Theme: Identifiable, Codable {
    var id = UUID()
    var name: String
    var color: String
    var color2: String

    init(name: String, color: String) {
        self.name = name.isEmpty ? "Random Theme" : name
        self.color = color
        self.color2 = color
    }
}

struct Themes: View {
    @AppStorage("testc") var color1s: String = ""
    @AppStorage("testc2") var color2s: String = ""
    @State private var color1 = Color.black
    @State private var color2 = Color.black
    @State private var themes: [Theme] = []
    @State private var isAddingTheme = false
    @Binding var linkactive: Bool
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Themes")) {
                    ForEach(themes) { theme in
                        ThemeRow(theme: theme, color1s: $color1s, color2s: $color2s, linkactive: $linkactive, onDelete: {
                            deleteTheme(theme)
                        })
                    }
                    .onDelete(perform: deleteThemes)
                }
                Section {
                    Button("Add Theme") {
                        isAddingTheme = true
                    }
                    .foregroundColor(.primary)
                }
            }
            .onAppear {
                loadThemes()
            }
            .navigationTitle("Themes")
            .sheet(isPresented: $isAddingTheme) {
                ThemeCreatorView(isAddingTheme: $isAddingTheme, onSave: addNewTheme)
            }
        }
    }

    private func convcolor() {
        color1s = colorToRGBString(color1)
        color2s = colorToRGBString(color2)
        let newTheme = Theme(name: "New Theme", color: color1s)
        themes.append(newTheme)
        saveThemes()
    }

    private func convcolorback() {
        color1 = RGBStringToColor(color1s)
        color2 = RGBStringToColor(color2s)
    }

    private func saveThemes() {
        if let encoded = try? JSONEncoder().encode(themes) {
            UserDefaults.standard.set(encoded, forKey: "themes")
        }
    }

    private func loadThemes() {
        if let data = UserDefaults.standard.data(forKey: "themes"),
           let decoded = try? JSONDecoder().decode([Theme].self, from: data) {
            themes = decoded
        }
    }

    private func addNewTheme(theme: Theme) {
        themes.append(theme)
        saveThemes()
        isAddingTheme = false
    }

    private func deleteThemes(at offsets: IndexSet) {
        themes.remove(atOffsets: offsets)
        saveThemes()
    }

    private func deleteTheme(_ theme: Theme) {
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            themes.remove(at: index)
            saveThemes()
        }
    }
}

struct ThemeRow: View {
    let theme: Theme
    @Binding var color1s: String
    @Binding var color2s: String
    @Binding var linkactive: Bool
    var onDelete: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    color1s = theme.color
                    linkactive = false
                }
            }) {
                Text(theme.name)
                    .foregroundColor(.primary)
            }
        }
        .contextMenu {
            Button("Apply Theme") {
                withAnimation {
                    color1s = theme.color
                    linkactive = false
                }
            }

            Button("Remove Theme") {
                onDelete()
            }
        }
    }
}

struct ThemeCreatorView: View {
    @State private var newThemeName = ""
    @State private var newThemeColor = Color.black
    @State private var newThemeColor2 = Color.black
    @Binding var isAddingTheme: Bool
    var onSave: (Theme) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Theme Details")) {
                    TextField("Theme Name", text: $newThemeName)
                    ColorPicker("Theme Color", selection: $newThemeColor)
                }
                Section {
                    Button("Save Theme") {
                        let newTheme = Theme(name: newThemeName, color: colorToRGBString(newThemeColor), color2: colorToRGBString(newThemeColor2))
                        onSave(newTheme)
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Create Theme")
            .navigationBarItems(trailing:
                Button(action: {
                    isAddingTheme = false
                }) {
                    Image(systemName: "xmark")
                }
            )
        }
    }
}

public extension Color {
    init(hex: String) {
        self = RGBStringToColor(hex)
    }
}
