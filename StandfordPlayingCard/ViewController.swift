//
//  ViewController.swift
//  StandfordPlayingCard
//
//  Created by leaco on 2019/10/20.
//  Copyright © 2019 Leaco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }

        }

    }

}
