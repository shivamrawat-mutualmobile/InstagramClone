//
//  InstagramLogo.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import SwiftUI

struct InstagramLogo: View {
    var body: some View {
        Image(Images.logoInstagram)
            .resizable()
            .scaledToFit()
            .frame(height: 50)
    }
}

#Preview {
    InstagramLogo()
}
