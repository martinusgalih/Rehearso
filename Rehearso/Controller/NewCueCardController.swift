//
//  NewCueCardController.swift
//  Rehearso
//
//  Created by Diana Febrina Lumbantoruan on 04/08/21.
//

import UIKit
import CoreData
import EventKit

class NewCueCardController: UIViewController {

    @IBOutlet weak var viewPresentationData: UIView!
    @IBOutlet weak var tfPresentationName: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tfDateOfPresentation: UITextField!
    @IBOutlet weak var syncToCalender: UISwitch!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet var navigationButton: UIButton!
    
    private var editCue: Bool = false
    private var cueCardUpdate: CueCard?
    private var cueCard : [CueCard] = []
    
    var sectionData : [Section] = []
    var section : CueCard?
    var selectedDate: Date?
    
    let datePresentationPicker = UIDatePicker()
    let durationPresentationPicker = UIDatePicker()
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDatePicker()
        showDurationPicker()
        viewPresentationData.dropShadow()
        
        if syncToCalender.isOn {
            syncToCalender.setOn(true, animated: true)
        }
        syncToCalender.addTarget(self, action: #selector(askForCalendarPermission), for: .valueChanged)
    }
    
    @IBAction func navButton(_ sender: Any) {
        navigationButton.is
    }
    @IBAction func btnCreatePresentation(_ sender: Any) {
        guard let cueName = tfPresentationName.text else {
            print("Error presentation name")
            return
        }
        
        guard let date = tfDateOfPresentation.text else {
            print("Error presentation date")
            return
        }
        
        guard let length = tfDuration.text else {
            print("Error length")
            return
        }
        
        var calendarSynced = false
        
        // jika mode edit
        if editCue {
            cueCardUpdate?.name = cueName
            cueCardUpdate?.date = date
            cueCardUpdate?.length = length
            CoreDataHelper.shared.save{
                self.editCue = false
                self.createBtn.setTitle("Save", for: .normal)
            }
            
        } else {
            
            // jika ingin sikronisasi dengan calendar
            if syncToCalender.isOn {
                self.syncWithCalendarAction()
                calendarSynced = true
                
            }
            
            CoreDataHelper.shared.setCueCard(name: cueName, date: date, length: length, synced: calendarSynced)
            load()
            
            var sectionData : [Section] = []
            
            if let vc = storyboard?.instantiateViewController(identifier: "SectionEditorController") as? SectionEditorController {
                
                var counter = cueCard.count
                vc.titleVC = cueName
                vc.cueCardUpdate = cueCard[counter - 1]
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if syncToCalender.isOn {
                self.notifyUser(title: "Calendar Synced!", message: "Your event now will remind you 1 day before event. Keep rehearsing.")
            }
        }
        
        tfPresentationName.text = ""
        tfDateOfPresentation.text = ""
        tfDuration.text = ""
    }
    
    func notifyUser(title: String, message: String) -> Void {
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      present(alert, animated: true, completion: nil)
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
       self.dismiss(animated: true)
      }
    }
    
    private func load(){
        cueCard = CoreDataHelper.shared.fetchCueCard()
        
    }

    func syncWithCalendarAction() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        
        let event:EKEvent = EKEvent(eventStore: eventStore)
        
        let startDate = selectedDate
        let endDate = startDate!.addingTimeInterval(2 * 60 * 60)
        
        let alarm1daybefore = EKAlarm(relativeOffset: 86400)
        
        event.title = tfPresentationName?.text
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "Informative Presentation"
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.addAlarm(alarm1daybefore)
        
        do {
            try eventStore.save(event, span: .thisEvent)
            return true
        } catch let error as NSError {
            print("Failed to save event with error: \(error)")
            return false
        }
    }
    
    @objc func askForCalendarPermission() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            print("Permission authorized")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted: Bool, error: Error?) -> Void in
                if granted {
                    print("Granted")
                } else {
                    let alert = UIAlertController(title: "Permission denied", message: "Your schedule will never be syncrhonized with Calendar.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                }
            })
        case .denied:
            let alert = UIAlertController(title: "Permission denied", message: "Your schedule will never be syncrhonized with Calendar.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Permission denied", style: .default))
        case .restricted:
            print("Event restricted")
        @unknown default:
            print("Case default")
        }
    }
    
    func showDatePicker() {
        datePresentationPicker.datePickerMode = .date
        
        if #available(iOS 14, *) {
            datePresentationPicker.preferredDatePickerStyle = .wheels
            datePresentationPicker.sizeToFit()
        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelDatePicker))
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: true)
        tfDateOfPresentation.inputAccessoryView = toolbar
        tfDateOfPresentation.inputView = datePresentationPicker
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        selectedDate = datePresentationPicker.date
        tfDateOfPresentation.text = formatter.string(from: datePresentationPicker.date)
        self.view.endEditing(true)
    }
    
    func showDurationPicker() {
        durationPresentationPicker.datePickerMode = .countDownTimer
        durationPresentationPicker.minuteInterval = 1
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneDurationPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelDatePicker))
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: true)
        
        tfDuration.inputAccessoryView = toolbar
        tfDuration.inputView = durationPresentationPicker
    }
    
    @objc func doneDurationPicker() {
        var duration: TimeInterval = 0
        
        duration = durationPresentationPicker.countDownDuration
        
        let hours = (Int(duration) / 3600)
        let minutes = (Int(duration) % 3600) / 60
        let seconds = (Int(duration) % 3600) % 60
        
        tfDuration.text = ("\(String(format: "%02d", hours)) jam \(String(format: "%02d", minutes)) menit \(String(format: "%02d", seconds)) detik")
        self.view.endEditing(true)
    }
    
    @objc func cancelDurationPicker() {
        self.view.endEditing(true)
    }
}
