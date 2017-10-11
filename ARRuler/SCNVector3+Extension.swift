//
//  SCNVector3+Extension.swift
//  ARRuler
//
//  Created by Yochi·Kung on 2017/10/11.
//  Copyright © 2017年 Yochi·Kung. All rights reserved.
//

import ARKit

extension SCNVector3 {

    //拿到镜头坐标
    static func positionTransform(_ transform: matrix_float4x4) -> SCNVector3 {

        // http://blog.csdn.net/binbingg/article/details/8592048
        // 3D数学4D齐次空间 通过四维矩阵乘积实现平移
        // 3x3变换矩阵表示的是线性变换，不包括平移。因为矩阵乘法的性质，零向量总是变换成零向量。因此，任何能用矩阵乘法表达的变换都不包含平移。这很不幸，因为矩阵乘法和它的逆是一种非常方便的工具，不仅可以用来将复杂的变换组合成简单的单一变换，还可以操纵嵌入式坐标系间的关系。如果能找到一种方法将3x3变换矩阵进行扩展，使它能处理平移，这将是一件多么美妙的事情啊。4x4矩阵恰好提供了一种数学上的"技巧"，使我们能够做到这一点。

        //print(transform)
        //simd_float4x4([

        //[1.0, 0.0, 0.0, 0.0)],
        //[0.0, 1.0, 0.0, 0.0)],
        //[0.0, 0.0, 1.0, 0.0)],
        //[-0.0208982, -0.24135, -0.0483114, 1.0)]

        //])

        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }

    // 计算距离
    func distance(form vector: SCNVector3) -> Float {

        // 三维坐标计算公式
        // A(x1,y1,z1),B(x2,y2,z2),则A,B之间的距离为
        // d=√[(x1-x2)^2+(y1-y2)^2+(z1-z2)^2]

        let dx = self.x - vector.x
        let dy = self.y - vector.y
        let dz = self.z - vector.z

        return sqrt(dx*dx + dy*dy + dz*dz)
    }

    // 画线
    func line(to vector: SCNVector3, color: UIColor) -> SCNNode {

        // 指数 0 . 1 _ 维度
        let indices:[UInt32] = [0, 1]

        // 创建容器
        let source = SCNGeometrySource(vertices: [self, vector])

        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        let geomtry = SCNGeometry(sources: [source], elements: [element])

        // 颜色渲染
        geomtry.firstMaterial?.diffuse.contents = color

        let lineNode = SCNNode(geometry: geomtry)

        return lineNode
    }
}

extension SCNVector3: Equatable {
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {

        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}

