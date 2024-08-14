//
//  MusicSheetViewModel.swift
//  PomodoroApp
//
//  Created by Necati Alperen IŞIK on 14.08.2024.
//

import Foundation
import AVFAudio

protocol MusicSheetViewModelProtocol: AnyObject {
    var sounds: [MusicTrack] { get }
    func playMusic(for track: MusicTrack)
    func stopMusic()
}

final class MusicSheetViewModel: MusicSheetViewModelProtocol {
    private let musicPlayerManager: MusicPlayerManagerProtocol
    
    init(musicPlayerManager: MusicPlayerManagerProtocol = MusicPlayerManager.shared) {
        self.musicPlayerManager = musicPlayerManager
    }
    
    let sounds: [MusicTrack] = [
        MusicTrack(title: "Forest", filename: "forest", iconColor: .systemGreen, iconName: "tree.circle"),
        MusicTrack(title: "Cafe", filename: "cafe", iconColor: .systemBrown, iconName: "cup.and.saucer.fill"),
        MusicTrack(title: "Fireplace", filename: "fireplace", iconColor: .systemOrange, iconName: "flame.fill"),
        MusicTrack(title: "Ocean", filename: "ocean", iconColor: .systemBlue, iconName: "water.waves"),
        MusicTrack(title: "Plane", filename: "plane", iconColor: .systemGray, iconName: "airplane"),
        MusicTrack(title: "Piano", filename: "piano", iconColor: .white, iconName: "pianokeys.inverse")
    ]
    
    func playMusic(for track: MusicTrack) {
        musicPlayerManager.playMusic(for: track)
    }
    
    func stopMusic() {
        musicPlayerManager.stopMusic()
    }
}

