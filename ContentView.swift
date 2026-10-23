import SwiftUI
import PhotosUI
import AVKit

struct ContentView: View {
    @State private var selection = 0

    private let tabs: [(String, String)] = [
        ("Home", "square.grid.2x2.fill"),
        ("Wallpapers", "photo.fill"),
        ("AOD", "clock.fill"),
        ("Glass", "slider.horizontal.3"),
        ("Tweaks", "switch.2"),
        ("Store", "square.stack.3d.up.fill")
    ]

    var body: some View {
        TabView(selection: $selection) {
            HomeView().tag(0)
            WallpapersView().tag(1)
            AODView().tag(2)
            GlassView().tag(3)
            TweaksView().tag(4)
            StoreView().tag(5)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            HStack(spacing: 4) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    Button {
                        withAnimation(.spring(response: 0.36, dampingFraction: 0.78)) {
                            selection = index
                        }
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: tab.1)
                                .font(.system(size: 18, weight: selection == index ? .semibold : .regular))
                                .symbolEffect(.bounce, value: selection == index)
                            Text(tab.0)
                                .font(.system(size: 9, weight: selection == index ? .semibold : .medium))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .foregroundStyle(selection == index ? Color.white : Color.white.opacity(0.62))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background {
                            if selection == index {
                                Capsule()
                                    .fill(.white.opacity(0.14))
                                    .overlay(Capsule().stroke(.white.opacity(0.22), lineWidth: 0.8))
                                    .modifier(AvailableGlassEffect())
                            }
                        }
                        .contentShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(tab.0)
                    .accessibilityAddTraits(selection == index ? .isSelected : [])
                }
            }
            .padding(7)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.18), lineWidth: 1))
            .shadow(color: .black.opacity(0.28), radius: 18, y: 8)
            .padding(.horizontal, 12)
            .padding(.top, 7)
            .padding(.bottom, 4)
            .background(.clear)
        }
        .tint(Color(red: 0.78, green: 0.72, blue: 1.0))
        .preferredColorScheme(.dark)
    }
}

