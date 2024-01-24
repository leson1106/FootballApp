//
//  CoreDataRepository.swift
//
//  Created by Son Le on 24/01/2024.
//

import CoreData
import Domain

public protocol CoreDataRepository {
    func save(matches: [Match])
    func save(teams: [Team])
    func fetchMatches() throws -> [Match]
    func fetchTeams() throws -> [Team]
}

extension Bundle {
    public static let bundle: Bundle = Bundle.module
}

public final class CoreDataRepositoryDefault: NSObject {

    public static let shared = CoreDataRepositoryDefault()

    private var persistentContainer: NSPersistentContainer!
    private var context: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    public override convenience init() {
        guard let modelURL = Bundle.module.url(forResource: "FootBallApp", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Loading CoreData model error")
        }
        let persistentContainer = NSPersistentContainer(name: "FootBallApp", managedObjectModel: model)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        })
        self.init(persistentContainer: persistentContainer)
    }

    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
}

extension CoreDataRepositoryDefault: CoreDataRepository {
    public func save(matches: [Match]) {
        let context = self.context
        try? context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MatchEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)

            for match in matches {
                _ = MatchEntity(date: match.date,
                                description: match.description,
                                home: match.home,
                                away: match.away,
                                winner: match.winner,
                                highlights: match.highlights,
                                type: match.type,
                                context: context)
            }
            try context.save()
        }
    }

    public func fetchMatches() throws -> [Match] {
        let context = self.context
        let request = MatchEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(MatchEntity.date), ascending: false),
            NSSortDescriptor(key: #keyPath(MatchEntity.home), ascending: false)
        ]
        guard let objects = try? context.fetch(request) else { return [] }
        return objects.map { Match($0) }
    }

    public func save(teams: [Team]) {
        let context = self.context
        try? context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TeamEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)

            for team in teams {
                _ = TeamEntity(id: team.id,
                               name: team.name,
                               logoURL: team.logoURL,
                               context: context)
            }

            guard context.hasChanges else {
                return
            }
            try context.save()
        }
    }

    public func fetchTeams() throws -> [Team] {
        let context = self.context
        let request = TeamEntity.fetchRequest()
        guard let objects = try? context.fetch(request) else { return [] }
        return objects.map { Team($0) }
    }
}
