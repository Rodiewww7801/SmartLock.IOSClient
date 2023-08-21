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
    // admin
    func getUsers() async -> [User]
    func getUsersInfo() async -> [UserInfo]
    func getUserPhoto(userId: String, photoId: String) async -> UIImage?
    func getUserPhotosInfo(userId: String) async -> [PhotoInfoDTO]
    func getUserPhotos(userId: String) async -> [Photo]
    //user
    func getUserInfo() async -> UserInfo?
    func getUserPhoto(photoId: String) async -> UIImage?
    func getUserPhotosInfo() async -> [PhotoInfoDTO]
    func getUserPhotos() async -> [Photo]
}
