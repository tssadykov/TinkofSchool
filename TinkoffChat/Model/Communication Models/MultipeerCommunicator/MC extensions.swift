//
//  MC extensions.swift
//  TinkoffChat
//
//  Created by Тимур on 26/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import MultipeerConnectivity

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let info = info, let userName = info["userName"] else { return }
        let session = MCSession(peer: peerId)
        sessionsDictionary[peerID.displayName] = session
        session.delegate = self
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        delegate?.didFoundUser(userId: peerID.displayName, userName: userName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        sessionsDictionary.removeValue(forKey: peerID.displayName)
        delegate?.didLostUser(userId: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if let session = sessionsDictionary[peerID.displayName] {
            session.delegate = self
            invitationHandler(false, nil)
        } else {
            let session = MCSession(peer: peerId)
            sessionsDictionary[peerID.displayName] = session
            invitationHandler(true, session)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let jsonDecoder = JSONDecoder()
        guard let info = try? jsonDecoder.decode([String:String].self, from: data) else { return }
        delegate?.didReceiveMessage(text: info["text"]!, fromUser: peerID.displayName, toUser: peerId.displayName)
    }
    
}
