//
//  LockListViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

class AdminLockListViewModel: LockListViewModelDelegate {
    private var lockRepository: LockRepositoryProtocol
    private var userRepository: UserRepositoryProtocol
    var dataSource: [Lock] = []
    var currentUser: User?
    
    init() {
        self.lockRepository = RepositoryFactory.lockRepository()
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    func loadData(_ completion: @escaping ([Lock]) -> Void) {
        Task { [weak self] in
            guard let locks = await self?.lockRepository.getLocks() else { return }
            self?.dataSource = locks
            completion(locks)
        }
    }
    
    func getCurrentUser(_ completion: @escaping (User)->Void) {
        Task { [weak self] in
            guard let user = await self?.userRepository.getUser() else { return }
            self?.currentUser = user
            completion(user)
        }
    }
}
