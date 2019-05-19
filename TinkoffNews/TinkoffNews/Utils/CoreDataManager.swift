//
//  CoreDataManager.swift
//  TinkoffNews
//
//  Created by Розалия Амирова on 19/05/2019.
//  Copyright © 2019 Розалия Амирова. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinkoffNewsDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
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
    
    func saveFullArticle(article: NewsItem) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FullArticleDataModel", in: managedContext)!
        let articleDataManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        articleDataManagedObject.setValue(article.title, forKey: "title")
        articleDataManagedObject.setValue(DateTimeHelper.getFormattedDate(date: article.date), forKey: "date")
        articleDataManagedObject.setValue(article.text, forKey: "text")
        articleDataManagedObject.setValue(article.slug, forKey: "slug")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func save(article: NewsItem) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ArticleDataModel", in: managedContext)!
        
        let articleDataManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        articleDataManagedObject.setValue(article.title, forKey: "title")
        articleDataManagedObject.setValue(DateTimeHelper.getFormattedDate(date: article.date), forKey: "date")
        articleDataManagedObject.setValue(article.textshort, forKey: "textShort")
        articleDataManagedObject.setValue(article.slug, forKey: "slug")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchAllArticles() -> [ArticleDataModel]?{
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArticleDataModel")
        do {
            let articles = try managedContext.fetch(fetchRequest)
            return articles as? [ArticleDataModel]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func incrementClickCounter(article: ArticleDataModel) {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        article.setValue(article.clickCounter as! Int + 1, forKey: "clickCounter")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    
    func getFullArticleInfo(articleSlug: String) -> FullArticleDataModel? {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        do {
            let fetchRequest : NSFetchRequest<FullArticleDataModel> = FullArticleDataModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "slug == %@", articleSlug)
            let fetchedResults = try context.fetch(fetchRequest)
            if let aContact = fetchedResults.first {
                return aContact
            }
        }
        catch {
            print ("fetch task failed", error)
        }
        return nil
    }
    
    func deleteNews() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleDataModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch {
            print ("There was an error")
        }
    }
}
