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
    
    var cueCard: CueCard?
    var rehearsalName: String = ""
    var duration:Float? = 0
    let filename = NSUUID().uuidString + ".m4a"

    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        
//        var intTotalUnits:Int? = Int(fldTotalUnits)
        
        if let cue = cueCard {
            let cueDurationFloat = (cue.length! as NSString).floatValue
            let cueDurationInt = (cue.length! as NSString).integerValue
            
            recordingSlider.maximumValue = Float(cueDurationFloat)
            duration = recordingSlider.maximumValue

            maximumTimeLabel.text = "\(recordingSlider.maximumValue)"

            let minutes = (cueDurationInt % 3600) / 60
            let seconds = (cueDurationInt % 3600) % 60
            maximumTimeLabel.text = String("\(minutes):\(seconds)")
        }
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    @objc func updateSlider() {
        if audioRecorder != nil {
            recordingSlider.value = Float(audioRecorder.currentTime)
            let currentTime = Float(audioRecorder.currentTime)
            minimumTimeLabel.text = String("\(currentTime)")
        }
    }
    
    @IBAction func startRecordingButtonAction(_ sender: Any) {
        if audioRecorder == nil {
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
                self.startRecording()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            // continue recording
            self.audioRecorder.record()
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func doneButtonBarAction(_ sender: Any) {
        // stop recording
        let lastTimeRecorder = audioRecorder.currentTime
        stopRecording()
        
        // show alert button with textfield
        let alert = UIAlertController(title: "Rehearsal done", message: "Give your rehearsal a name", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Enter your rehearsal name here"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            // save to coredata
            guard let cue = self.cueCard else {
                print("Cue Card Error")
                return
            }
            
            let recordingName = alert.textFields![0].text
            CoreDataHelper.shared.setRehearsal(name: recordingName!, duration: Float(lastTimeRecorder), timestamp: Date(), audioName: self.filename, cueCard: cue)
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
            audioRecorder.record(forDuration: TimeInterval(duration!))
        } catch {
            print("Finishing recording")
        }
    }
    
    func stopRecording() {
        if audioRecorder != nil {
            audioRecorder!.stop()
            audioRecorder = nil
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
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        return path as URL
    }
}

extension StartRehearsalViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }
}
