//
//  LockHistoryViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

class LockHistoryViewModel {
    private var lockRepository: LockRepositoryProtocol
    var userId: String
    var dataSource: [LockHistory] = []
    
    init(userId: String) {
        self.userId = userId
        self.lockRepository = RepositoryFactory.lockRepository()
    }
    
    func loadData(_ completion: @escaping ([LockHistory])->Void) {
        self.getLockHistories(completion)
    }
    
    func getLockHistories(_ completion: @escaping ([LockHistory]) -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            let userHistories = await self.lockRepository.getLockHistories(userId: self.userId)
            self.dataSource = userHistories
            completion(userHistories)
        }
    }
}
