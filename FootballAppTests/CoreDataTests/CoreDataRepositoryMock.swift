//
//  CoreDataRepositoryMock.swift
//  FootballAppTests
//
//  Created by Son Le on 24/01/2024.
//

import XCTest
import CoreDataRepository
import Domain
import CoreData

final class CoreDataRepositoryMock: XCTestCase {

    var mockPersistenceContainer: NSPersistentContainer!
    lazy var mockCoreDataRepository = CoreDataRepositoryDefault(persistentContainer: mockPersistenceContainer)

    override func setUp() {
        super.setUp()

        guard let modelURL = Bundle.bundle.url(forResource: "FootBallApp", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Loading CoreData model error")
        }

        let description = NSPersistentStoreDescription()
        let storeURL = URL(fileURLWithPath: "/dev/null")
        description.url = storeURL
        let container = NSPersistentContainer(name: "FootBallApp", managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        mockPersistenceContainer = container
    }

    func test_insert_teams() {
        let teams: [Team] = [
            .init(id: "1", name: "Red dragon", logoURL: ""),
            .init(id: "2", name: "Blue dragon", logoURL: "")
        ]

        mockCoreDataRepository.save(teams: teams)

        let fetchedTeams = try? mockCoreDataRepository.fetchTeams()

        XCTAssertTrue((fetchedTeams ?? []).count == 2)
    }
}
