//
//  StartRehearsalViewController.swift
//  Rehearso
//
//  Created by Mohammad Sulthan on 07/08/21.
//

import UIKit
import AVFoundation

class StartRehearsalViewController: UIViewController {
    @IBOutlet weak var maximumTimeLabel: UILabel!
    @IBOutlet weak var minimumTimeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingSlider: UISlider!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var duration: Int = 20 // in seconds
    
    var cueCard: [CueCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        
        loadCueCardInformation()
        recordingSlider.maximumValue = Float(duration)
        
        let minutes = (duration % 3600) / 60
        let seconds = (duration % 3600) % 60
        maximumTimeLabel.text = String("\(minutes):\(seconds)")
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    private func loadCueCardInformation(){
        cueCard = CoreDataHelper.shared.fetchCueCard()
        print(cueCard)
    }
    
    @objc func updateSlider() {
        if audioRecorder != nil {
            recordingSlider.value = Float(audioRecorder.currentTime)
            var currentTime = Float(audioRecorder.currentTime)
            minimumTimeLabel.text = String("\(currentTime)")
        }
    }
    
    @IBAction func startRecordingButtonAction(_ sender: Any) {
        print(audioRecorder == nil)
        if audioRecorder == nil {
            print("Mulai record")
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            startRecording()
        } else {
            stopButton.isEnabled = false
            recordButton.isEnabled = true
            stopRecording()
        }
    }
    
    @IBAction func stopRecordingButtonAction(_ sender: Any) {
        if audioRecorder != nil {
            recordButton.isEnabled = true
            stopButton.isEnabled = false
            stopRecording()
        }
    }
    
    
    @IBAction func resetButtonBarAction(_ sender: Any) {
        // pause recording
        audioRecorder.pause()
        // tampilkan alert konfirmasi reset rehearsal
        let alert = UIAlertController(title: "Reset rehearsal", message: "Apakah Anda yakin ingin reset rehearsal? Rekaman saat ini tidak akan disimpan", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            // reset reharsal
            self.stopRecording()
            if self.audioRecorder == nil {
                print("nil")
                self.startRecording()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            // continue recording
            self.audioRecorder.record()
        }))
        self.present(alert, animated: true)
    }
    
    func startRecording() {
        let audioFilename = getFileURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record(forDuration: TimeInterval(duration))
        } catch {
            print("Finishing recording")
        }
    }
    
    func stopRecording() {
        if audioRecorder != nil {
            audioRecorder!.stop()
            audioRecorder = nil
            print(audioRecorder == nil)
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setActive(false)
            } catch _ {}
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        // name file should be come from user alert
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }

}

extension StartRehearsalViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }
}
