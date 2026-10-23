import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HomeView().tabItem { Label("Home", systemImage: "square.grid.2x2") }.tag(0)
            WallpapersView().tabItem { Label("Wallpapers", systemImage: "photo") }.tag(1)
            AODView().tabItem { Label("AOD", systemImage: "clock") }.tag(2)
            GlassView().tabItem { Label("Glass", systemImage: "slider.horizontal.3") }.tag(3)
            TweaksView().tabItem { Label("Tweaks", systemImage: "wrench.and.screwdriver") }.tag(4)
            StoreView().tabItem { Label("Store", systemImage: "square.stack.3d.up") }.tag(5)
        }
        .tint(Color(red: 0.76, green: 0.68, blue: 1.0))
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label("Project Glass", systemImage: "layers.3")
                        .font(.largeTitle.bold())
                    Text("A dark customisation studio for iPhone.")
                        .foregroundStyle(.secondary)
                }

                Section("Your studio") {
                    Label("Wallpaper concepts", systemImage: "photo")
                    Label("Always-On Display clock preview", systemImage: "clock")
                    Label("Liquid Glass style controls", systemImage: "slider.horizontal.3")
                }

                Section("Coming soon") {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "lock.screen")
                            .font(.title2)
                            .foregroundStyle(Color(red: 0.76, green: 0.68, blue: 1.0))
                            .frame(width: 34)
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Lock Screen AOD")
                                    .font(.headline)
                                Spacer()
                                Text("ROADMAP")
                                    .font(.caption2.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.purple.opacity(0.2), in: Capsule())
                            }
                            Text("A more realistic lock-screen concept preview, with a dim clock and wallpaper states.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Preview only — ordinary apps cannot replace iOS's native lock screen or enable system AOD on iPhone 16.")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Reality check") {
                    Label("Themes and previews apply inside Project Glass.", systemImage: "checkmark.circle")
                    Label("Native system AOD and system-wide Liquid Glass changes aren't available to an ordinary app.", systemImage: "info.circle")
                        .foregroundStyle(.orange)
                }
            }
            .navigationTitle("Project Glass")
        }
    }
}

struct WallpapersView: View {
    private let choices = [
        ("Obsidian", Color.black),
        ("Cosmic", Color(red: 0.10, green: 0.08, blue: 0.22)),
        ("Aurora", Color(red: 0.04, green: 0.19, blue: 0.18)),
        ("Midnight Blue", Color(red: 0.04, green: 0.09, blue: 0.22))
    ]
    @State private var selected = "Obsidian"

    var body: some View {
        NavigationStack {
            List(choices, id: \.0) { name, color in
                Button {
                    selected = name
                } label: {
                    HStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 12).fill(color)
                            .frame(width: 62, height: 72)
                            .overlay(Image(systemName: "moon.stars").foregroundStyle(.white.opacity(0.7)))
                        VStack(alignment: .leading) {
                            Text(name).font(.headline)
                            Text(name == selected ? "Selected for preview" : "Tap to preview")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if name == selected { Image(systemName: "checkmark.circle.fill") }
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Wallpapers")
        }
    }
}

struct AODView: View {
    @State private var tallClock = true
    @State private var isAODEnabled = false
    @State private var dimLevel = 0.35
    @State private var showModels = false
    @State private var showColors = false
    @State private var selectedModel = ""
    @State private var selectedColor = "Black"
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?

    private var chosenColor: Color {
        switch selectedColor {
        case "White": return .white
        case "Pink": return .pink
        case "Teal": return .teal
        case "Ultramarine": return Color(red: 0.16, green: 0.12, blue: 0.85)
        default: return .black
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: isAODEnabled
                                    ? [.black, .black, Color(red: 0.015, green: 0.02, blue: 0.06)]
                                    : (selectedModel == "iPhone 16" ? [chosenColor.opacity(0.95), chosenColor, .black] : [Color(red: 0.12, green: 0.10, blue: 0.25), .black, Color(red: 0.04, green: 0.13, blue: 0.20)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(alignment: .topTrailing) {
                            Circle()
                                .fill(Color.cyan.opacity(isAODEnabled ? 0.025 : 0.22))
                                .frame(width: 180, height: 180)
                                .blur(radius: 55)
                                .offset(x: 35, y: -20)
                        }

                    VStack(spacing: 10) {
                        Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()).uppercased())
                            .font(.caption2).tracking(2)
                            .foregroundStyle(.white.opacity(isAODEnabled ? 0.42 : 0.75))
                        Text(Date.now.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: tallClock ? 76 : 54, weight: .ultraLight, design: .rounded))
                            .foregroundStyle(.white.opacity(isAODEnabled ? min(dimLevel, 0.32) : 1.0))
                            .shadow(color: .white.opacity(isAODEnabled ? 0.0 : 0.16), radius: 14)
                        Text(isAODEnabled ? "ALWAYS-ON CONCEPT" : "AOD CONCEPT PREVIEW")
                            .font(.caption2).tracking(2)
                            .foregroundStyle(.white.opacity(isAODEnabled ? 0.22 : 0.45))
                    }
                    .scaleEffect(isAODEnabled ? 0.94 : 1.0)
                    .animation(.easeInOut(duration: 0.65), value: isAODEnabled)
                }
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .padding(.horizontal)
                .frame(maxHeight: .infinity)

                Button("Add picture or Live Wallpaper") { showModels = true }
                    .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.white).padding(.horizontal)
                    .confirmationDialog("Choose wallpaper family", isPresented: $showModels, titleVisibility: .visible) {
                        Button("iPhone 18") { selectedModel = "iPhone 18" }
                        Button("iPhone 17") { selectedModel = "iPhone 17" }
                        Button("iPhone 16") { selectedModel = "iPhone 16"; showColors = true }
                        Button("iPhone 15") { selectedModel = "iPhone 15" }
                        Button("iPhone 14") { selectedModel = "iPhone 14" }
                    }
                    .confirmationDialog("Color Chooser", isPresented: $showColors, titleVisibility: .visible) {
                        Button("Black") { selectedColor = "Black" }
                        Button("White") { selectedColor = "White" }
                        Button("Pink") { selectedColor = "Pink" }
                        Button("Teal") { selectedColor = "Teal" }
                        Button("Ultramarine") { selectedColor = "Ultramarine" }
                    }

                Button {
                    withAnimation(.easeInOut(duration: 0.65)) {
                        isAODEnabled.toggle()
                    }
                } label: {
                    Label(
                        isAODEnabled ? "Wake Display" : "Enable AOD",
                        systemImage: isAODEnabled ? "sun.max.fill" : "moon.zzz.fill"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(isAODEnabled ? Color.white.opacity(0.13) : Color(red: 0.55, green: 0.44, blue: 0.95), in: RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)

                Form {
                    Toggle("Tall clock", isOn: $tallClock)
                    VStack(alignment: .leading) {
                        Text("Dimmed clock brightness")
                        Slider(value: $dimLevel, in: 0.12...0.32)
                    }
                    Section {
                        Text("AOD is a simulated preview inside Project Glass. It cannot control the real lock screen or power button.")
                            .font(.footnote).foregroundStyle(.orange)
                    }
                }
                .frame(height: 190)
            }
            .background(Color.black)
            .navigationTitle("AOD Studio")
        }
    }
}

