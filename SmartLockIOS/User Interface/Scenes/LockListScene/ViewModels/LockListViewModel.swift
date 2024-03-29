//
//  LockListViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 29.08.2023.
//

import Foundation

protocol LockListViewModelDelegate {
    func loadData(_ completion: @escaping ([Lock]) -> Void)
    func getCurrentUser(_ completion: @escaping (User)->Void)
}

class LockListViewModel: LockListViewModelDelegate {
    private var lockRepository: LockRepositoryProtocol
    var dataSource: [Lock] = []
    var currentUser: User?
    
    init() {
        self.lockRepository = RepositoryFactory.lockRepository()
    }
    
    func loadData(_ completion: @escaping ([Lock]) -> Void) {
        Task { [weak self] in
            guard let locks = await self?.lockRepository.getLocks() else { return }
            self?.dataSource = locks
            completion(locks)
        }
    }
    
    func getCurrentUser(_ completion: @escaping (User)->Void) {
      
    }
}
