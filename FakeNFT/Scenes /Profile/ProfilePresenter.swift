//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Anna on 26.06.2024.
//

import UIKit

final class ProfilePresenter {
    private weak var view: ProfileView?
    private var profile: ProfileModel?
    
    init(view: ProfileView) {
        self.view = view
        self.profile = MockData.profile
    }
    
    func viewDidLoad() {
        if let profile = profile {
            view?.displayProfile(profile)
        }
    }
    
    func viewWillAppear() {
        if let profile = profile {
            view?.displayProfile(profile)
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
