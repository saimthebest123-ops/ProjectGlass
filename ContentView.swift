import SwiftUI
import PhotosUI
import AVKit

struct ContentView: View {
    @State private var selection = 0
    @AppStorage("pgDarkAppearance") private var darkAppearance = true

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
                        VStack(spacing: 4) {
                            Image(systemName: tab.1)
                                .font(.system(size: 17, weight: selection == index ? .semibold : .regular))
                                .symbolEffect(.bounce, value: selection == index)
                            if selection == index {
                                Text(tab.0)
                                    .font(.system(size: 8, weight: .semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.6)
                            }
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
            .simultaneousGesture(DragGesture(minimumDistance: 10)
                .onChanged { value in
                    let width = UIScreen.main.bounds.width - 24
                    let itemWidth = width / CGFloat(tabs.count)
                    let next = min(max(Int(value.location.x / itemWidth), 0), tabs.count - 1)
                    if next != selection { selection = next }
                })
        }
        .tint(Color(red: 0.78, green: 0.72, blue: 1.0))
        .preferredColorScheme(darkAppearance ? .dark : .light)
    }
}

struct AvailableGlassEffect: ViewModifier {
    func body(content: Content) -> some View {
        // Xcode 16's SDK does not expose the iOS 26 glassEffect API.
        // Use SwiftUI material and highlight layers so this still builds on the current runner.
        content
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.18), lineWidth: 0.8))
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
    @AppStorage("pgTallClock") private var tallClock = true
    @AppStorage("pgAODPreviewDimmed") private var isAODEnabled = false
    @AppStorage("pgAODDimLevel") private var dimLevel = 0.24
    @State private var showModels = false
    @State private var showColors = false
    @AppStorage("pgAODModel") private var selectedModel = ""
    @AppStorage("pgAODColor") private var selectedColor = "Black"
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var selectedVideo: PhotosPickerItem?
    @State private var liveWallpaperPlayer: AVPlayer?
    @AppStorage("pgBreathingGlow") private var breathingGlow = true
    @AppStorage("pgFloatingParticles") private var floatingParticles = true
    @AppStorage("pgClockBloom") private var clockBloom = true
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
    @AppStorage("pgGlassIntensity") private var intensity = 0.65
    @AppStorage("pgGlassTint") private var tint = 0
    @AppStorage("pgGlassBlackPreview") private var isBlack = false
    private let colors: [Color] = [.white, .purple, .cyan, .mint]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24).fill(isBlack ? Color.black : Color.indigo.opacity(0.45))
                        VStack(spacing: 12) {
                            Image(systemName: "waveform").font(.system(size: 30, weight: .light))
                            Text("Liquid Glass").font(.title2.bold())
                            HStack(spacing: 18) {
                                Image(systemName: "wifi")
                                Image(systemName: "moon")
                                Image(systemName: "airplayvideo")
                            }.font(.title3)
                        }
                        .padding(20)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
                        .overlay(RoundedRectangle(cornerRadius: 22).stroke(colors[tint].opacity(0.8), lineWidth: 1))
                        .padding(12)
                    }
                    .frame(height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Glass intensity", systemImage: "slider.horizontal.3").font(.headline)
                            Spacer()
                            Text("\(Int(intensity * 100))%").foregroundStyle(.secondary).monospacedDigit()
                        }
                        Slider(value: $intensity, in: 0...1).tint(colors[tint]).controlSize(.large)
                        HStack {
                            Text("Subtle")
                            Spacer()
                            Text("Strong")
                        }.font(.caption2).foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.2), lineWidth: 1))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("GLASS TINT").font(.caption.bold()).tracking(1.4).foregroundStyle(.secondary)
                        HStack {
                            ForEach(colors.indices, id: \.self) { index in
                                Button { tint = index } label: {
                                    Circle().fill(colors[index]).frame(width: 30, height: 30)
                                        .overlay(Circle().stroke(.white.opacity(tint == index ? 1 : 0.25), lineWidth: tint == index ? 3 : 1))
                                        .frame(maxWidth: .infinity)
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))

                    Button {
                        withAnimation { isBlack.toggle() }
                    } label: {
                        Label(isBlack ? "Restore Preview" : "Black Preview", systemImage: "circle.lefthalf.filled")
                            .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }.buttonStyle(.plain)

                    Text("Preview controls apply inside Project Glass only.")
                        .font(.footnote).foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 18)
                .frame(maxWidth: 560).frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.025, green: 0.025, blue: 0.045).ignoresSafeArea())
            .navigationTitle("Glass Studio")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}

