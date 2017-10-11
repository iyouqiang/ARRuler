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
    
    @IBAction func resetAction(_ sender: Any) {
        print("重置")
    }
    @IBAction func unitAction(_ sender: Any) {
        print("工具类")
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

extension ViewController: ARSCNViewDelegate {
    
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
