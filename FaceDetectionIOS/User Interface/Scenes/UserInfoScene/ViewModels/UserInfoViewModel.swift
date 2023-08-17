//
//  UserInfoViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class UserInfoViewModel {
    var userInfoModel: UserInfo?
    private var userRepository: UserRepositoryProtocol
    
    init() {
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    func configure(_ completion: @escaping ((UserInfo)->Void)) {
        Task { [weak self] in
            let userModel = await self?.userRepository.getUser()
            guard let userModel = userModel else { return }
            let userInfoModel = UserInfo(user: userModel)
            self?.userInfoModel = userInfoModel
            completion(userInfoModel)
        }
    }
}
