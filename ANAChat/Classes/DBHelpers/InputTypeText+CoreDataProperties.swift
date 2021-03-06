//
//  InputTypeText+CoreDataProperties.swift
//

import Foundation
import CoreData


extension InputTypeText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputTypeText> {
        return NSFetchRequest<InputTypeText>(entityName: "InputTypeText")
    }

    @NSManaged public var defaultText: String?
    @NSManaged public var inputJson: NSObject?
    @NSManaged public var maxLength: Int32
    @NSManaged public var minLength: Int32
    @NSManaged public var multiLine: Int16
    @NSManaged public var placeHolder: String?
    @NSManaged public var text: String?

}
