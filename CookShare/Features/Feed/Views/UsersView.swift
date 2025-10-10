//
//  UsersView.swift
//  CookShare
//
//  Created by Olga Dragon on 09.10.2025.
//

import SwiftUI

struct UsersView: View {
    
    @EnvironmentObject private var social: SocialViewModel
    
    var body: some View {
        NavigationStack {
            List(social.users) { user in
                HStack(spacing: 12) {
                    Image(systemName: user.avatarSystemImage)
                        .imageScale(.large)
                        .frame(width: 32, height: 32)
                    Text(user.name)
                    Spacer()
                    Button(social.isFollowing(user.id) ? "Unfollow" : "Follow") {
                        if social.isFollowing(user.id) {
                            social.unfollow(user.id)
                        } else {
                            social.follow(user.id)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("People")
        }
    }
}

#Preview {
    UsersView().environmentObject(SocialViewModel())
}

