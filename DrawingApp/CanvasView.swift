//
//  MetalView.swift
//  DrawingApp
//
//  Created by Francois Faure on 09/11/2023.
//

import SwiftUI
import MetalKit

struct CanvasView: UIViewRepresentable {
    typealias UIViewType = MTKView

    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true

        if let device = MTLCreateSystemDefaultDevice() {
            mtkView.device = device
        }

        mtkView.clearColor = MTLClearColor()
        mtkView.drawableSize = mtkView.frame.size

        return mtkView
    }

    func updateUIView(_ uiView: MTKView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MTKViewDelegate {
        var metalView: CanvasView
        var device: MTLDevice?
        var commandQueue: MTLCommandQueue?

        init(_ parent: CanvasView) {
            metalView = parent

            super.init()

            guard let device = MTLCreateSystemDefaultDevice() else {
                print("[ERROR] Cannot create a Metal Device")
                return
            }

            guard let commandQueue = device.makeCommandQueue() else {
                print("[ERROR] Cannot create Metal command queue")
                return
            }

            self.device = device
            self.commandQueue = commandQueue
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

        }

        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable else {
                return
            }

            let commandBuffer = commandQueue?.makeCommandBuffer()

            let renderPassDescriptor = view.currentRenderPassDescriptor
            renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0)
            renderPassDescriptor?.colorAttachments[0].loadAction = .clear
            renderPassDescriptor?.colorAttachments[0].storeAction = .store

            let commandBufferEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
            commandBufferEncoder?.endEncoding()

            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
