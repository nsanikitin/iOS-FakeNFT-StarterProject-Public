//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Anna on 26.06.2024.
//

import UIKit

final class ProfilePresenter {
    private weak var view: ProfileView?
    var profile: ProfileModel?
    private let profileService = ProfileService.shared
    
    init(view: ProfileView) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadProfile()
    }
    
    func viewWillAppear() {
        if let profile = profile {
            view?.displayProfile(profile)
        }
    }
    
    private func loadProfile() {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.view?.displayProfile(profile)
            case .failure(let error):
                print("Failed to load profile: \(error)")
            }
        }
    }
    
    func editProfileTapped() {
        if let profile = profile {
            let editProfileViewController = EditProfileViewController()
            editProfileViewController.delegate = self
            editProfileViewController.configure(profile: profile)
            if let viewController = view as? UIViewController {
                let navigationController = UINavigationController(rootViewController: editProfileViewController)
                viewController.present(navigationController, animated: true)
            }
        }
    }
    
    func updateProfile(_ profile: ProfileModel) {
        self.profile = profile
        view?.displayProfile(profile)
        view?.reloadTableView()
    }
}

extension ProfilePresenter: ProfileViewControllerDelegate {
    func didUpdateProfile(_ profile: ProfileModel) {
        updateProfile(profile)
    }
}
