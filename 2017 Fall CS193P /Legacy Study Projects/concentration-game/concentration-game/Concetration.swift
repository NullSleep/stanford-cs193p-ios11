//
//  Concetration.swift
//  concentration-game
//
//  Created by Carlos Arenas on 8/23/18.
//  Copyright © 2018 Polygon. All rights reserved.
//

import Foundation

// struct Concentration {
struct Concentration {
    // MARK: - Application Program Interface
    
    // var cards = Array<Card>()
    private(set) var cards = [Card]()
    
    // This index is used to know if there is a card face up and proceede to try to match the currently selected card
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        
        // We can name it anything we want, otherwise it defaults to newValue: set (newIndex){
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        // Checks if cards has the index passed.
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        
        // Ignoring all the cards that have been matched
        if !cards[index].isMatched {
            // The indexOfOneAndOnlyFaceUpCard has to exist and we ignore if the user selected again the same card
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // Check if cards match. Since Card implement Equatable we can compare both of them.
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least a pair of cards")
        
        for _ in 0..<numberOfPairsOfCards {
            // The concetration game doesn't care about what the identifiers are. It only care it they are unique.
            // The card itself should figure it's identifier.
            let card = Card()
            cards += [card, card]
        }
        
        // Shuffling the card array
        shuffleTheCardArray()
    }
    
    // MARK: - Private mehtods
    mutating private func shuffleTheCardArray(){
        var res = [Card]()
        for _ in 0..<cards.count {
            let rand = Int(arc4random_uniform(UInt32(cards.count)))
            res.append(cards[rand])
            cards.remove(at: rand)
        }
        cards = res
    }
}

// Collection is a generic type (array, dictionary, string) . Already has Element, a function count and a function first.
extension Collection {
    
    // Returns the one and only thing in that collection or it will return nil.
    var oneAndOnly: Element? {
        // count and first are collection methods that already exist.
        return count == 1 ? first : nil
    }
}
