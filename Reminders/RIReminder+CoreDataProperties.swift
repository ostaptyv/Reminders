//
//  RIReminder+CoreDataProperties.swift
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/26/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//
//

import Foundation
import CoreData


extension RIReminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RIReminder> {
        return NSFetchRequest<RIReminder>(entityName: "RIReminder")
    }


}
