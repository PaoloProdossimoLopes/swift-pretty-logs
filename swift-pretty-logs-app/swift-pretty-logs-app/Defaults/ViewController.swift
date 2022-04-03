//
//  ViewController.swift
//  swift-pretty-logs-app
//
//  Created by Paolo Prodossimo Lopes on 03/04/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        LOG.DEBUG(.WARNING("Pode ter erro aqui ..."))
        LOG.DEBUG(.WARNING("Pode ter erro aqui ..."), option: .complete, structure: .STATUS_INFO_V1)
    }


}

