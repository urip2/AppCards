//
//  CardModel.swift
//  Go!!!
//
//  Created by Михаил Коновалов on 20.09.2018.
//

import Foundation

class CardModel {
    
    
    func getCards() -> [Card] {
        
        
        var generatedNumbersArray = [Int]()
        
            
            // Объявить массив для хранения сгенерированных карт
            var generatedCardsArray = [Card]()
            
            // Произвольное создание пар карт
            while generatedNumbersArray.count < 8 {
                
                let randomNumber = arc4random_uniform(13) + 1
                
                if generatedNumbersArray.contains(Int(randomNumber)) == false {
                    // Log the number
                    print(randomNumber)
                    
                    generatedNumbersArray.append(Int(randomNumber))
                    
                    let cardOne = Card()
                    cardOne.imageName = "card\(randomNumber)"
                    generatedCardsArray.append(cardOne)
                    //print(cardOne.imageName)
                    let cardTwo = Card()
                    cardTwo.imageName = "card\(randomNumber)"
                    generatedCardsArray.append(cardTwo)
                }
            }
            // Перемешать массив
        for i in 0...generatedCardsArray.count - 1{
        let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
        
        let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
            // Вернуть массив
        return generatedCardsArray
        
    }
}
