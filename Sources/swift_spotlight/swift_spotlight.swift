// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftUI

extension View {
    func spotlight(enabled: Bool, title: String = "", description: String = "", onTap: @escaping () -> Void = {}) -> some View {
        return self
            .overlay(
                GeometryReader(content: { proxy in
                    let rect = proxy.frame(in: .global)
                    if enabled {
                        SpotlightView(rect: rect, title: title, description: description, onTap: onTap) {
                            self
                        }
                    }
                })
            )
    }
    
    // MARK: Screen Bounds
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    // MARK: Root Controller
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

struct SpotlightView<Content: View>: View {
    var content: Content
    var rect: CGRect
    var title: String
    var description: String
    var onTap: () -> Void
    
    init(rect: CGRect, title: String, description: String, onTap: @escaping () -> Void = {}, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
        self.rect = rect
        self.description = description
        self.onTap = onTap
    }
    
    @State var tag: Int = 1009
    
    var body: some View {
        Rectangle()
            .fill(.clear)
            .onAppear {
                addOverlayView()
            }
            .onDisappear {
                removeOverlay()
            }
    }
    
    // MARK: Removing overlay when the view disappeared
    func removeOverlay() {
        rootController().view.subviews.forEach { view in
            if view.tag == self.tag {
                view.removeFromSuperview()
            }
        }
    }
    
    func addOverlayView() {
        let hostingView = UIHostingController(rootView: overlaySwiftUIView())
        hostingView.view.frame = screenBounds()
        hostingView.view.backgroundColor = .clear
        // Adding to the current view
        
        // to identify which view added, adding a tag to the view
        if self.tag == 1009 {
            self.tag = generateRandom()
        }
        hostingView.view.tag = self.tag
        
        rootController().view.subviews.forEach { view in
            if view.tag == self.tag { return }
        }
        
        rootController().view.addSubview(hostingView.view)
    }
    
    @ViewBuilder
    func overlaySwiftUIView() -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.black.opacity(0.8))
                .mask(
                    Rectangle()
                        .overlay(
                            self.content
                                .frame(width: rect.width, height: rect.height)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(6)
                                .position()
                                .offset(x: rect.midX, y: rect.midY)
                                .blendMode(.destinationOut)
                        )
                )
            VStack {
                if title != "" {
                    HStack {
                        Text(title)
                            .font(.title)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .frame(alignment: .leading)
                        Spacer()
                    }
                    
                }
                if description != "" {
                    HStack {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(4)
                            .frame(alignment: .leading)
                        Spacer()
                    }
                }
            }
            .position()
            .offset(x: screenBounds().midX, y: rect.maxY > (screenBounds().height - 300) ? (rect.minY - 300) : (rect.maxY + 300))
            .padding()
            
        }
        .frame(width: screenBounds().width, height: screenBounds().height)
        .ignoresSafeArea()
        .onTapGesture {
            onTap()
        }
    }
    
    // MARK: random number for tag
    func generateRandom() -> Int {
        let random = Int(UUID().uuid.0)
        // checking if there is a view already having this tag
        let subView = rootController().view.subviews
        
        for index in subView.indices {
            if subView[index].tag == random {
                return generateRandom()
            }
        }
        
        return random
    }
}



