import Foundation

final class CallStation {
    var userArray = [User]()
    var callArray = [Call]()
    var usersCallDictionary = [User: [Call]]()
}

extension CallStation: Station {
    func users() -> [User] {
        userArray
    }
    
    // Add new user
    func add(user: User) {
        if !userArray.contains(user) {
            userArray.append(user)
            usersCallDictionary[user] = []
        }
    }
    
    // Remove current user
    func remove(user: User) {
        let index:Int = userArray.firstIndex(of: user)!
        userArray.remove(at: index)
    }
    
    // Execute call action
    func execute(action: CallAction) -> CallID? {

        switch action {
        // Start calling
        case .start(let from, let to):
            
            // Check if user isnot created
            if users().contains(from) {
                if !users().contains(to) {
                    let call = Call(id: from.id, incomingUser: to, outgoingUser: from, status: .ended(reason: .error))
                    callArray.append(call)
                    usersCallDictionary[call.incomingUser]?.append(call)
                    usersCallDictionary[call.outgoingUser]?.append(call)
                    return call.id
                }
                
                // Check if user was busy
                if currentCall(user: to) != nil {
                    let call = Call(id: from.id, incomingUser: to, outgoingUser: from, status: .ended(reason: .userBusy))
                    callArray.append(call)
                    usersCallDictionary[call.incomingUser]?.append(call)
                    usersCallDictionary[call.outgoingUser]?.append(call)
                    return call.id
                }
                
                // Check if user is going to call himself
                if from.id != to.id {
                    let call = Call(id: from.id, incomingUser: to, outgoingUser: from, status: .calling)
                    callArray.append(call)
                    usersCallDictionary[call.incomingUser]?.append(call)
                    usersCallDictionary[call.outgoingUser]?.append(call)
                    return call.id
                }
            }
            return nil
            
            
            
        // User answered
        case .answer(let from):
            let incomingCall = currentCall(user: from)
            if incomingCall != nil {
                if users().contains(from) {
                    let call = Call(id: incomingCall?.id ?? from.id, incomingUser: from, outgoingUser: incomingCall?.outgoingUser ?? from, status: .talk)
                    callArray.removeFirst()
                    callArray.append(call)
                    return call.id
                } else {
                    let call = Call(id: incomingCall?.id ?? from.id, incomingUser: from, outgoingUser: incomingCall?.outgoingUser ?? from, status: .ended(reason: .error))
                    callArray.removeFirst()
                    callArray.append(call)
                    return nil
                }
            }
            
            
        // End of call
        case .end(let from):
            
            let incomingCall = currentCall(user: from)
            if incomingCall != nil {
                if incomingCall?.status == CallStatus.talk {
                    let call = Call(id: incomingCall?.id ?? from.id, incomingUser: from, outgoingUser: incomingCall?.outgoingUser ?? from, status: .ended(reason: .end))
                    callArray.removeFirst()
                    callArray.append(call)
                    return call.id
                }
                
                if incomingCall?.status == CallStatus.calling {
                    let call = Call(id: incomingCall?.id ?? from.id, incomingUser: from, outgoingUser: incomingCall?.outgoingUser ?? from, status: .ended(reason: .cancel))
                    callArray.removeFirst()
                    callArray.append(call)
                    
                    return call.id
                }
            }
        }
        return nil
    }

    func calls() -> [Call] {
        callArray
    }
    
    func calls(user: User) -> [Call] {
        if usersCallDictionary[user] != nil {
            let arr = usersCallDictionary[user]!
            return arr
        }
        return []
    }
    
    func call(id: CallID) -> Call? {
        for (index, call) in callArray.enumerated() {
            if id == call.id   {
                callArray.remove(at: index)
                return call
            }
        }
        return nil
    }
    
    func currentCall(user: User) -> Call? {
        for (index, call) in callArray.enumerated() {
            if call.status == CallStatus.ended(reason: .end) ||
                call.status == CallStatus.ended(reason: .error) {
                callArray.remove(at: index)
                break
            }
            
            if call.status == CallStatus.ended(reason: .cancel)   {
                callArray.remove(at: index)
                break
            }
            
            if call.outgoingUser == user || call.incomingUser == user {
                return call
            }
        }
        return nil
    }

}
