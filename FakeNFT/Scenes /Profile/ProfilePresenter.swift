//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Anna on 26.06.2024.
//

import UIKit

final class ProfilePresenter {
    private weak var view: ProfileView?
    private var userNFTPresenter: UserNFTPresenter?
    private var profile: ProfileModel = ProfileModel()
    private let profileService = ProfileService.shared
    
    init(view: ProfileView) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadProfile()
        let userNFTView = UserNFTViewController()
        userNFTPresenter = UserNFTPresenter(view: userNFTView)
        userNFTPresenter?.userNftCountDelegate = self
        userNFTPresenter?.viewDidLoad()
    }
    
    func viewWillAppear() {
        loadProfile()
        view?.displayProfile(profile)
    }
    
    private func loadProfile() {
        view?.showLoading()
        profileService.fetchProfile { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.view?.displayProfile(profile)
            case .failure(let error):
                self?.view?.showError(error)
            }
        }
    }
    
    func editProfileTapped() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.delegate = self
        editProfileViewController.configure(profile: profile)
        if let viewController = view as? UIViewController {
            let navigationController = UINavigationController(rootViewController: editProfileViewController)
            viewController.present(navigationController, animated: true)
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

extension ProfilePresenter: UserNFTPresenterDelegate {
    func didUpdateUserNFTCount(_ count: Int) {
        print("didUpdateUserNFTCount called with count: \(count)")
        view?.myNFTsCount = count
        print("myNFTsCount called with count: \(count)")
        view?.reloadTableView()
    }
}
