//
//  AddTimerViewController.swift
//  PomodoroApp
//
//  Created by Necati Alperen IŞIK on 14.08.2024.
//

import UIKit

final class AddTimerViewController: UIViewController {
    
    private lazy var taskNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please enter session name"
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.delegate = self
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let focusTimeButton = UIButton()
    private let shortBreakButton = UIButton()
    private let sectionsButton = UIButton()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var focusTimePicker: UIPickerView?
    private var shortBreakPicker: UIPickerView?
    private var sectionsPicker: UIPickerView?
    
    private var focusTimeData = ["20 min", "25 min", "30 min"]
    private var shortBreakData = ["5 min", "10 min", "15 min"]
    private var sections = ["2", "3", "4"]
    
    private var isFocusTimePickerVisible = false
    private var isShortBreakPickerVisible = false
    private var sectionsPickerVisible = false
    
    private var focusTimePickerHeightConstraint: NSLayoutConstraint!
    private var shortBreakPickerHeightConstraint: NSLayoutConstraint!
    private var sectionsPickerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        
        setupUI()
    }
    
    private func setupUI() {
        // Configure buttons with down arrow
        configureButton(focusTimeButton, title: "Focus time: \(focusTimeData[0])")
        configureButton(shortBreakButton, title: "Short break: \(shortBreakData[0])")
        configureButton(sectionsButton, title: "Sections: \(sections[0])")
        
        // Configure stack view for save and cancel buttons
        let actionStackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        actionStackView.axis = .horizontal
        actionStackView.distribution = .fillEqually
        actionStackView.spacing = 10
        actionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure pickers
        configurePickerView(&focusTimePicker)
        configurePickerView(&shortBreakPicker)
        configurePickerView(&sectionsPicker)
        
        // Add buttons and pickers to view
        view.addSubview(taskNameTextField)
        view.addSubview(focusTimeButton)
        view.addSubview(focusTimePicker!)
        view.addSubview(shortBreakButton)
        view.addSubview(shortBreakPicker!)
        view.addSubview(sectionsButton)
        view.addSubview(sectionsPicker!)
        view.addSubview(actionStackView)
        
        // Add targets to buttons
        focusTimeButton.addTarget(self, action: #selector(toggleFocusTimePicker), for: .touchUpInside)
        shortBreakButton.addTarget(self, action: #selector(toggleShortBreakPicker), for: .touchUpInside)
        sectionsButton.addTarget(self, action: #selector(toggleSectionsPicker), for: .touchUpInside)
        
        // Constraints for buttons and pickers
        focusTimePickerHeightConstraint = focusTimePicker!.heightAnchor.constraint(equalToConstant: 0)
        shortBreakPickerHeightConstraint = shortBreakPicker!.heightAnchor.constraint(equalToConstant: 0)
        sectionsPickerHeightConstraint = sectionsPicker!.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            taskNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            taskNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            taskNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            focusTimeButton.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 16),
            focusTimeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            focusTimeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            focusTimeButton.heightAnchor.constraint(equalToConstant: 100),
            
            focusTimePicker!.topAnchor.constraint(equalTo: focusTimeButton.bottomAnchor, constant: 8),
            focusTimePicker!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            focusTimePicker!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            focusTimePickerHeightConstraint,
            
            shortBreakButton.topAnchor.constraint(equalTo: focusTimePicker!.bottomAnchor, constant: 8),
            shortBreakButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shortBreakButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shortBreakButton.heightAnchor.constraint(equalToConstant: 100),
            
            shortBreakPicker!.topAnchor.constraint(equalTo: shortBreakButton.bottomAnchor, constant: 8),
            shortBreakPicker!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shortBreakPicker!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shortBreakPickerHeightConstraint,
            
            sectionsButton.topAnchor.constraint(equalTo: shortBreakPicker!.bottomAnchor, constant: 8),
            sectionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sectionsButton.heightAnchor.constraint(equalToConstant: 100),
            
            sectionsPicker!.topAnchor.constraint(equalTo: sectionsButton.bottomAnchor, constant: 8),
            sectionsPicker!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionsPicker!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sectionsPickerHeightConstraint,
            
            actionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionStackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        hidePickers()
    }
    
    private func configureButton(_ button: UIButton, title: String, isPrimary: Bool = false, showArrow: Bool = true) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = isPrimary ? .systemBlue : .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 120).isActive = true
        button.contentHorizontalAlignment = .left // Align text to the left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        if showArrow {
            let downArrow = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
            button.setImage(downArrow, for: .normal)
            button.tintColor = .white
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    private func configurePickerView(_ pickerView: inout UIPickerView?) {
        let newPickerView = UIPickerView()
        newPickerView.backgroundColor = .darkGray
        newPickerView.layer.cornerRadius = 10
        newPickerView.translatesAutoresizingMaskIntoConstraints = false
        newPickerView.delegate = self
        newPickerView.dataSource = self
        view.addSubview(newPickerView)
        pickerView = newPickerView
    }
    
    private func hidePickers() {
        focusTimePickerHeightConstraint.constant = 0
        shortBreakPickerHeightConstraint.constant = 0
        sectionsPickerHeightConstraint.constant = 0
    }
    
    @objc private func cancelButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped(){
        // TODO : write to core data
        dismiss(animated: true)
    }
    
    @objc private func toggleFocusTimePicker() {
        if let focusTimePicker = focusTimePicker {
            togglePickerVisibility(&isFocusTimePickerVisible, pickerView: focusTimePicker, heightConstraint: focusTimePickerHeightConstraint)
        }
    }
    
    @objc private func toggleShortBreakPicker() {
        if let shortBreakPicker = shortBreakPicker {
            togglePickerVisibility(&isShortBreakPickerVisible, pickerView: shortBreakPicker, heightConstraint: shortBreakPickerHeightConstraint)
        }
    }
    
    @objc private func toggleSectionsPicker() {
        if let longBreakPicker = sectionsPicker {
            togglePickerVisibility(&sectionsPickerVisible, pickerView: longBreakPicker, heightConstraint: sectionsPickerHeightConstraint)
        }
    }
    
    private func togglePickerVisibility(_ visibilityFlag: inout Bool, pickerView: UIPickerView, heightConstraint: NSLayoutConstraint) {
        visibilityFlag.toggle()
        heightConstraint.constant = visibilityFlag ? 100 : 0
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
        if visibilityFlag {
            hideOtherPickers(except: pickerView)
        }
    }
    
    private func hideOtherPickers(except pickerView: UIPickerView) {
        if pickerView != focusTimePicker { isFocusTimePickerVisible = false; focusTimePickerHeightConstraint.constant = 0 }
        if pickerView != shortBreakPicker { isShortBreakPickerVisible = false; shortBreakPickerHeightConstraint.constant = 0 }
        if pickerView != sectionsPicker { sectionsPickerVisible = false; sectionsPickerHeightConstraint.constant = 0 }
        
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }
}

extension AddTimerViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == focusTimePicker {
            return focusTimeData.count
        } else if pickerView == shortBreakPicker {
            return shortBreakData.count
        } else if pickerView == sectionsPicker {
            return sections.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == focusTimePicker {
            return focusTimeData[row]
        } else if pickerView == shortBreakPicker {
            return shortBreakData[row]
        } else if pickerView == sectionsPicker {
            return sections[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == focusTimePicker {
            focusTimeButton.setTitle("Focus time: \(focusTimeData[row])", for: .normal)
        } else if pickerView == shortBreakPicker {
            shortBreakButton.setTitle("Short break: \(shortBreakData[row])", for: .normal)
        } else if pickerView == sectionsPicker {
            sectionsButton.setTitle("Sections: \(sections[row])", for: .normal)
        }
    }
}
