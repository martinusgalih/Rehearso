//
//  Helper.swift
//  CoreDataRelation
//
//  Created by Martinus Galih Widananto on 02/08/21.
//

import Foundation
import CoreData


class CoreDataHelper {
    static let shared = CoreDataHelper()

    lazy var coreDataHelper: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Rehearso")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func setCueCard(name: String, date: String, length: String, synced: Bool) {
        let cueCard = CueCard(context: coreDataHelper.viewContext)
        cueCard.id = UUID()
        cueCard.name = name
        cueCard.date = date
        cueCard.length = length
        cueCard.syncToCalendar = synced
        save{            CoreDataHelper.shared.setSection(part: "Introduction", cueCard: cueCard)
            CoreDataHelper.shared.setSection(part: "Body", cueCard: cueCard)
            CoreDataHelper.shared.setSection(part: "Conclusion", cueCard: cueCard)
        }
        print("Hasil Core\(String(describing: cueCard.name))")
    }

    func setRehearsal(name: String, duration: Float, timestamp: Date, audioName: String, cueCard: CueCard) {
        let rehearsal = Rehearsal(context: coreDataHelper.viewContext)
        
        rehearsal.name = name
        rehearsal.duration = duration
        rehearsal.timestamp = timestamp
        rehearsal.audioName = audioName
        rehearsal.cueCard = cueCard
        save {}
    }

    func setSection(part: String, cueCard: CueCard) {
        let section = Section(context: coreDataHelper.viewContext)
        section.id = UUID()
        section.part = part
        section.cueCard = cueCard
        save{}
    }

    func setIsi(part: String, isi: String, section: Section) {
        let isii = Isi(context: coreDataHelper.viewContext)
        isii.id = UUID()
        isii.isi = isi
        isii.part = part
        isii.section = section
        save{}
    }

    func fetchCueCard() -> [CueCard] {
        let request: NSFetchRequest<CueCard> = CueCard.fetchRequest()

        var cueCard: [CueCard] = []

        do {
            cueCard = try coreDataHelper.viewContext.fetch(request)
        } catch {
            print("Error fetching cuecard data")
        }

        return cueCard
    }
    
    func fetchRehearsal(cueCard: CueCard) -> [Rehearsal] {
        let request: NSFetchRequest<Rehearsal> = Rehearsal.fetchRequest()

//        request.fetchOffset = 0
//        request.fetchLimit = 3

        request.predicate = NSPredicate(format: "(cueCard = %@)", cueCard)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        var rehearsal: [Rehearsal] = []

        do{
            rehearsal = try coreDataHelper.viewContext.fetch(request)
        }catch {
            print("Error fetching rehearsal data")
        }
        return rehearsal
    }

    func deleteCueCard(cueCard : CueCard) {
        coreDataHelper.viewContext.delete(cueCard)
        save{}
    }

    func deleteIsi(isi: Isi) {
        coreDataHelper.viewContext.delete(isi)
        save{}
    }
    
    func deleteRehearsal(rehearsal: Rehearsal) {
        coreDataHelper.viewContext.delete(rehearsal)
        save{}
    }

    func fetchSection(cueCard: CueCard) -> [Section] {
        let request: NSFetchRequest<Section> = Section.fetchRequest()

//        request.fetchOffset = 0
//        request.fetchLimit = 3

        request.predicate = NSPredicate(format: "(cueCard = %@)", cueCard)
        request.sortDescriptors = [NSSortDescriptor(key: "part", ascending: false)]
        var section: [Section] = []

        do{
            section = try coreDataHelper.viewContext.fetch(request)
        }catch {
            print("Error fetching section data")
        }
        return section
    }


    func fetchIsi(section: Section) -> [Isi] {
        let request: NSFetchRequest<Isi> = Isi.fetchRequest()

        request.predicate = NSPredicate(format: "(section = %@)", section)

        request.sortDescriptors = [NSSortDescriptor(key: "part", ascending: true)]

        var isi: [Isi] = []

        do{
            isi = try coreDataHelper.viewContext.fetch(request)
        }catch {
            print("Error fetching isi data")
        }
        return isi
    }

    func save (onSuccess : @escaping ()->Void) {
        let context = coreDataHelper.viewContext
        if context.hasChanges {
            do {
                try context.save()
                onSuccess()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
