//
//  Tabbar.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 08/09/23.
//

import SwiftUI

struct Tabbar: View {
    @State var selectedIndex = 0
    
    func renderTab(_ unselectedName: String ,  
                   _ selectedName : String ,
                   isSelected : Bool , onSelectTab : @escaping () -> Void) -> some View {
        Group{
            if isSelected {
                return Image(systemName: selectedName)
                    .font(.regular30)
            } else {
                return Image(systemName: unselectedName)
                    .font(.regular30)
            }
        }
        .onTapGesture {
            onSelectTab()
        }
    }

    func navigateToHome() {
        self.selectedIndex = 0;
    }

    var icons = [
        (Icons.house, Icons.houseFill, 0 ),
        (Icons.magnifyingGlassCircle, Icons.magnifyingGlassCircleFill, 1 ),
        (Icons.plusCircle, Icons.plusCircleFill, 2 ),
        (Icons.personCropCircle, Icons.personCropCircleFill, 3 )
    ]
    
    var body: some View {
        VStack {
            if selectedIndex == 0 {
                HomeScreen()
            } else if selectedIndex == 1 {
                SearchScreen()
            } else if selectedIndex == 2 {
                UploadScreen(navigateToHome: navigateToHome)
            } else if selectedIndex == 3 {
                ProfileScreen()
            }
            Spacer()
            HStack{
                Spacer()
                ForEach(icons, id: \.self.2) { icons  in
                    renderTab(icons.0, icons.1, isSelected: selectedIndex == icons.2) {
                        selectedIndex = icons.2
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Tabbar()
}
