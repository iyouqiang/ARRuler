//
//  ARSCNView+Extension.swift
//  ARRuler
//
//  Created by Yochi·Kung on 2017/10/10.
//  Copyright © 2017年 Yochi·Kung. All rights reserved.
//

import ARKit

extension ARSCNView {
    
    func worldVector(for position: CGPoint) -> SCNVector3? {
     
        let results  = self.hitTest(position, types: [.featurePoint])
        guard let result = results.first else {
            
            return nil
        }
    }
}
