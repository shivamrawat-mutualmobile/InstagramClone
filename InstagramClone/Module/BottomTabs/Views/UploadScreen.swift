//
//  Uploadscreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI
import PhotosUI

struct UploadScreen: View {
    @State var imagePicked: PhotosPickerItem?
    @State var title = ""

    var body: some View {
        Button {
            print("wok")
        } label : {
            Text("Hi ")
        }
        Text("Upload Screen")
        PhotosPicker(selection: $imagePicked) {
            Text("Upload Photo")
        }
        .onChange(of: imagePicked) {
           //  imagePicked?.loadTransferable(type: ProfileImage)
        }
        TextField("Enter the title", text: $title)
    }
}

#Preview {
    UploadScreen()
}