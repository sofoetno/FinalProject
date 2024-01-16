//
//  CastumBackgroundLabelForUser.swift
//  FinalProject
//
//  Created by Sofo Machurishvili on 16.01.24.
//

import SwiftUI

struct CastumBackgroundLabelForUser: View {
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(
                    Image("background1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: .infinity)
                        .clipShape(Circle())
                )
        }
        .ignoresSafeArea(.all)
        .offset(y: -450)
    }
}

#Preview {
    CastumBackgroundLabelForUser()
}
