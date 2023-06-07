//
//  MainListViewModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 07.06.2023.
//

import Foundation

struct NavigationItem {
    var name: String
    var link: (()->())?
}

class MainListViewModel {
    var mainListDataSource: [NavigationItem] = []
}
