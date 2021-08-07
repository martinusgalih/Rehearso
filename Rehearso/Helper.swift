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
        save()
        print("\(cueCard)")
    }
    
    func setSection(part: String, cueCard: CueCard) {
        let section = Section(context: coreDataHelper.viewContext)
        section.id = UUID()
        section.part = part
        section.cueCard = cueCard
        save()
    }
    
    func setIsi(part: String, isi: String, section: Section) {
        let isii = Isi(context: coreDataHelper.viewContext)
        isii.id = UUID()
        isii.isi = isi
        isii.part = part
        isii.section = section
        save()
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
    
    func deleteCueCard(cueCard : CueCard) {
        coreDataHelper.viewContext.delete(cueCard)
        save()
    }
    
    func deleteIsi(isi: Isi) {
        coreDataHelper.viewContext.delete(isi)
        save()
    }
    
    func fetchSection(cueCard: CueCard) -> [Section] {
        let request: NSFetchRequest<Section> = Section.fetchRequest()
        
        request.fetchOffset = 0
        request.fetchLimit = 3
        
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
    
    func save () {
        let context = coreDataHelper.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