struct GlassView: View {
    @State private var intensity = 0.65
    @State private var tint = 0
    @State private var isBlack = false

    private let colors: [Color] = [.white, .purple, .cyan, .mint]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ZStack {
                    if isBlack { Color.black } else { LinearGradient(colors: [.indigo.opacity(0.5), .black, .purple.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing) }
                    VStack(spacing: 16) {
                        Image(systemName: "waveform").font(.largeTitle)
                        Text("Liquid Glass").font(.title.bold())
                        HStack {
                            Image(systemName: "wifi")
                            Image(systemName: "moon")
                            Image(systemName: "airplayvideo")
                        }.font(.title2)
                    }
                    .padding(32)
                    .background(isBlack ? Color.black : Color.white.opacity(intensity * 0.12))
                    .overlay(RoundedRectangle(cornerRadius: 26).stroke(isBlack ? Color.black : colors[tint].opacity(0.8), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                }
                .frame(height: 270).clipShape(RoundedRectangle(cornerRadius: 26)).padding()
                Button(isBlack ? "Enable?" : "Disable?") { withAnimation { isBlack.toggle() } }
                    .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Color.black, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.25)))
                    .foregroundStyle(.white).padding(.horizontal)
                Form {
                    VStack(alignment: .leading) {
                        Text("Glass intensity \(Int(intensity * 100))%")
                        Slider(value: $intensity, in: 0...1)
                    }
                    Picker("Tint", selection: $tint) {
                        Text("Silver").tag(0)
                        Text("Violet").tag(1)
                        Text("Ice Blue").tag(2)
                        Text("Emerald").tag(3)
                    }
                }.frame(height: 150)
                Text("Styles apply only inside this app, not across iOS.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .navigationTitle("Glass Studio")
        }
    }
}

struct TweaksView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView("To be added.", systemImage: "wrench.and.screwdriver", description: Text("Tweaks are coming in a future update."))
                .navigationTitle("Tweaks")
        }
    }
}

struct StoreView: View {
    private let packs = [
        ("Glassify", "Translucent interface concept"),
        ("Nightfall", "Dark visual theme"),
        ("Ambient", "Dim lock-screen concept"),
        ("Lock Screen AOD", "Coming soon — lock-screen concept preview")
    ]
    @State private var added: Set<String> = []

    var body: some View {
        NavigationStack {
            List(packs, id: \.0) { name, description in
                VStack(alignment: .leading, spacing: 8) {
                    Label(name, systemImage: name == "Lock Screen AOD" ? "lock.screen" : "square.stack.3d.up")
                        .font(.headline)
                    Text(description).font(.subheadline).foregroundStyle(.secondary)
                    if name == "Lock Screen AOD" {
                        Text("ROADMAP")
                            .font(.caption2.bold())
                            .foregroundStyle(.purple)
                    } else {
                        Button(added.contains(name) ? "Added to demo ✓" : "Add to demo") {
                            if added.contains(name) { added.remove(name) } else { added.insert(name) }
                        }
                    }
                }.padding(.vertical, 5)
            }
            .navigationTitle("Glass Store")
        }
    }
}
