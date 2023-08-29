//
//  UserRepositoryProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

protocol UserRepositoryProtocol {
    func getUser() async -> User?
    func getUser(id: String) async -> User?
    func getUser(images: [UIImage]) async -> User?
    func getUser(lockId: String, images: [UIImage]) async -> User?
    func getUsers() async -> [User]
    func getUserPhoto(userId: String, photoId: String) async -> UIImage?
    func getUserPhoto(photoId: String) async -> UIImage?
    func getUserPhotos(userId: String) async -> [Photo]
    func getUserPhotos() async -> [Photo]
}
