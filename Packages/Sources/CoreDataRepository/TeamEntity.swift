//
//  TeamEntity.swift
//  FootBallApp
//
//  Created by Son Le on 23/01/2024.
//

import CoreData
import Domain

@objc(TeamEntity)
public class TeamEntity: NSManagedObject, Identifiable {

    static let entityName = "TeamEntity"

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var logoURL: String

    convenience init(id: String, name: String, logoURL: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.logoURL = logoURL
    }
}

extension TeamEntity {
    class func fetchRequest() -> NSFetchRequest<TeamEntity> {
        NSFetchRequest<TeamEntity>(entityName: Self.entityName)
    }
}

extension Team {
    init(_ teamEntity: TeamEntity) {
        self.init(id: teamEntity.id, name: teamEntity.name, logoURL: teamEntity.logoURL)
    }
}
