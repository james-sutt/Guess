//
//  GameViewController.swift
//  Guess
//
//  Created by Javy on 2017-05-20.
//  Copyright © 2017 supajavy. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

enum Status {
    case setup
    case getReady
    case readyToBegin
    case readyToContinue
    case display
    case end
}

class GameViewController: UIViewController {

    var words: [String]!
    var flags = [Bool]() // true = done with that word
    var timer: Timer!
    var motionManager: CMMotionManager!
    var status = Status.setup {
        didSet {
            print(status)
        }
    }
    
    var score = 0
    var count = 0
    var prepareTime = 5
    var gameTime = 60
    var index: Int {
        return count % words.count
    }
    
    let green = UIColor.init(red: 180/255.0, green: 232/255.0, blue: 112/255.0, alpha: 1.0)
    let red = UIColor.init(red: 255/255.0, green: 69/255.0, blue: 69/255.0, alpha: 1.0)
    let blue = UIColor.init(red: 56/255.0, green: 189/255.0, blue: 255/255.0, alpha: 1.0)
    let correctSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "mp3")!)
    let incorrectSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "wrong", ofType: "mp3")!)
    var correctSoundPlayer = AVAudioPlayer()
    var incorrectSoundPlayer = AVAudioPlayer()
    let motionUpdateInterval = 0.3
    let timerTolerance = 0.05
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFlags()
        words.shuffle()
        
        // setup gyro
        // assume motion is always available, otherwise call motionManager.isDeviceMotionAvailable()
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = motionUpdateInterval
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { deviceMotion, error in
            guard let deviceMotion = deviceMotion else { return }
            self.motionUpdate(roll: deviceMotion.attitude.roll, pitch: deviceMotion.attitude.pitch)
        }
        
        // setup sounds
        correctSoundPlayer = try! AVAudioPlayer(contentsOf: correctSound as URL)
        incorrectSoundPlayer = try! AVAudioPlayer(contentsOf: incorrectSound as URL)
        correctSoundPlayer.prepareToPlay()
        incorrectSoundPlayer.prepareToPlay()
        
        status = .readyToBegin
    }
    
    func motionUpdate(roll: Double, pitch: Double) {
        if pitch > -0.2 && pitch < 0.2 {
            if roll > 1.2 && roll < 1.9 {
                // Ready
                if status == .readyToBegin {
                    startGame()
                } else if status == .readyToContinue {
                    nextWord()
                }
            } else if roll > 2.35 && roll < 3.14 {
                // Correct
                if status == .display {
                    correct()
                }
            } else if roll > 0 && roll < 0.78 {
                // Pass
                if status == .display {
                    pass()
                }
            }
        }
        
    }

    @IBAction func back() {
        timer?.invalidate()
        dismiss(animated: false, completion: nil)
    }
    
    func setupFlags() {
        for _ in words {
            flags.append(false)
        }
    }
    
    func startGame() {
        status = .getReady
        // start timer, display first word, change status to display
        timerLabel.text = String(gameTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.timeUpdate), userInfo: nil, repeats: true)
        timer.tolerance = timerTolerance
        
        wordLabel.text = "GET READY"
        wordLabel.textColor = UIColor.white
        view.backgroundColor = blue
        timerLabel.text = String(prepareTime)
        timerLabel.textColor = UIColor.white
        timerLabel.isHidden = false
    }
    
    func showFirstWord() {
        status = .display
        wordLabel.text = words[index]
        wordLabel.textColor = UIColor.black
        view.backgroundColor = UIColor.white
        timerLabel.textColor = UIColor.lightGray
        timerLabel.text = String(gameTime)
    }
    
    func nextWord() {
        status = .display
        repeat {
            count += 1;
            print(index)
        } while (flags[index])
        wordLabel.text = words[index]
        wordLabel.textColor = UIColor.black
        view.backgroundColor = UIColor.white
    }
    
    func correct() {
        correctSoundPlayer.play()
        wordLabel.text = "Correct"
        wordLabel.textColor = UIColor.white
        view.backgroundColor = green
        flags[index] = true
        score += 1
        if score == words.count {
            timer.invalidate()
            status = .end
            showResult()
        } else {
            status = .readyToContinue
        }
    }
    
    func pass() {
        incorrectSoundPlayer.play()
        status = .readyToContinue
        wordLabel.text = "Pass"
        wordLabel.textColor = UIColor.white
        view.backgroundColor = red
    }
    

    func timeUpdate() {
        if prepareTime > 0 {
            prepareTime -= 1
            timerLabel.text = String(prepareTime)
            if prepareTime == 0 {
                showFirstWord()
            }
        } else {
            gameTime -= 1
            print(gameTime)
            timerLabel.text = String(gameTime)
            if gameTime == 0 {
                timer.invalidate()
                status = .end
                showResult()
            }
        }
    }
    
    func showResult() {
        let title = score == words.count ? "Congratulations!" : "Time's up 😙"
        let message = "You scored \(score) points."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let quitAction = UIAlertAction(title: "Okay", style: .default) { action in
            self.dismiss(animated: false, completion: nil)
        }
        alert.addAction(quitAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}


