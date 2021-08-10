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
        save{
            CoreDataHelper.shared.setSection(part: "1. Introduction", cueCard: cueCard)
            CoreDataHelper.shared.setSection(part: "2. Body", cueCard: cueCard)
            CoreDataHelper.shared.setSection(part: "3. Conclusion", cueCard: cueCard)
        }
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

    func setIsi(part: String, title: String, content: String, example: String, section: Section) {
        let isii = Isi(context: coreDataHelper.viewContext)
        isii.id = UUID()
        isii.title = title
        isii.content = content
        isii.example = example
        isii.part = part
        isii.section = section
        save{
            CoreDataHelper.shared.setIsiKonten(title: "Grab Attention", content: "Do or say something shocking, intriguing, or dramatic to get attention of the audience from the very first minutes.", example: "Morgan robertson once wrote a book called The Wreck Of Titan.", isi: isii)
            CoreDataHelper.shared.setIsiKonten(title: "Reason To Listen", content: "Give the audience a reason why your presentation is relevant / worth listening to", example: "Morgan robertson once wrote a book called The Wreck Of Titan.", isi: isii)
            CoreDataHelper.shared.setIsiKonten(title: "State Topic", content: "Announce what your speech is about, and your position.", example: "Morgan robertson once wrote a book called The Wreck Of Titan.", isi: isii)
        }
        
    }
    
    func setIsiKonten(title: String, content: String, example: String, isi: Isi) {
        let isiKonten = IsiKonten(context: coreDataHelper.viewContext)
        isiKonten.id = UUID()
        isiKonten.title = title
        isiKonten.content = content
        isiKonten.example = example
        isiKonten.isi = isi
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
    
    func fetchRehearsal() -> [Rehearsal] {
        let request: NSFetchRequest<Rehearsal> = Rehearsal.fetchRequest()

        var rehearsal: [Rehearsal] = []

        do {
            rehearsal = try coreDataHelper.viewContext.fetch(request)
        } catch {
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

    func fetchSection(cueCard: CueCard) -> [Section] {
        let request: NSFetchRequest<Section> = Section.fetchRequest()

//        request.fetchOffset = 0
//        request.fetchLimit = 3

        request.predicate = NSPredicate(format: "(cueCard = %@)", cueCard)
        request.sortDescriptors = [NSSortDescriptor(key: "part", ascending: true)]
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

    func fetchIsiKonten(isi: Isi, onSuccess : @escaping ()->Void) -> [IsiKonten] {
        let request: NSFetchRequest<IsiKonten> = IsiKonten.fetchRequest()

        request.predicate = NSPredicate(format: "(isi = %@)", isi)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        var isiKonten: [IsiKonten] = []

        do{
            isiKonten = try coreDataHelper.viewContext.fetch(request)
            for item in isiKonten {
                print("Keyword \(item.content)")
            
            }
            onSuccess()
        }catch {
            print("Error fetching isi data")
        }
        return isiKonten
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