struct TweaksView: View {
    @AppStorage("pgGlassIntensity") private var glassIntensity = 0.65
    @AppStorage("pgGlassTint") private var glassTint = 0
    @AppStorage("pgGlassBlackPreview") private var blackGlassPreview = false
    @AppStorage("pgDarkAppearance") private var darkAppearance = true
    @AppStorage("pgTallClock") private var tallClock = true
    @AppStorage("pgAODPreviewDimmed") private var aodDimmed = false
    @AppStorage("pgAODDimLevel") private var dimLevel = 0.24
    @AppStorage("pgBreathingGlow") private var breathingGlow = true
    @AppStorage("pgFloatingParticles") private var floatingParticles = true
    @AppStorage("pgClockBloom") private var clockBloom = true
    @AppStorage("pgAnimationSpeed") private var animationSpeed = 0.65
    @AppStorage("pgReduceMotion") private var reduceMotion = false
    @State private var showSystemLimit = false

    private let tintNames = ["Pearl", "Violet", "Cyan", "Mint"]
    private let tintColors: [Color] = [.white, .purple, .cyan, .mint]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    headerCard

                    sectionCard("LIQUID GLASS", icon: "slider.horizontal.3") {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Glass intensity")
                                Spacer()
                                Text("\\(Int(glassIntensity * 100))%")
                                    .foregroundStyle(.secondary).monospacedDigit()
                            }
                            Slider(value: $glassIntensity, in: 0...1)
                                .tint(tintColors[min(max(glassTint, 0), tintColors.count - 1)])
                            HStack {
                                Text("Subtle")
                                Spacer()
                                Text("Strong")
                            }.font(.caption2).foregroundStyle(.secondary)

