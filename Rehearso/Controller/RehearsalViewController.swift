//
//  RehearsalViewController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 10/08/21.
//

import UIKit
import AVFoundation

class RehearsalViewController: UIViewController {

    @IBOutlet weak var rehearsalCollection: UICollectionView!
    @IBOutlet weak var recordingSlider: UISlider!
    @IBOutlet weak var resetButtonBar: UIBarButtonItem!
    @IBOutlet weak var maximumTimeLabel: UILabel!
    @IBOutlet weak var doneButtonBar: UIBarButtonItem!
    @IBOutlet weak var minimumTimeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var cueCard: CueCard?
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    var duration:Float? = 0
    let filename = NSUUID().uuidString + ".m4a"
    
    var titleOfPage: [String] = ["Grab Attention","Reason To Listen","State Topic","Credibility Statement","Preview Statement"]
    
    var examples: [String] = ["Example 1","Example 2","Example 3","Example 4","Example 5"]
    
    var isiText: [String] = ["WKWKWKWKWKWKWKWKWKWKWKWK","HAHAAHAHAHAHAHAHHA","LALALLALALLAALLALAAL","PAPAPAPAPAPPAPA","WAWAWWAWAWAWAWAW"]
    
    @IBOutlet weak var myPage: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myPage.currentPage = 0
        myPage.numberOfPages = titleOfPage.count
        
        rehearsalCollection.delegate = self
        rehearsalCollection.dataSource = self
        
        if let cue = cueCard {
            let cueDurationFloat = (cue.length! as NSString).floatValue
            let cueDurationInt = (cue.length! as NSString).integerValue
            
            recordingSlider.maximumValue = Float(cueDurationFloat)
            duration = recordingSlider.maximumValue
            self.title = cue.name

            let minutes = (cueDurationInt % 3600) / 60
            let seconds = (cueDurationInt % 3600) % 60
            
            maximumTimeLabel.text = String("\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
        }
        
        // start audio session
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Error audio session")
        }
        
        if audioRecorder == nil {
            doneButtonBar.title = "Back"
            resetButtonBar.isEnabled = false
        }
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rehearsalCollection.reloadData()
    }
    
    @objc func updateSlider() {
        if audioRecorder != nil {
            
            let currentTime = Int(audioRecorder.currentTime)
            
            let minutes = (currentTime % 3600) / 60
            let seconds = (currentTime % 3600) % 60
            
            recordingSlider.value = Float(currentTime)
            
            minimumTimeLabel.text = String("\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
        }
    }
    
    @IBAction func startRecordingButtonAction(_ sender: Any) {
        if audioRecorder == nil {
            recordButton.setImage(UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)), for: .normal)
            startRecording()
            doneButtonBar.isEnabled = true
            resetButtonBar.isEnabled = true
            recordingSlider.isExclusiveTouch = false
            doneButtonBar.title = "Done"
            resetButtonBar.isEnabled = true
        } else {
            if audioRecorder.isRecording {
                recordButton.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .large)), for: .normal)
                    pauseRecording()
            } else {
                recordButton.setImage(UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .large)), for: .normal)
                resumeRecording()
            }
        }
    }
    
    // kasih opsi simpan recording ketika rehearse
    
    @IBAction func resetButtonBarAction(_ sender: Any) {
        // pause recording
        audioRecorder.pause()
        
        // tampilkan alert konfirmasi reset rehearsal
        let alert = UIAlertController(title: "Reset rehearsal", message: "Apakah Anda yakin ingin reset rehearsal? Rekaman saat ini tidak akan disimpan", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            // reset reharsal
            self.stopRecording()
            self.recordButton.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .large)), for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            // continue recording
            self.audioRecorder.record()
        }))
        
        self.present(alert, animated: true)
    }
    
    func saveRehearsal() {
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
            
            self.audioRecorder = nil
            let recordingName = alert.textFields![0].text
            
            CoreDataHelper.shared.setRehearsal(name: recordingName!, duration: Float(lastTimeRecorder), timestamp: Date(), audioName: self.filename, cueCard: cue)
            if let vc = self.storyboard?.instantiateViewController(identifier: "HistoryController") as? HistoryController {
                vc.cueCardUpdate = self.cueCard
                self.present(vc, animated: true)
            }
            
            self.notifyUser(title: "Saved", message: "Your rehearsal is now saved. Keep repeat your rehearsal")
        }))
        
        self.present(alert, animated: true)
    }
    
    func notifyUser(title: String, message: String) -> Void {
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      present(alert, animated: true, completion: nil)
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
       self.dismiss(animated: true)
      }
    }
    
    @IBAction func doneButtonBarAction(_ sender: Any) {
        stopRecording()
        if audioRecorder == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.saveRehearsalAlert(title: "Save rehearsal", message: "Are you want to save this rehearsal?")
        }
    }
    
    func saveRehearsalAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            self.saveRehearsal()
        }))
        
        alert.addAction(UIAlertAction(title: "Don't save", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
            doneButtonBar.title = "Done"
            audioRecorder.record(forDuration: TimeInterval(duration!))
        } catch {
            print("Finishing recording")
        }
    }
    
    func resumeRecording() {
        if audioRecorder != nil {
            audioRecorder.record()
        }
    }
    
    func pauseRecording() {
        if audioRecorder != nil {
            audioRecorder!.pause()
        }
    }
    
    func stopRecording() {
        if audioRecorder != nil {
            audioRecorder!.stop()
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

extension RehearsalViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.saveRehearsalAlert(title: "Time is up!", message: "Are you want to save this rehearsal?")
        }
    }
}


extension RehearsalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let x = scrollView.contentOffset.x
            let w = scrollView.bounds.size.width
            let currentPage = Int(ceil(x/w))
            self.myPage.currentPage = currentPage
        }
    
    //size cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.size.width
        let itemHeight = (collectionView.frame.size.height)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    // spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleOfPage.count
        return examples.count
        return isiText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rehearsalCell", for: indexPath) as! rehearsalCollectionCell
        
        cell.judulRehearsal.text = titleOfPage[indexPath.row]
        cell.exampleRehearsal.text = examples[indexPath.row]
        cell.isiKontenRehearsal.text = isiText[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        myPage.currentPage = indexPath.row
    }
}

