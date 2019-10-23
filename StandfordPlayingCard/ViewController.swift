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

    @IBOutlet var cardViews: [PlayingCardView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2){
            let card = deck.draw()!
            cards += [card,card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank=card.rank.order
            cardView.suit=card.suit.rawValue
            
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }

    }
    
    var faceUpCardViews: [PlayingCardView]{
        return cardViews.filter {$0.isFaceUp && !$0.isHidden}
    }
    
    @objc func flipCard(_ recognizer : UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            if let chooseCardView = recognizer.view as? PlayingCardView{
                UIView.transition(
                    with: chooseCardView,
                    duration:  0.6,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        chooseCardView.isFaceUp = !chooseCardView.isFaceUp
                },
                    completion:{ finished in
                        if self.faceUpCardViews.count>=2 {
                            self.faceUpCardViews.forEach {
                                cardView in
                                UIView.transition(
                                    with: cardView,
                                    duration:  0.6,
                                    options: [.transitionFlipFromLeft],
                                    animations: {
                                        cardView.isFaceUp = !cardView.isFaceUp
                                })
                            }
                        }
                })
            }
        default:
            break
        }
    }

}
