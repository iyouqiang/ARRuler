//
//  RulerLine.swift
//  ARRuler
//
//  Created by Yochi·Kung on 2017/10/11.
//  Copyright © 2017年 Yochi·Kung. All rights reserved.
//

import ARKit

enum LengthUnit {

    case meter, cenitMeter, inch

    var factor: Float {

        switch self {
        case .meter:
            return 1.0
        case.cenitMeter:
            return 100.0
        case.inch:
            return 39.3700787
        }
    }

    var name: String {

        switch self {
        case .meter:
            return "m"
        case.cenitMeter:
            return "cm"
        case.inch:
            return "inch"
        }
    }
}

class RulerLine {

    // 场景内容 起始点 文字 颜色 线条 创建对应的节点

    var startNode: SCNNode
    var endNode: SCNNode
    var textNode: SCNNode
    // 线节点不在初始化中创建，可以为空
    var lineNode: SCNNode?
    var textScn: SCNText

    var lineColor = UIColor.orange

    let scnneView: ARSCNView
    let startVector:SCNVector3
    let unit: LengthUnit

    init(scnneView: ARSCNView, startVector: SCNVector3, unit: LengthUnit) {

        // 场景创建
        self.scnneView   = scnneView
        self.startVector = startVector
        self.unit = unit

        // 创建点
        let dot = SCNSphere(radius: 0.5)
        dot.firstMaterial?.diffuse.contents = lineColor
        // 光效模式，不产生阴影
        dot.firstMaterial?.lightingModel = .constant
        // 两边一样亮
        dot.firstMaterial?.isDoubleSided = true

        startNode = SCNNode(geometry: dot)
        startNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        startNode.position = startVector
        scnneView.scene.rootNode.addChildNode(startNode)

        endNode = SCNNode(geometry: dot)
        endNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)

        // 创建文本 extrusionDepth 挤压效果 缩小 0.1
        textScn = SCNText(string: "", extrusionDepth: 0.1)
        textScn.font = .systemFont(ofSize: 5)
        textScn.firstMaterial?.diffuse.contents = lineColor
        textScn.firstMaterial?.lightingModel = .constant
        textScn.firstMaterial?.isDoubleSided = true
        textScn.truncationMode = kCATruncationMiddle

        // 包装文字节点
        let wrapperTextNode = SCNNode(geometry: textScn)
        wrapperTextNode.eulerAngles = SCNVector3Make(0, .pi, 0)
        wrapperTextNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)

        textNode = SCNNode()
        textNode.addChildNode(wrapperTextNode)

        // 让文字对着我们
        // SCNLookAtConstraint 让他跟随我们设定的目标

        let constraint = SCNLookAtConstraint(target: scnneView.pointOfView)

        // 开启万向节锁， 方向不受接受方影响
        constraint.isGimbalLockEnabled = true

        textNode.constraints = [constraint]

        scnneView.scene.rootNode.addChildNode(textNode)
    }

    // 更新内容
    func updateLine(to vector: SCNVector3) {

        // 移除有所线条
        lineNode?.removeFromParentNode()

        // 添加起始线条节点
        lineNode = startVector.line(to: vector, color: lineColor)
        scnneView.scene.rootNode.addChildNode(lineNode!)

        // 更新文字节点
        textScn.string = distanceStr(to: vector)

        // 文字放在线条中间
        textNode.position = SCNVector3((startVector.x + vector.x) / 2.0 , (startVector.y + vector.y) / 2.0 ,(startVector.z + vector.z) / 2.0 )

        // 更新结束节点
        endNode.position = vector;

        // 添加尾部节点
        if (endNode.parent == nil) {

            scnneView.scene.rootNode.addChildNode(endNode)
        }
    }

    // 获取距离
    func distanceStr(to vector: SCNVector3) -> String {

        // \(abc)
        return String(format: "%0.2f %@", startVector.distance(form: vector)*unit.factor, unit.name)
    }

    // 场景内容移除
    func remove(){
        startNode.removeFromParentNode()
        endNode.removeFromParentNode()
        textNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
    }
}

























