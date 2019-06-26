//
//  FlashCards+CoreDataProperties.swift
//  KNM
//
//  Created by Mohammad Namvar on 24/01/2019.
//  Copyright © 2019 Mohammad Namvar. All rights reserved.
//
//

import Foundation
import CoreData


extension FlashCards {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlashCards> {
        return NSFetchRequest<FlashCards>(entityName: "FlashCards")
    }

    @NSManaged public var answer: String?
    @NSManaged public var category: Int16
    @NSManaged public var question: String?

}
