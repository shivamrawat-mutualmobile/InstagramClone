//
//  GlobalStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/09/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

@MainActor class GlobalStore: ObservableObject {
    @Published var state = GlobalState()

    var globalProfileService = GlobalProfileService()
    var globalMessageService = GlobalMessageService()

    @AppStorage("LoginStatus") var loginStatus = ""

    init(state: GlobalState = GlobalState()) {
        self.state = state
        if loginStatus != "" {
            self.state.profileState.email = loginStatus
            self.state.loginStatus = .success
        }
    }

    func dispatch(_ action: GlobalAction) {
        state = self.reducer(self.state, action)
    }

    func reducer (_ state: GlobalState, _ action: GlobalAction) -> GlobalState {
        var mutableState = state
        switch action {

        case .authAction(let authAction):
            switch authAction {
            case .didTapOnLogin(let email,let loginStatus):
                mutableState.profileState.email = email
                mutableState.loginStatus = loginStatus
                self.loginStatus = email
            case .reset:
                mutableState.profileState .email = ""
                mutableState.loginStatus = .initial
                self.loginStatus = ""
            }

        case .profileAction(let profileAction):
            switch profileAction {
            case .getProfile(let email):
                Task {
                    do {
                        let (email, username) = try await globalProfileService.getProfile(email: email)
                        self.dispatch(.profileAction(.setProfile(email, username)))
                    } catch {
                        // TODO: Handle error
                    }
                }
                // MARK: Setter actions
            case .setProfile(let email, let username):
                mutableState.profileState.email = email
                mutableState.profileState.username = username
            }

        case .messageAction(let messageAction):
            switch messageAction {
            case .selectUserMessage(let from , let to):
                Task {
                    do {
                        let selectedMessage = try await globalMessageService.selectMessage(state:self.state, from: from, to: to)
                        self.dispatch(.messageAction(.setMessages(selectedMessage)))
                    } catch {
                        self.dispatch(.messageAction(.setMessages([])))
                    }
                }
            case .addListeners(let owner):
                globalMessageService.addListener(owner: owner, state: state, dispatch: self.dispatch)

            case .resetMessages :
                mutableState.messageState.selectedMessage = []
                globalMessageService.reset()
            case .setMessages(let message):
                mutableState.messageState.selectedMessage = message
            case .setMessagesList(let messageList):
                mutableState.messageState.messageList = messageList
            case .setMessagesListStatus(let messageListStatus):
                mutableState.messageState.messageListStatus = messageListStatus
            }

        }
        return mutableState;
    }
}

