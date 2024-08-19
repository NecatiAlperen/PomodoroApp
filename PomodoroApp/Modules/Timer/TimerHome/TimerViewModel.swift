//
//  TimerViewModel.swift
//  PomodoroApp
//
//  Created by Necati Alperen IŞIK on 12.08.2024.
//

import Foundation

protocol TimerViewModelDelegate: AnyObject {
    func timerDidUpdate()
}

protocol TimerViewModelProtocol: AnyObject {
    var delegate: TimerViewModelDelegate? { get set }
    var timeRemaining: String { get }
    var progress: Double { get }
    var isTimerRunning: Bool { get }
    func toggleTimer()
    func addNewTimer()
    func updateTaskName(_ name: String)
    func killTimer()
}

final class TimerViewModel: TimerViewModelProtocol {
    weak var delegate: TimerViewModelDelegate?
    
    private var timer: Timer?
    private var totalTime: Int = 36
    private var currentTime: Int = 36
    private(set) var isTimerRunning = false
    
    var timeRemaining: String {
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double {
        return Double(totalTime - currentTime) / Double(totalTime)
    }
    
    func toggleTimer() {
        if isTimerRunning {
            timer?.invalidate()
        } else {
            startTimer()
        }
        isTimerRunning.toggle()
    }
    
    func killTimer() {
        timer?.invalidate()
        // TODO : CORE DATA TASK NAME'İ VE SÜRE BİLGİLERİNİ AL YAZDIR
    }
    func addNewTimer() {
        
        print("New timer added")
    }
    
    func updateTaskName(_ name: String) {
        
        print("Task name updated to: \(name)")
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime -= 1
            if self.currentTime <= 0 {
                self.timer?.invalidate()
                self.isTimerRunning = false
            }
            self.delegate?.timerDidUpdate()
        }
    }
}


