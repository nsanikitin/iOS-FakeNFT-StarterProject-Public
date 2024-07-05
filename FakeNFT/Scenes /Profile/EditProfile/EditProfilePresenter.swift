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
    private let profileService = ProfileService.shared
    
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
            let description = description, !description.isEmpty,
            let website = website, !website.contains(" "),
            let profile = profile
        else { return }
        
        let updatedProfile = ProfileUpdate(
            name: name,
            description: description,
            website: website,
            likes: profile.likes
        )
        ProfileService.shared.updateProfile(with: updatedProfile) { [weak self] result in
            switch result {
            case .success(let updatedProfileModel):
                self?.view?.closeView(with: updatedProfileModel)
            case .failure(let error):
                print("Failed to update profile: \(error)")
            }
        }
        
    }
    
    func updateAvatarURL(_ newURL: String) {
        // TODO: логика изменения ссылки для изображения
    }
}
