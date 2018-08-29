//
//  ViewController.swift
//  concentration-game
//
//  Created by Carlos Arenas on 8/12/18.
//  Copyright © 2018 Polygon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Instance variables
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    var flipCount = 0 {
        // Property observers. The code is observing change like this. Property observer should be used a
        // lot to update change from the UI.
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    // Swift can't infer the type that comes fom a UI file
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    var emojiChoices = ["🛠", "🚄", "🚉", "✈️", "🛫", "🏎", "⛴", "🛥", "🛩"]
    
    // MAK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            print("cardNumber = \(cardNumber)")
            // flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not on cardButtons")
        }
    }
    
    // MNARK: - Private mehtods
    
    func updateViewFromModel() {
        // cardButtons is a sequence of buttons so we can loop through it.
        // for button in cardButtons {
        
        // Countable range
        // for index in 0..<cardButtons.count {
        
        // Countable range of all the indexes
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: Card), for: UIControlState.normal)
                button.backgroundColor = UIColor.hexStringToUIColor(hex: "e23e57")
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.8862745098, green: 0.2431372549, blue: 0.3411764706, alpha: 1)
            }
        }
    }
    
    func flipCard(withEmoji emoji: String, on button: UIButton) {
        print("flipcard(withEmoji: \(emoji)")
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.2431372549, blue: 0.3411764706, alpha: 1)
        } else {
            button.setTitle(emoji, for: UIControlState.normal)
            button.backgroundColor = UIColor.hexStringToUIColor(hex: "e23e57")
        }
    }
    
    func
}
