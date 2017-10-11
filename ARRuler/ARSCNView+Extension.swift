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

        // 获取三位坐标
        let results  = self.hitTest(position, types: [.featurePoint])
        guard let result = results.first else {
            
            return nil
        }

        // 拿到相机位置
        return SCNVector3.positionTransform(result.worldTransform)
    }
}
