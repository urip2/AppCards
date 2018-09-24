//
//  SoundManager.swift
//  CardsGames
//
//  Created by Михаил Коновалов on 22.09.2018.
//  Copyright © 2018 KM. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
  static  var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
  static  func playSound(_ effect:SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
        case .flip:
            soundFilename = "cardflip"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"
        
        }
        // Get the path to the sound file
       let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename) in the bundel")
            return
        }
        //Create URL object
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do{
        //Create audio player object
            audioPlayer  = try AVAudioPlayer(contentsOf: soundURL)
         // Play the sound
            audioPlayer?.play()
        }
        catch{
            //
            print("Couldn't create the audio player object for sound file \(soundFilename)")
        }
        
    }
}
