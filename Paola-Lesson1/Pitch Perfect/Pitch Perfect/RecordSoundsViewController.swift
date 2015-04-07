//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paola Di Marcello on 05/04/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate  {

 
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.hidden = true
        recordLabel.text = "Tap to record"
    }

    override func viewDidAppear(animated: Bool) {
        stopButton.hidden=true
        recordButton.enabled=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        // change the label
        recordLabel.text = "Tap to record"
        //enable user to play record again
        recordButton.enabled=true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    @IBAction func recordAudio1(sender: UIButton) {
        // change label text
        recordLabel.text = "recording"
        // show stop Button
        stopButton.hidden=false
        // disable record button
        recordButton.enabled=false
        
        let pathDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as String
        // give a name and a path to the recorded audio
        var currentDateTime=NSDate();
        var formatter =  NSDateFormatter();
        formatter.dateFormat =  "ddMMyyyy-HHmmss";
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [pathDir, recordingName]
        let Pathfile = NSURL.fileURLWithPathComponents(pathArray)
        println(Pathfile)
        
        var session=AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord,error:nil)
        audioRecorder = AVAudioRecorder(URL: Pathfile, settings:nil, error:nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled=true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
          let recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
          self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("recording not successful")
            recordButton.enabled=true
            stopButton.hidden=true
        }
    }
    
    //# MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recordedAudio=data
        }
    }
}

