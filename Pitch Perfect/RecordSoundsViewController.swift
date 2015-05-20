//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Willis Twigge on 5/6/15.
//  Copyright (c) 2015 Willis Twigge. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    /* UI Objects */
    @IBOutlet weak var recordingLabelOutlet: UILabel!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    /* Variables */
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    /* Called once when controller is first loaded */
    override func viewDidLoad() {
        /* Load view */
        super.viewDidLoad()
    }
    
    /* Called each time view appears */
    override func viewWillAppear(animated: Bool) {
        stopButtonOutlet.hidden = true
        recordButtonOutlet.enabled = true
        
    }

    /* Called upon memory warning */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Called upon record button press */
    @IBAction func recordButtonAction(sender: UIButton) {
        recordingLabelOutlet.hidden = false
        stopButtonOutlet.hidden = false
        recordButtonOutlet.enabled = false
        /* Record */
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    /* Called upon stop button press */
    @IBAction func stopButtonAction(sender: UIButton) {
        recordingLabelOutlet.hidden = true
        /* Stop recording */
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        /* Save audio if succesful */
        if (flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
        
    }
}

