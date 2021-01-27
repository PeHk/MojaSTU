//
//  URLsManager.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension Network {
    enum requestError: Error {
        case accessDenied
        case accessForbidden
        case requestNotWork
    }
}

