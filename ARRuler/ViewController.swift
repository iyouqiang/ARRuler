//
//  ViewController.swift
//  ARRuler
//
//  Created by Yochi·Kung on 2017/10/10.
//  Copyright © 2017年 Yochi·Kung. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var targetImageView: UIImageView!
    
    var session = ARSession()
    var configuration = ARWorldTrackingConfiguration()
    var isMeasuring = false

    // 3d 场景
    var vectorZero  = SCNVector3()
    var vectorStart = SCNVector3()
    var vectorEnd   = SCNVector3()
    var lines = [RulerLine]()
    var unit  = LengthUnit.cenitMeter
    var currentLine: RulerLine?
    var typeCount = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        
        sceneView.session = session
        sceneView.delegate = self
        InfoLabel.text = "初始化环境"
    }

    func scnWorld() {

        // 拿到画面中心点的位置
        guard let worldPosition = sceneView.worldVector(for: view.center) else {
            return
        }

        if lines.isEmpty {
            InfoLabel.text = "点击屏幕开始测量"
        }

        // 如果现在是测量状态
        if (isMeasuring) {

            // 设置开始节点
            if (vectorStart == vectorZero) {

                vectorStart = worldPosition
                currentLine = RulerLine(scnneView: sceneView, startVector: vectorStart, unit: unit)
            }

            // 设置接受节点
            vectorEnd = worldPosition
            currentLine?.updateLine(to: vectorEnd)
            InfoLabel.text = currentLine?.distanceStr(to: vectorEnd) ?? "..."
        }
    }
    
    @IBAction func resetAction(_ sender: Any) {

        for line in lines {
            line.remove()
        }

        lines.removeAll()
    }

    @IBAction func unitAction(_ sender: Any) {

        // 更改单位

        switch typeCount {
        case 0:
            unit  = LengthUnit.cenitMeter
        case 1:
            unit  = LengthUnit.meter
        case 2:
            unit  = LengthUnit.inch
        default:
            typeCount = 0
        }

        typeCount += 1

        if typeCount > 2 {

            typeCount = 0;
        }
    }

    func reset(){

        vectorStart = SCNVector3()
        vectorEnd = SCNVector3()
    }

    // 点击屏幕开始测量
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if !isMeasuring {

            reset()
            isMeasuring = true
            targetImageView.image = UIImage(named: "GreenTarget")
        }else {

            isMeasuring = false
            if let line = currentLine {
                lines.append(line)
                currentLine = nil;
                targetImageView.image = UIImage(named: "WhiteTarget")
            }
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

extension ViewController: ARSCNViewDelegate {

    // 开始渲染界面
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        DispatchQueue.main.async {

            self.scnWorld()
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        
        InfoLabel.text = "错误"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
     
        InfoLabel.text = "中断"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {

        InfoLabel.text = "结束"
    }
}
