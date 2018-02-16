//
//  BlocFabric.swift
//  ARMario
//
//  Created by Vyacheslav Khorkov on 17/02/2018.
//  Copyright © 2018 Roman Sentsov. All rights reserved.
//

import Foundation

class BlockFabric {
    static var bloc: Bloc? {
        return Bloc(named: "art.scnassets/bloc.scn")
    }
}
