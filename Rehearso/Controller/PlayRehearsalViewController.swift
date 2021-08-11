//
//  StartRehearsalViewController.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit
import AVFoundation
import CoreData

class PlayRehearsalViewController: UIViewController {
    
    var cueCard: CueCard?
    var rehearsal: Rehearsal?
    var audioName: String = ""
    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var maximumLength: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rehearse = rehearsal {
            audioName = rehearse.audioName!
            self.title = rehearse.name
        }
        
        // start audio session
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Error audio session")
        }
        
        // prepare player
        preparePlayer()
        maximumLength.text = String(format: "%0.2f", audioPlayer.duration)
        playSlider.maximumValue = Float(audioPlayer.duration)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    @objc func updateSlider() {
        playSlider.value = Float(audioPlayer.currentTime)
        currentValue.text = String(format: "%0.2f", Float(audioPlayer.currentTime))
    }
    
    func preparePlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL(audioName: audioName))
            
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
        } catch is NSError {
            print("error playing")
        }
    }
    
    @IBAction func playRehearsalButtonAction(_ sender: Any) {
        playButton.setImage(UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .large)), for: .normal)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL(audioName: audioName))
            audioPlayer.play()
            
        } catch is NSError {
            print("Error playing")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL(audioName: String) -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(audioName)
        return path as URL
    }
}

extension PlayRehearsalViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .large)), for: .normal)
    }
}
