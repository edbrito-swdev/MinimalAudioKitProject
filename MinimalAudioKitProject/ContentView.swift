//
//  ContentView.swift
//  MinimalAudioKitProject
//
//  Created by Eduardo Brito on 31/08/2023.
//

import SwiftUI
import AudioKit
import SoundpipeAudioKit

class ThreadedPlayer: Thread {
    
    var osc: MorphingOscillator;
    
    init(mainOsc: MorphingOscillator) {
        osc = mainOsc
    }
    
    override func main() {
        osc.play()
        while true {
            osc.frequency = Float.random(in: 200 ... 800)
            osc.amplitude = Float.random(in: 0.0 ... 0.3)
            usleep(100_000)
        }
    }
}

class ToneGenerator: ObservableObject {
    var osc = MorphingOscillator(index:2.75)
    let engine = AudioEngine()
    var player: ThreadedPlayer;
    
    @Published var playing: Bool = false {
        didSet {
            if playing {
                player = ThreadedPlayer(mainOsc: osc)
                player.start()
            } else {
                osc.stop()
                player.cancel()
            }
        }
    }
    
    init() {
        engine.output = osc
        try! engine.start()
        player = ThreadedPlayer(mainOsc: osc)
    }
    
    func toggle() {
        playing = !playing
    }
}

struct ContentView: View {
    let generator = ToneGenerator()
    
    var body: some View {
        Button("Simple Oscilator") {
            generator.toggle()
        }
    }
}


