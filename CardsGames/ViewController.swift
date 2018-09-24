//
//  ViewController.swift
//  CardsGames
// Go!
//  Created by Михаил Коновалов on 19.09.2018.
//  Copyright © 2018 KM. All rights reserved.
//============================================

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 90 * 1000 //90 seconds
    
    //var soundManager = SoundManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
      cardArray = model.getCards()
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    override func viewDidAppear(_ animated: Bool) {
       // super.viewDidAppear(true)
        SoundManager.playSound(.shuffle)
    }
    @objc func timerElapsed(){
        
        milliseconds -= 1
        
        let seconds = String(format: "%.2f", milliseconds/1000)
        //
        timerLabel.text = "Timer Remaining: \(seconds)"
        //
        if milliseconds <= 0 {
            // Stop the timer
            timer?.invalidate()
            timerLabel.textColor = .red
            
            // Check
            checkGameEnded()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Получить объект CardCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        // Получить карту, которую пытается отобразить просмотр коллекции
        let card = cardArray[indexPath.row]
        // Установите эту карту для ячейки
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Chack
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
        
        cell.flip()
            
            // Play the flips sound
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            //
            if firstFlippedCardIndex == nil{
                firstFlippedCardIndex = indexPath
            }
            else{
                //
                
                // TODO: Perform
                checkForMathes(indexPath)
            }
        }
        else{
            cell.flipBack()
            card.isFlipped = false
        }
    } // End the didSelectItemAt method
    
    // MARK: - Game Logic Method
    
    func checkForMathes(_ secondFlippedCardIndex:IndexPath) {
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName{
            
            // Это совпадение
            
            // play souns match
            SoundManager.playSound(.match)
            // устанавливать статусы карт
            cardOne.isMatched = true
            cardTwo.isMatched = true
            // Удалить карты из сетки
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check
            checkGameEnded()
        }
        else{
            //
            
            //Play sound
            SoundManager.playSound(.nomatch)
            
            //
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            //
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        //
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }

        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        //
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        // Message variable
        var title = ""
        var message = ""
        
        
        // If not
        if isWon == true {
            if milliseconds > 0{
                timer?.invalidate()
            }
            
            title = "Conglatulations!"
            message = "You've won"
            
            }
            else{
            
            if milliseconds > 0{
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        
        
        
        //
        showAlert(title, message)
        
    }
    
    func showAlert(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }


} //End ViewController class

