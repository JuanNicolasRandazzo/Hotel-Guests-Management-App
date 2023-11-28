//
//  CoreDataProvider.swift
//  FinalExamReview
//
//  Created by english on 2023-11-28.
//

import Foundation
import CoreData


class CoreDataProvider{
    
    static func all( context : NSManagedObjectContext, entityName : String ) -> [Any?]{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let allObjects = try context.fetch(request)
            return allObjects
        } catch {
            print("*** Exception at CoreDataProvider.all *** \n\(error.localizedDescription)")
            return []
        }
        
    }

    
    static func findOne( context : NSManagedObjectContext, entityName : String, key : String, value : String) -> Any? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        request.predicate = NSPredicate(format: "\(key) == %@", value)
        
        do {
            let objects = try context.fetch(request)
            if objects.count > 0 {
                return objects[0]
            } else {
                return nil
            }
        } catch {
            print("*** Exception at CoreDataProvider.all *** \n\(error.localizedDescription)")
            return nil
        }
        
    }
    
    static func save( context : NSManagedObjectContext ) throws {
        
        do {
            try context.save()
        } catch {
            print("*** Exception at CoreDataProvider.all *** \n\(error.localizedDescription)")
            throw error
        }
    }

    
    static func delete( context : NSManagedObjectContext, objectToDelete : NSManagedObject ) throws {
        
        do {
            context.delete(objectToDelete)
            try context.save()
        } catch {
            print("*** Exception at CoreDataProvider.all *** \n\(error.localizedDescription)")
            throw error
        }
    }

    
}
