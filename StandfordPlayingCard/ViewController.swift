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
    
    lazy var animator = UIDynamicAnimator(referenceView: self.view)
    
    lazy var cardBehavior = CardBehavoir(in: self.animator)
    
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
            
            self.cardBehavior.addItem(cardView)
            
        }
        
    }
    
    private var faceUpCardViews: [PlayingCardView]{
        return cardViews.filter {$0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1}
    }
    
    private var faceUpCardViewsMatch: Bool{
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer : UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            if let chooseCardView = recognizer.view as? PlayingCardView,faceUpCardViews.count <  2{
                lastChosenCardView = chooseCardView
                self.cardBehavior.removeItem(chooseCardView)
                UIView.transition(
                    with: chooseCardView,
                    duration:  0.5,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        chooseCardView.isFaceUp = !chooseCardView.isFaceUp
                },
                    completion:{ finished in
                        if self.faceUpCardViewsMatch {
                            let cardsToAnimate: [PlayingCardView] = self.faceUpCardViews
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach { (cardView) in
                                        cardView.transform = CGAffineTransform.identity.scaledBy(x: 3.0 , y: 3.0)
                                    }
                            }) { (position) in
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.75 ,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        cardsToAnimate.forEach {
                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.3 , y: 0.3)
                                            $0.alpha = 0
                                        }
                                },
                                    completion: { position in
                                        cardsToAnimate.forEach {
                                            $0.isHidden = true
                                            $0.alpha = 1
                                            $0.transform = .identity
                                        }
                                }
                                )
                            }
                            
                        }
                        else if self.faceUpCardViews.count == 2 {
                            if chooseCardView == self.lastChosenCardView{
                                self.faceUpCardViews.forEach {
                                    cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration:  0.5,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                            cardView.isFaceUp = !cardView.isFaceUp
                                    },
                                        completion: { finished in
                                            self.cardBehavior.addItem(cardView)
                                    })
                                }
                            }
                        }else{
                            if !chooseCardView.isFaceUp{
                                self.cardBehavior.addItem(chooseCardView)
                            }
                        }
                })
            }
        default:
            break
        }
    }
    
}