struct AvailableGlassEffect: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(.regular, in: Capsule())
        } else {
            content
        }
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
    @State private var dimLevel = 0.24
    @State private var showModels = false
    @State private var showColors = false
    @State private var selectedModel = ""
    @State private var selectedColor = "Black"
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var selectedVideo: PhotosPickerItem?
    @State private var liveWallpaperPlayer: AVPlayer?
    @State private var breathingGlow = true
    @State private var floatingParticles = true
    @State private var clockBloom = true
    @State private var pulse = false

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
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: isAODEnabled
                                            ? [.black, .black, Color(red: 0.015, green: 0.02, blue: 0.06)]
                                            : (selectedModel == "iPhone 16" ? [chosenColor.opacity(0.95), chosenColor, .black] : [Color(red: 0.12, green: 0.10, blue: 0.25), .black, Color(red: 0.04, green: 0.13, blue: 0.20)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Circle()
                                .fill(Color.cyan.opacity(isAODEnabled ? 0.025 : 0.20))
                                .frame(width: 170, height: 170)
                                .blur(radius: 55)
                                .offset(x: 60, y: -geometry.size.height * 0.12)
                                .allowsHitTesting(false)

                            if breathingGlow {
                                Circle()
                                    .fill(Color(red: 0.22, green: 0.48, blue: 1.0).opacity(isAODEnabled ? 0.08 : 0.24))
                                    .frame(width: pulse ? 220 : 145, height: pulse ? 220 : 145)
                                    .blur(radius: pulse ? 60 : 36)
                                    .offset(x: pulse ? 55 : 30, y: -40)
                                    .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: pulse)
                                    .allowsHitTesting(false)
                            }
                            if floatingParticles {
                                GeometryReader { geo in
                                    ForEach(0..<12, id: \.self) { index in
                                        Circle()
                                            .fill(Color.white.opacity(isAODEnabled ? 0.10 : 0.28))
                                            .frame(width: index.isMultiple(of: 3) ? 3 : 2, height: index.isMultiple(of: 3) ? 3 : 2)
                                            .position(
                                                x: geo.size.width * CGFloat((index * 37 + 13) % 100) / 100,
                                                y: geo.size.height * CGFloat((index * 61 + 19) % 100) / 100
                                            )
                                    }
                                }
                                .allowsHitTesting(false)
                            }

                            if let liveWallpaperPlayer {
                                VideoPlayer(player: liveWallpaperPlayer)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .clipped()
                                    .allowsHitTesting(false)
                            } else if let photoData, let image = UIImage(data: photoData) {
                                Image(uiImage: image).resizable().scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity).clipped()
                                    .opacity(isAODEnabled ? 0.25 : 0.9)
                            }

                            VStack(spacing: 10) {
                                Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()).uppercased())
                                    .font(.caption2).tracking(2)
                                    .foregroundStyle(.white.opacity(isAODEnabled ? 0.42 : 0.75))
                                Text(Date.now.formatted(date: .omitted, time: .shortened))
                                    .font(.system(size: tallClock ? min(geometry.size.width * 0.17, 76) : 54, weight: .ultraLight, design: .rounded))
                                    .minimumScaleFactor(0.65)
                                    .lineLimit(1)
                                    .foregroundStyle(.white.opacity(isAODEnabled ? min(dimLevel, 0.32) : 1.0))
                                    .shadow(color: .white.opacity(clockBloom && !isAODEnabled ? 0.55 : 0.0), radius: clockBloom && !isAODEnabled ? 22 : 0)
                                Text(isAODEnabled ? "ALWAYS-ON CONCEPT" : "AOD CONCEPT PREVIEW")
                                    .font(.caption2).tracking(2)
                                    .foregroundStyle(.white.opacity(isAODEnabled ? 0.22 : 0.45))
                            }
                            .padding(.horizontal, 14)
                            .scaleEffect(isAODEnabled ? 0.94 : 1.0)
                            .animation(.easeInOut(duration: 0.65), value: isAODEnabled)
                        }
                        .frame(height: min(max(geometry.size.height * 0.46, 260), 390))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(.white.opacity(0.16), lineWidth: 1))
                        .shadow(color: .blue.opacity(0.12), radius: 24, y: 10)

                        Button {
                            withAnimation(.easeInOut(duration: 0.65)) { isAODEnabled.toggle() }
                        } label: {
                            Label(isAODEnabled ? "Wake Display" : "Enable AOD", systemImage: isAODEnabled ? "sun.max.fill" : "moon.zzz.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(.white.opacity(0.2), lineWidth: 1))
                        }
                        .buttonStyle(.plain)

                        HStack(spacing: 10) {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Label("Add Picture", systemImage: "photo")
                                    .frame(maxWidth: .infinity).padding(.vertical, 13)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(.white.opacity(0.14), lineWidth: 1))
                            }
                            PhotosPicker(selection: $selectedVideo, matching: .videos) {
                                Label("Add Video", systemImage: "play.rectangle")
                                    .frame(maxWidth: .infinity).padding(.vertical, 13)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(.white.opacity(0.14), lineWidth: 1))
                            }
                        }
                        .font(.subheadline.weight(.semibold))
                        .buttonStyle(.plain)
                        .onChange(of: selectedPhoto) { _, item in
                            Task { photoData = try? await item?.loadTransferable(type: Data.self) }
                        }
                        .onChange(of: selectedVideo) { _, item in
                            Task {
                                guard let data = try? await item?.loadTransferable(type: Data.self) else { return }
                                let url = FileManager.default.temporaryDirectory.appendingPathComponent("ProjectGlassLiveWallpaper.mov")
                                do {
                                    try data.write(to: url, options: .atomic)
                                    liveWallpaperPlayer = AVPlayer(url: url)
                                    liveWallpaperPlayer?.isMuted = true
                                    liveWallpaperPlayer?.play()
                                } catch {
                                    liveWallpaperPlayer = nil
                                }
                            }
                        }

                        Button("Browse Live Wallpaper Concepts  ·  \(selectedModel.isEmpty ? "Choose" : selectedModel)") { showModels = true }
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(.white.opacity(0.14), lineWidth: 1))
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

                        VStack(alignment: .leading, spacing: 14) {
                            Text("AMBIENT EFFECTS").font(.caption.bold()).tracking(1.5).foregroundStyle(.secondary)
                            Toggle("Tall clock", isOn: $tallClock)
                            Toggle("Breathing blue glow", isOn: $breathingGlow)
                            Toggle("Floating light particles", isOn: $floatingParticles)
                            Toggle("Clock bloom", isOn: $clockBloom)
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Dimmed clock brightness")
                                    Spacer()
                                    Text("\(Int(dimLevel * 100))%").foregroundStyle(.secondary)
                                }.font(.subheadline)
                                Slider(value: $dimLevel, in: 0.12...0.32)
                                    .tint(Color(red: 0.78, green: 0.72, blue: 1.0))
                                    .modifier(AvailableGlassEffect())
                            }
                        }
                        .padding(18)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(.white.opacity(0.13), lineWidth: 1))

                        Text("Preview only — this app can't replace iOS's real Lock Screen or control the Side button.")
                            .font(.footnote).foregroundStyle(.orange)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 28)
                    .frame(maxWidth: 620)
                    .frame(maxWidth: .infinity)
                }
                .background(Color(red: 0.025, green: 0.025, blue: 0.045).ignoresSafeArea())
            }
            .navigationTitle("AOD Studio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
                liveWallpaperPlayer?.seek(to: .zero)
                liveWallpaperPlayer?.play()
            }
            .task {
                while !Task.isCancelled {
                    pulse.toggle()
                    try? await Task.sleep(for: .seconds(2.4))
                }
            }
        }
        .preferredColorScheme(.dark)
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
                            .tint(Color(red: 0.78, green: 0.72, blue: 1.0))
                    }
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(.white.opacity(0.16), lineWidth: 1))
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
