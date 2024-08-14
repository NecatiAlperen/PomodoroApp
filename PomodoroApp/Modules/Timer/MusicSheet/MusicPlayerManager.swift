//
//  MusicPlayerManager.swift
//  PomodoroApp
//
//  Created by Necati Alperen IŞIK on 14.08.2024.
//

import Foundation
import AVFAudio


protocol MusicPlayerManagerProtocol: AnyObject {
    func playMusic(for track: MusicTrack)
    func stopMusic()
}

final class MusicPlayerManager: MusicPlayerManagerProtocol {
    static let shared = MusicPlayerManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playMusic(for track: MusicTrack) {
        if let path = Bundle.main.path(forResource: track.filename, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing music: \(error)")
            }
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
}

