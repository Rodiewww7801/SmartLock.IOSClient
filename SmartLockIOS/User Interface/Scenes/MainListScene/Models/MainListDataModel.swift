//
//  MainListDataModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

struct MainListSectionData {
    var section: String
    var data: [MainListData]
}

struct MainListData {
    var name: String
    var link: (()->())?
}
