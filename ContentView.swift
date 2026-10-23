import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HomeView().tabItem { Label("Home", systemImage: "square.grid.2x2") }.tag(0)
            WallpapersView().tabItem { Label("Wallpapers", systemImage: "photo") }.tag(1)
            AODView().tabItem { Label("AOD", systemImage: "clock") }.tag(2)
            GlassView().tabItem { Label("Glass", systemImage: "slider.horizontal.3") }.tag(3)
            StoreView().tabItem { Label("Store", systemImage: "square.stack.3d.up") }.tag(4)
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
                Section("Reality check") {
                    Label("In-app themes and previews work inside this app.", systemImage: "checkmark.circle")
                    Label("A normal app cannot enable native Always-On Display on iPhone 16.", systemImage: "info.circle")
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
    @State private var dimLevel = 0.35

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                VStack(spacing: 10) {
                    Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()).uppercased())
                        .font(.caption2).tracking(2).foregroundStyle(.white.opacity(0.5))
                    Text(Date.now.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: tallClock ? 76 : 54, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white.opacity(dimLevel))
                    Text("AOD CONCEPT PREVIEW")
                        .font(.caption2).tracking(2).foregroundStyle(.white.opacity(0.35))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .padding(.horizontal)
                Spacer()
                Form {
                    Toggle("Tall clock", isOn: $tallClock)
                    VStack(alignment: .leading) {
                        Text("Clock brightness")
                        Slider(value: $dimLevel, in: 0.12...0.8)
                    }
                    Section {
                        Text("This is an in-app preview. It cannot stay visible on the lock screen or add native Always-On Display to the iPhone 16.")
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

    private let colors: [Color] = [.white, .purple, .cyan, .mint]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ZStack {
                    LinearGradient(colors: [.indigo.opacity(0.5), .black, .purple.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
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
                    .background(.ultraThinMaterial.opacity(intensity))
                    .overlay(RoundedRectangle(cornerRadius: 26).stroke(colors[tint].opacity(0.8), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                }
                .frame(height: 270).clipShape(RoundedRectangle(cornerRadius: 26)).padding()
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

struct StoreView: View {
    private let packs = [
        ("Glassify", "Translucent interface concept"),
        ("Nightfall", "Dark visual theme"),
        ("Ambient", "Dim lock-screen concept")
    ]
    @State private var added: Set<String> = []

    var body: some View {
        NavigationStack {
            List(packs, id: \.0) { name, description in
                VStack(alignment: .leading, spacing: 8) {
                    Label(name, systemImage: "square.stack.3d.up")
                        .font(.headline)
                    Text(description).font(.subheadline).foregroundStyle(.secondary)
                    Button(added.contains(name) ? "Added to demo ✓" : "Add to demo") {
                        if added.contains(name) { added.remove(name) } else { added.insert(name) }
                    }
                }.padding(.vertical, 5)
            }
            .navigationTitle("Glass Store")
        }
    }
}
