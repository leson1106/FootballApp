//
//  MatchEntity.swift
//  FootBallApp
//
//  Created by Son Le on 23/01/2024.
//

import CoreData
import Domain

@objc(MatchEntity)
public class MatchEntity: NSManagedObject, Identifiable {

    static let entityName = "MatchEntity"

    public var id: String { //Local id
        [date, home, away].joined(separator: "|")
    }

    @NSManaged public var date: String
    @NSManaged public var matchDescription: String
    @NSManaged public var home: String
    @NSManaged public var away: String
    @NSManaged public var winner: String?
    @NSManaged public var highlights: String?
    @NSManaged public var type: MatchType

    convenience init(date: String,
                     description: String,
                     home: String,
                     away: String,
                     winner: String?,
                     highlights: String?,
                     type: MatchType,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.date = date
        self.matchDescription = description
        self.home = home
        self.away = away
        self.winner = winner
        self.highlights = highlights
        self.type = type
    }
}

extension MatchEntity {
    class func fetchRequest() -> NSFetchRequest<MatchEntity> {
        NSFetchRequest<MatchEntity>(entityName: Self.entityName)
    }
}

extension Match {
    init(_ matchEntity: MatchEntity) {
        self.init(date: matchEntity.date,
                  description: matchEntity.matchDescription,
                  home: matchEntity.home,
                  away: matchEntity.away,
                  winner: matchEntity.winner,
                  highlights: matchEntity.highlights,
                  type: matchEntity.type)
    }
}
