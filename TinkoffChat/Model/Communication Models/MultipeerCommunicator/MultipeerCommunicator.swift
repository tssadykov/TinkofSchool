//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Тимур on 25/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var session: MCSession!
    var peerId: MCPeerID!
    var sessionsDictionary: [String: MCSession] = [:]
    
    weak var delegate: CommunicatorDelegate?
    
    var online: Bool = false
    
    init(profile: Profile) {
        super.init()
        
        peerId = MCPeerID(displayName: UIDevice.current.name)
        browser = MCNearbyServiceBrowser(peer: peerId, serviceType: "tinkoff-chat")
        advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: ["userName" : profile.name], serviceType: "tinkoff-chat")
        browser.delegate = self
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userId: String, completionHandler: MessageHandler?) {
        guard let session = sessionsDictionary[userId] else { return }
        let dictionaryToSend = ["eventType" : "TextMessage", "messageId" : generateMessageId(), "text" : string]
        guard let data = try? JSONSerialization.data(withJSONObject: dictionaryToSend, options: .prettyPrinted) else { return }
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            if let completion = completionHandler {
                completion(true, nil)
            }
        } catch let error {
            if let completion = completionHandler {
                completion(false, error)
            }
        }
    }
    
    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
