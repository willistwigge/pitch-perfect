//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Willis Twigge on 5/20/15.
//  Copyright (c) 2015 Willis Twigge. All rights reserved.
//

import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {

    /* UI Objects */
    @IBOutlet weak var playSlowButtonOutlet: UIButton!
    @IBOutlet weak var playFastButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
    /* Variables */
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    /* Called once when controller is first loaded */
    override func viewDidLoad() {
        /* Load view */
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        /* Configure engine */
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    /* Called each time view appears */
    override func viewWillAppear(animated: Bool) {
        
    }
    
    /* Called upon memory warning */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowButtonAction(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFastButtonAction(sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipmunkButtonAction(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderButtonAction(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopButtonAction(sender: UIButton) {
        audioPlayer.stop()
    }
    
    func playAudioWithVariableRate (rate: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
