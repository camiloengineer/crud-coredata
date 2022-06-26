//
//  Pais+CoreDataProperties.swift
//  TableViews
//
//  Created by Camilo Gonzalez on 17-06-22.
//  Copyright © 2022 MoureDev. All rights reserved.
//
//

import Foundation
import CoreData


extension Pais {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pais> {
        return NSFetchRequest<Pais>(entityName: "Pais")
    }

    @NSManaged public var nombre: String?

}

extension Pais : Identifiable {

}
