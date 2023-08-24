//
//  UserHistoryViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

class UserHistoryViewModel {
    private var lockRepository: LockRepositoryProtocol
    var lockId: String
    var currentUser: User?
    var dataSource: [LockHistory] = []
    
    init(lockId: String) {
        self.lockId = lockId
        self.lockRepository = RepositoryFactory.lockRepository()
    }
    
    func loadData(_ completion: @escaping ([LockHistory])->Void) {
        self.getUserHistories(completion)
    }
    
    func getUserHistories(_ completion: @escaping ([LockHistory]) -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            let lockHistories = await self.lockRepository.getLockHistories(lockId: self.lockId)
            self.dataSource = lockHistories
            completion(lockHistories)
        }
    }
}
