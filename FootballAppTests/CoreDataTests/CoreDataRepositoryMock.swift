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
        let teams = createMockTeams()
        mockCoreDataRepository.save(teams: teams)

        let fetchedTeams = (try? mockCoreDataRepository.fetchTeams()) ?? []

        XCTAssert(fetchedTeams.count == teams.count)
    }

    func test_insert_matches() {
        let matches = createMockMatches()
        mockCoreDataRepository.save(matches: matches)

        let fetchedMatches = (try? mockCoreDataRepository.fetchMatches()) ?? []
        
        XCTAssert(fetchedMatches.count == matches.count)
    }
}

private extension CoreDataRepositoryMock {
    func createMockMatches() -> [Match] {
        [
            .init(date: "2023-01-23T18:00:00.000Z", description: "",
                  home: "Blue dragon", away: "Red dragon", type: .upcoming),
            .init(date: "2023-02-23T18:00:00.000Z", description: "",
                  home: "Royal Knights", away: "Red dragon", type: .upcoming),
            .init(date: "2023-03-23T18:00:00.000Z", description: "",
                  home: "Chill Elephant", away: "Win King", type: .upcoming),
            .init(date: "2023-04-23T18:00:00.000Z", description: "",
                  home: "Serious Lions", away: "Growling Tigers", type: .previous),
            .init(date: "2023-05-23T18:00:00.000Z", description: "",
                  home: "Blue dragon", away: "Royal Knights", type: .previous)
        ]
    }

    func createMockTeams() -> [Team] {
        [
            .init(id: "1", name: "Blue dragon", logoURL: ""),
            .init(id: "2", name: "red dragon", logoURL: ""),
            .init(id: "3", name: "Royal Knights", logoURL: ""),
            .init(id: "4", name: "Chill Elephant", logoURL: ""),
            .init(id: "5", name: "Win King", logoURL: ""),
            .init(id: "6", name: "Serious Lions", logoURL: ""),
            .init(id: "7", name: "Growling Tigers", logoURL: "")
        ]
    }
}
