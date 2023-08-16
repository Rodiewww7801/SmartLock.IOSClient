//
//  UserInfoModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

struct UserInfoModel {
    var user: User
    var photo: UIImage?
    
    init(user: User, photo: UIImage? = nil) {
        self.user = user
        self.photo = photo
    }
}