                            Text("Tint")
                                .font(.subheadline.weight(.semibold))
                            HStack(spacing: 12) {
                                ForEach(tintColors.indices, id: \\.self) { index in
                                    Button {
                                        glassTint = index
                                    } label: {
                                        VStack(spacing: 5) {
                                            Circle().fill(tintColors[index])
                                                .frame(width: 30, height: 30)
                                                .overlay(Circle().stroke(.white.opacity(glassTint == index ? 1 : 0.28), lineWidth: glassTint == index ? 3 : 1))
                                            Text(tintNames[index]).font(.caption2)
                                        }.frame(maxWidth: .infinity)
                                    }.buttonStyle(.plain)
                                }
                            }
                            Toggle("Black glass preview", isOn: $blackGlassPreview)
                            Text("These saved controls also update Glass Studio. They change ProjectGlass previews, not the iOS interface.")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }

                    sectionCard("SYSTEM-STYLE CUSTOMIZATION", icon: "circle.lefthalf.filled") {
                        Toggle("Dark appearance", isOn: $darkAppearance)
                        Text("Changes ProjectGlass's appearance only. iOS Settings and other apps are unaffected.")
                            .font(.caption).foregroundStyle(.secondary)
                        HStack(spacing: 10) {
                            styleSwatch("Dark", color: Color(red: 0.035, green: 0.035, blue: 0.06), selected: darkAppearance)
                            styleSwatch("Light", color: Color(red: 0.86, green: 0.87, blue: 0.92), selected: !darkAppearance)
                        }
                    }

                    sectionCard("LOCK SCREEN / AOD", icon: "lock.screen") {
                        Toggle("Tall clock", isOn: $tallClock)
                        Toggle("Dimmed AOD preview", isOn: $aodDimmed)
                        HStack {
                            Text("Dim clock brightness")
                            Spacer()
                            Text("\\(Int(dimLevel * 100))%").foregroundStyle(.secondary).monospacedDigit()
                        }.font(.subheadline)
                        Slider(value: $dimLevel, in: 0.12...0.32).tint(.cyan)
                        Toggle("Breathing blue glow", isOn: $breathingGlow)
                        Toggle("Floating particles", isOn: $floatingParticles)
                        Toggle("Clock bloom", isOn: $clockBloom)
                        Text("These settings are shared with AOD Studio. The clock and wallpaper remain a concept preview.")
                            .font(.caption).foregroundStyle(.secondary)
                    }

                    sectionCard("ANIMATION CONTROLS", icon: "sparkles") {
                        Toggle("Reduce motion", isOn: $reduceMotion)
                        HStack {
                            Text("Animation speed")
                            Spacer()
                            Text(reduceMotion ? "Reduced" : "\\(Int(animationSpeed * 100))%")
                                .foregroundStyle(.secondary).monospacedDigit()
                        }.font(.subheadline)
                        Slider(value: $animationSpeed, in: 0.2...1.0).disabled(reduceMotion)
                        HStack {
                            Text("Slow")
                            Spacer()
                            Text("Fast")
                        }.font(.caption2).foregroundStyle(.secondary)
                        Text("These are saved preview preferences; they do not change iOS system animations.")
                            .font(.caption).foregroundStyle(.secondary)
                    }

                    sectionCard("EXPERIMENTAL", icon: "flask") {
                        Label("Settings sync between Tweaks, Glass Studio, and AOD Studio", systemImage: "checkmark.circle.fill")
                            .font(.subheadline)
                        Label("Saved on this device inside ProjectGlass", systemImage: "internaldrive")
                            .font(.subheadline)
                        Button {
                            showSystemLimit = true
                        } label: {
                            Label("Apply settings to my iPhone", systemImage: "iphone.gen3")
                                .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 13)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.18), lineWidth: 1))
                        }.buttonStyle(.plain)
                        Text("System-wide application is not available to a normal iOS app. This button explains the limitation; it will not claim to change your phone.")
                            .font(.caption).foregroundStyle(.orange)
                    }
                }
                .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 24)
                .frame(maxWidth: 620).frame(maxWidth: .infinity)
            }
            .background(Color(red: 0.025, green: 0.025, blue: 0.045).ignoresSafeArea())
            .navigationTitle("Tweaks")
            .navigationBarTitleDisplayMode(.inline)
            .alert("iOS system access is restricted", isPresented: $showSystemLimit) {
                Button("Got it", role: .cancel) { }
            } message: {
                Text("ProjectGlass can save these settings and use them in its own Glass and AOD previews. A normal iOS app cannot apply custom AOD, replace the real Lock Screen, or change Liquid Glass across iOS and other apps. That would require system privileges iOS does not grant to ordinary apps.")
            }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "switch.2").font(.system(size: 30, weight: .light)).foregroundStyle(.purple)
            Text("Tweaks Studio").font(.title2.bold())
            Text("Fine-tune your ProjectGlass experience. Changes save automatically.")
                .font(.subheadline).foregroundStyle(.secondary)
            HStack(spacing: 6) {
                Image(systemName: "iphone")
                Text("In-app settings")
            }
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(.purple.opacity(0.16), in: Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(.white.opacity(0.16), lineWidth: 1))
    }

    private func sectionCard<Content: View>(_ title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            Label(title, systemImage: icon)
                .font(.caption.bold()).tracking(0.7)
                .foregroundStyle(.secondary)
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.12), lineWidth: 1))
    }

    private func styleSwatch(_ name: String, color: Color, selected: Bool) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            RoundedRectangle(cornerRadius: 12).fill(color).frame(height: 45)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(selected ? Color.purple : Color.white.opacity(0.16), lineWidth: selected ? 2 : 1))
            Text(name).font(.caption.weight(.medium))
        }.frame(maxWidth: .infinity)
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
