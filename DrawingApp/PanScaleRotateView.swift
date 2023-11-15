//
//  PanScaleRotateView.swift
//  DrawingApp
//
//  Created by Francois Faure on 14/11/2023.
//

import SwiftUI

struct PanScaleRotateView<Content: View>: UIViewRepresentable {
    typealias UIViewType = UIView

    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let roatedView = UIView()

        let rotate = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.rotationGesture(_:)))
        roatedView.addGestureRecognizer(rotate)

        let pinch = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.pinchGesture(_:)))
        pinch.delegate = context.coordinator
        roatedView.addGestureRecognizer(pinch)

        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.panGesture(_:)))
        pan.delegate = context.coordinator
        pan.minimumNumberOfTouches = 2
        pan.maximumNumberOfTouches = 2
        roatedView.addGestureRecognizer(pan)

        roatedView.backgroundColor = UIColor.red

        roatedView.addSwiftUISubview(content())

        view.addSubview(roatedView)

        // Fix swiftUI weird issue when rotating direclty the parent view
        // and if view that handle gesture is not a child view.
        // I guess this is somewhere between UIKit autolayout and swiftUI a conflicting issue
        roatedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: roatedView.topAnchor),
            view.bottomAnchor.constraint(equalTo: roatedView.bottomAnchor),
            view.leftAnchor.constraint(equalTo: roatedView.leftAnchor),
            view.rightAnchor.constraint(equalTo: roatedView.rightAnchor),
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        override init() {
            super.init()
        }

        @objc func pinchGesture(_ gesture: UIPinchGestureRecognizer) {
            guard let view = gesture.view else { return }

            if gesture.state == UIGestureRecognizer.State.changed {
                let pinchCenter = CGPoint(x: gesture.location(in: view).x - view.bounds.midX,
                                          y: gesture.location(in: view).y - view.bounds.midY)
                let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                    .scaledBy(x: gesture.scale, y: gesture.scale)
                    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)

                view.transform = transform
                gesture.scale = 1
            }
        }

        @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
            guard let view = gesture.view else { return }

            let transform = view.transform
            view.transform = CGAffineTransform.identity

            let point: CGPoint = gesture.translation(in: view)
            let movedPoint = CGPoint(
                x: view.center.x + point.x,
                y: view.center.y + point.y
            )

            view.center = movedPoint
            view.transform = transform

            gesture.setTranslation(CGPoint.zero, in: view)
        }

        @objc func rotationGesture(_ gesture: UIRotationGestureRecognizer) {
            guard let view = gesture.view else { return }

            switch gesture.state {
            case .changed:
                view.transform = view.transform.rotated(by: gesture.rotation)
                gesture.rotation = 0

            default: break
            }
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
}

struct PanScaleRotateViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        PanScaleRotateView {
            content
        }
    }
}

extension View {
    func panScaleRotate() -> some View {
        modifier(PanScaleRotateViewModifier())
    }
}

extension UIView {
    func addSwiftUISubview<Content: View>(_ swiftUIView: Content) {
        let hostingController = UIHostingController(rootView: swiftUIView)

        addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostingController.view.leftAnchor.constraint(equalTo: leftAnchor),
            hostingController.view.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}
