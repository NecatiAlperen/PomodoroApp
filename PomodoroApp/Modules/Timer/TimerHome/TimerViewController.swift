//
//  TimerViewController.swift
//  PomodoroApp
//
//  Created by Necati Alperen IŞIK on 12.08.2024.
//


import UIKit
import AVFAudio

final class TimerViewController: UIViewController, TimerViewModelDelegate {
    
    private var viewModel: TimerViewModelProtocol = TimerViewModel()
    private var progressLayer = CAShapeLayer()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskNameTextField, musicButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var taskNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task: Write an article"
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 20
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(taskNameChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.timeRemaining
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var circularTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.setTitle("Odaklanmaya başla", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 100/255, green: 63/255, blue: 153/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleTimer), for: .touchUpInside)
        return button
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Devam Et", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 100/255, green: 63/255, blue: 153/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Bitir", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 100/255, green: 63/255, blue: 153/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var addNewTimerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add New Timer", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 100/255, green: 63/255, blue: 153/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewTimer), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Pomodoro timer"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var musicButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "music.note")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(musicButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stepProgressView: StepProgressView = {
        let view = StepProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 28/255, green: 27/255, blue: 31/255, alpha: 1)
        setupUI()
        configureProgressLayer()
        viewModel.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circularTimeView.layer.cornerRadius = circularTimeView.frame.size.width / 2
        progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: circularTimeView.frame.size.width / 2, y: circularTimeView.frame.size.height / 2), radius: circularTimeView.frame.size.width / 2 - 10, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true).cgPath
    }
    
    private func setupUI() {
        view.addSubview(headerLabel)
        view.addSubview(stackView)
        view.addSubview(circularTimeView)
        view.addSubview(timeLabel)
        view.addSubview(startButton)
        view.addSubview(continueButton)
        view.addSubview(finishButton)
        view.addSubview(addNewTimerButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            circularTimeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularTimeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            circularTimeView.widthAnchor.constraint(equalToConstant: 300),
            circularTimeView.heightAnchor.constraint(equalToConstant: 300),
            
            timeLabel.centerXAnchor.constraint(equalTo: circularTimeView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: circularTimeView.centerYAnchor),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: circularTimeView.bottomAnchor, constant: 40),
            startButton.widthAnchor.constraint(equalToConstant: 240),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            continueButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            continueButton.topAnchor.constraint(equalTo: circularTimeView.bottomAnchor, constant: 40),
            continueButton.widthAnchor.constraint(equalToConstant: 120),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            finishButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            finishButton.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            finishButton.widthAnchor.constraint(equalToConstant: 120),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
            
            addNewTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewTimerButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 30),
            addNewTimerButton.widthAnchor.constraint(equalToConstant: 240),
            addNewTimerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureProgressLayer() {
        progressLayer.strokeColor = UIColor(red: 100/255, green: 63/255, blue: 153/255, alpha: 1).cgColor  
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 10
        progressLayer.lineCap = .round
        circularTimeView.layer.addSublayer(progressLayer)
    }
    
    @objc private func toggleTimer() {
        if viewModel.isTimerRunning {
            
            viewModel.toggleTimer()
            startButton.isHidden = true
            continueButton.isHidden = false
            finishButton.isHidden = false
        } else {
            
            viewModel.toggleTimer()
            startButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            startButton.setTitle("Odaklanmayı Durdur", for: .normal)
        }
    }
    
    @objc private func continueButtonTapped() {
        viewModel.toggleTimer()
        startButton.isHidden = false
        continueButton.isHidden = true
        finishButton.isHidden = true
    }
    
    @objc private func stopButtonTapped() {
        let alert = UIAlertController(title: "Stop Timer", message: "Are you sure you want to stop the timer?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            
            self.viewModel.killTimer()
            self.startButton.isHidden = false
            self.continueButton.isHidden = true
            self.finishButton.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func addNewTimer() {
        let addTimerSheetVC = AddTimerViewController()
        if let sheet = addTimerSheetVC.sheetPresentationController {
            sheet.detents = [.large()] // Or .large() for a larger height
            sheet.prefersGrabberVisible = true
        }
        present(addTimerSheetVC, animated: true, completion: nil)
    }
    
    @objc private func musicButtonTapped() {
        let musicSheetVC = MusicSheetViewController()
        if let sheet = musicSheetVC.sheetPresentationController {
            sheet.detents = [.medium()] // Or .large() for a larger height
            sheet.prefersGrabberVisible = true
        }
        present(musicSheetVC, animated: true, completion: nil)
    }
    
    @objc private func taskNameChanged(_ textField: UITextField) {
        viewModel.updateTaskName(textField.text ?? "")
    }
    
    func timerDidUpdate() {
        timeLabel.text = viewModel.timeRemaining
        updateProgressLayer()
    }
    
    private func updateProgressLayer() {
        progressLayer.strokeEnd = CGFloat(viewModel.progress)
    }
}








