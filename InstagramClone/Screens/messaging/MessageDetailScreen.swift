//
//  MessageScreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 08/09/23.
//

import SwiftUI

struct MessageDetailScreen: View {
    var email: String
    var username: String
    
    @State var sendText = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var messageStore: MessageStore
    @EnvironmentObject var profileStore: ProfileStore
    
    func header() -> some View {
        HStack {
            Rectangle()
                .fill(.white)
                .frame(width: 40, height: 40)
                .zIndex(1)
                .overlay {
                    Image(systemName: "chevron.backward")
                }
                .onTapGesture {
                    dismiss()
                }
            
            AsyncImage(url: URL(string: Constant.getImageUrl(title: email)))
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(email)
                Text(username)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "phone")
            Image(systemName: "video")
        }
        .padding()
    }
    
    var body: some View {
        VStack {
            header()
            
            ScrollView{
                VStack {
                    ForEach(messageStore.state.selectedMessage.enumerated().reversed(),
                            id : \.offset) { index, message in
                        Text(message.content)
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(message.isOwner ? .blue : .gray)
                            }
                            .rotationEffect(.degrees(180))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                            .frame(maxWidth: .infinity,alignment: message.isOwner ? .trailing : .leading)
                    }
                }
                .padding()
            }
            .rotationEffect(.degrees(180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
            HStack {
                Image(systemName: "camera.fill")
                TextField("Hello",text:  $sendText)
                Spacer()
                if sendText == "" {
                    Image(systemName: "mic")
                    Image(systemName: "photo")
                } else {
                    Button {
                        let sendAction = MessageAction.send((email,username),
                                                            (profileStore.state.email,profileStore.state.username),
                                                            sendText)
                        messageStore.dispatch(sendAction)
                        sendText = ""
                    } label : {
                        Image(systemName: "paperplane.fill")
                    }
                    
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            messageStore.dispatch(.select((email,username),(profileStore.state.email,profileStore.state.username)))
        })
    }
}

#Preview {
    MessageDetailScreen(email:"A@a.com", username: "A_a")
        .environmentObject(AuthStore(state: AuthState(username: "temp_temp",
                                                      email: "temp@temp.com", password: "temp",
                                                      loginAuthStatus: .success("A@a.com"),
                                                      signupAuthStatus: .success("B@b.com"))))
        .environmentObject(ProfileStore(state: ProfileState(email: "shivam@shivam.com",
                                                            username: "username")))
        .environmentObject(MessageStore())
}
