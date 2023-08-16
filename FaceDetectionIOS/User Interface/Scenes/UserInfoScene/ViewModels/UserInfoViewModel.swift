//
//  UserInfoViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class UserInfoViewModel {
    var userInfoModel: UserInfoModel?
    private var userRepository: UserRepositoryProtocol
    
    init() {
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    func configure(_ completion: @escaping ((UserInfoModel)->Void)) {
        Task {
            let userModel = await self.userRepository.getUser()
            guard let userModel = userModel else { return }
            let userInfoModel = UserInfoModel(user: userModel)
            self.userInfoModel = userInfoModel
            completion(userInfoModel)
        }
    }
}
