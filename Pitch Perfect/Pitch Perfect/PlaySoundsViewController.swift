//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Murray on 3/15/15.
//  Copyright (c) 2015 Murray. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    //Set global variables
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate=true
        
        // Create object of AVAudioEngine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playslowSound(sender: UIButton) {
        // stop all audio  playback
        stopAllAudio()
        
        //Play audio slowly here
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0  // start at beginning
        audioPlayer.play()
    }

    @IBAction func playFast(sender: UIButton) {
        // stop all audio playback
        stopAllAudio()
        
        //Play audio fast here
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0  // start at beginning
        audioPlayer.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        //stop audio playback here
        stopAllAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        // call common function to play chipmunk sound - pass high value
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // call common function to play darth vader sound - pass low value
        playAudioWithVariablePitch(-1000)
    }
    
    // new function to adjust pitch, pitch based on value passed in
    func playAudioWithVariablePitch(pitch: Float){
        
        // stop all audio playback
        stopAllAudio()
        
        // Create instance of AVAudioPlayerNode; this is connected to mp3 player and will play sound
        var audioPlayerNode = AVAudioPlayerNode()
        
        // Attach AVAudioPlayerNode to AVAudioEngine
        audioEngine.attachNode(audioPlayerNode)
        
        // Create AVAudioUnitTimePitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        // Attach AVAudioUnitTimePitch to AVAudioEngine
        audioEngine.attachNode(changePitchEffect)
        
        // Connect AVAudioPlayerNode  and AVAudioUnitTimePitch
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Attach AVAudioUnitTimePitch to some type of output like the speakers
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Play audio
        audioPlayerNode.play()
    }
    
    // new common function to stop all audio payback (both audio play and engine)
    func stopAllAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
