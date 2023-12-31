//
//  MessageScreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/09/23.
//

import SwiftUI

struct MessageScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var globalStore: GlobalStore
    
    var globalMessageStore: GlobalMessageState {
        globalStore.state.messageState
    }
    
    var globalProfileStore : GlobalProfileState {
        globalStore.state.profileState
    }
    
    func toolbar() -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Icons.chevronBackward)
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: Icons.squareAndPencil)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            ScrollView {
                VStack{
                    if globalMessageStore.messageListStatus == .success {
                        ForEach(globalMessageStore.messageList, id: \.ownerName) { message in
                            let messageDetailsScreen = MessageDetailScreen(email: message.ownerEmail,
                                                                           username: message.ownerName)
                            NavigationLink(destination: messageDetailsScreen) {
                                VStack {
                                    UserTab(title: message.ownerName, caption: message.content)
                                    Divider()
                                }
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }.frame(maxWidth: .infinity)
                
            }
            .padding(.top, 20)
        }
        .navigationTitle("Messages")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbar()
        }
        .padding()
    }
}

#Preview {
    MessageScreen()
        .environmentObject(GlobalStore(state: GlobalState(loginStatus: .success,
                                                          profileState: GlobalProfileState(),
                                                          messageState: GlobalMessageState(
                                                            selectedMessage: [],
                                                            messageListStatus: .success, 
                                                            messageList: [
                                                                MessageListDetail(ownerEmail: "SAMPLE",
                                                                                  ownerName: "SAMPLE",
                                                                                  content: "SAMPLE",
                                                                                  message: [])
                                                            ]
                                                          ))))
}
