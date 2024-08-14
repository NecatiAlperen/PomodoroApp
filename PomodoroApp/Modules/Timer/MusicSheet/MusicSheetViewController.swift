//
//  MusicSheetViewController.swift
//  PomodoroApp
//
//  Created by Necati Alperen IŞIK on 13.08.2024.
//

import UIKit

final class MusicSheetViewController: UIViewController {

    private var viewModel: MusicSheetViewModelProtocol = MusicSheetViewModel()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Odaklanmana Yardımcı Bir Ses Seç"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: (view.frame.width - 64) / 3, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SoundCollectionViewCell.self, forCellWithReuseIdentifier: "SoundCell")
        return collectionView
    }()
    
    private lazy var musicButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Müziği Kapat", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stopMusic), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(musicButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: musicButton.topAnchor, constant: -16),
            
            musicButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            musicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            musicButton.widthAnchor.constraint(equalToConstant: 200),
            musicButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func stopMusic() {
        viewModel.stopMusic()
    }
}

// MARK: -- Extensions

extension MusicSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundCell", for: indexPath) as! SoundCollectionViewCell
        let sound = viewModel.sounds[indexPath.item]
        cell.configure(withIconName: sound.iconName!, iconColor: sound.iconColor!, title: sound.title!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = viewModel.sounds[indexPath.item]
        viewModel.playMusic(for: track)
    }
}





