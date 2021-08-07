//
//  StartRehearsalViewController.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit
import AVFoundation

class PlayRehearsalViewController: UIViewController {
    
    var cueCard: [CueCard] = []
    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    @IBOutlet weak var playSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare player
        preparePlayer()
        
        playSlider.maximumValue = 23
        
        // start audio session
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Error audio session")
        }
    }
    
    func preparePlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL())
            
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
        } catch is NSError {
            print("error playing")
        }
    }
    
    @IBAction func playRehearsalButtonAction(_ sender: Any) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL())
        } catch is NSError {
            print("Error playing")
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
}

extension PlayRehearsalViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }
}
