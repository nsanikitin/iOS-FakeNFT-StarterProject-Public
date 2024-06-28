//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Anna on 26.06.2024.
//

import UIKit

final class EditProfilePresenter {
    private weak var view: EditProfileView?
    private var profile: ProfileModel?
    
    init(view: EditProfileView, profile: ProfileModel) {
        self.view = view
        self.profile = profile
    }
    
    func viewDidLoad() {
        if let profile = profile {
            view?.displayProfile(profile)
        }
    }
    
    func saveProfile(name: String?, description: String?, website: String?) {
        guard 
            let name = name, !name.isEmpty,
            let website = website, !website.contains(" "),
            let profile = profile
        else { return }
        
        let updatedProfile = ProfileModel(
            name: name,
            avatar: profile.avatar,
            description: description,
            website: website,
            nfts: profile.nfts,
            likes: profile.likes,
            id: profile.id
        )
        
        self.profile = updatedProfile
        view?.closeView(with: updatedProfile)
    }
    
    func updateAvatarURL(_ newURL: String) {
        // TODO: логика изменения ссылки для изображения
    }
}
