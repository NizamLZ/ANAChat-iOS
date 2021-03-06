//
//  Message+CoreDataProperties.swift
//  ANAChat
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var dateStamp: String?
    @NSManaged public var flowId: String?
    @NSManaged public var messageId: String?
    @NSManaged public var messageType: Int16
    @NSManaged public var responseTo: String?
    @NSManaged public var senderType: Int16
    @NSManaged public var sessionId: String?
    @NSManaged public var sessionStatus: Bool
    @NSManaged public var syncedWithServer: Bool
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var prevFlowId: String?
    @NSManaged public var currentFlowId: String?
    @NSManaged public var recipient: Participant?
    @NSManaged public var sender: Participant?

}
