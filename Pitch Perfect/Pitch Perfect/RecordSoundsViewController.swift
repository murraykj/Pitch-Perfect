//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Murray on 3/5/15.
//  Copyright (c) 2015 Murray. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // outlets
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // global variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // add code to hide stop button
        stopButton.hidden=true;
        recordButton.enabled=true;
        recordingInProgress.hidden = false
        recordingInProgress.text="Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        
      // show stop button when recording & disable record button
      stopButton.hidden=false;
      recordButton.enabled=false;

      // set recording file name and record file
      let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
      
      let currentDateTime = NSDate()
      let formatter = NSDateFormatter()
      formatter.dateFormat = "ddMMyyyy-HHmmss"
      let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
      let pathArray = [dirPath, recordingName]
      let filePath = NSURL.fileURLWithPathComponents(pathArray)
      print(filePath)
      
      // Setup audio session
      let session = AVAudioSession.sharedInstance()
      do {
          try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
      } catch _ {
      }
      
      // Initilaize and prepare the audiorecorder
//        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
    
      var nilSettings: [String: String]
      nilSettings = [:]
    
      do
      {
        audioRecorder = try AVAudioRecorder(URL:filePath!, settings:nilSettings)
      }
      catch let error as NSError
      {
        print(error.description)
      }
    
      audioRecorder.delegate = self           //set delegate to self; ensure main class declaration updated
      audioRecorder.meteringEnabled = true
      audioRecorder.prepareToRecord()
      audioRecorder.record()
      
      
      // Show Text "recording in progress"
      recordingInProgress.hidden = false
      recordingInProgress.text="recording in progress"
      
      //TODO:  Record the user's voice
      print("in recordAudio")

    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            // step 1 - save reorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title:  recorder.url.lastPathComponent!)
        
            // step 2 - move to 2nd scene in app via segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successfull")
            recordButton.enabled = true
            stopButton.hidden = true
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // pass data from one view to another
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as!
                PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func recordstopAudio(sender: UIButton) {
        // show ininstructions to user
        recordingInProgress.hidden = false
        recordingInProgress.text="Tap to Record"
        
        //Stop recording the user's voice
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }

    }
}

