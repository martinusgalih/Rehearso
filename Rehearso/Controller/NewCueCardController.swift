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
    
    private var editCue: Bool = false
    private var cueCardUpdate: CueCard?
    
    let datePresentationPicker = UIDatePicker()
    let durationPresentationPicker = UIDatePicker()
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        showDurationPicker()
        viewPresentationData.dropShadow()
        
        let prefix = UILabel()
        prefix.text = " detik "
        // set font, color etc.
        prefix.sizeToFit()

        tfDuration.rightView = prefix
        tfDuration.rightViewMode = .always // or .whileEditing
        
        if syncToCalender.isOn {
            syncToCalender.setOn(true, animated: true)
        }
        syncToCalender.addTarget(self, action: #selector(askForCalendarPermission), for: .valueChanged)
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
            CoreDataHelper.shared.save()
            editCue = false
            self.createBtn.setTitle("Save", for: .normal)
        } else {
            
            // jika ingin sikronisasi dengan calendar
            if syncToCalender.isOn {
                syncWithCalendarAction()
                calendarSynced = true
            }
            CoreDataHelper.shared.setCueCard(name: cueName, date: date, length: length, synced: calendarSynced)
        }
        
        tfPresentationName.text = ""
        tfDateOfPresentation.text = ""
        tfDuration.text = ""
    }
    
    func syncWithCalendarAction() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        
        let event:EKEvent = EKEvent(eventStore: eventStore)
        let startDate = dateFormatter.date(from: tfDateOfPresentation.text!)
        let endDate = startDate!.addingTimeInterval(2 * 60 * 60)
        
        event.title = tfPresentationName?.text
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "Informative Presentation"
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("Berhasil disinmapn")
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
        datePresentationPicker.datePickerMode = .dateAndTime
        
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
        formatter.dateFormat = "dd/MM/yyyy"
        tfDateOfPresentation.text = formatter.string(from: datePresentationPicker.date)
        self.view.endEditing(true)
    }
    
    func showDurationPicker() {
        durationPresentationPicker.datePickerMode = .countDownTimer
        
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
        tfDuration.text = "\(duration)"
        self.view.endEditing(true)
    }
    
    @objc func cancelDurationPicker() {
        self.view.endEditing(true)
    }
}
