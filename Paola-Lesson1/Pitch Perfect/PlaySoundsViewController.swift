//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paola Di Marcello on 05/04/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController{
 
    var audioPlayer:AVAudioPlayer!
    var recordedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // set the file to the previuosly recorded audio
        audioEngine=AVAudioEngine()
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate=true;
        audioFile=AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
    }

    // Stop playing the Audio
    @IBAction func stopAudio(sender: UIButton) {
         audioPlayer.stop()
        audioEngine.stop()
    }
    // Let play the sound slow
    @IBAction func playSlow(sender: UIButton) {
       playAtDifferentRate(0.5)
    }
    
    // Let play the sound fast
    @IBAction func playFast(sender: UIButton) {
        playAtDifferentRate(2)
    }
    
    // Let play the sound like a Chipmunk
    @IBAction func playChipmunk(sender: UIButton) {
        playPitch(1000)
    }

    @IBAction func playDarthVader(sender: UIButton) {
        playPitch(-1000)
    }
    
    
    // function to play the sound at a specific speed
    func playAtDifferentRate (rate: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    // function to play with different effects
    func playPitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var pitchPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(pitchPlayer)
        
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        pitchPlayer.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}
