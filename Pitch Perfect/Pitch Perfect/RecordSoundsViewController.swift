//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Genuis on 08/09/2019.
//  Copyright © 2019 Abdullah ALAmri. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    

    @IBOutlet weak var recordingLabel: UILabel!
    
  
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
         setRecordingState(false)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }
    func setRecordingState(_ isRecording: Bool) {
        stopRecordingButton.isEnabled = isRecording // to disable the button
        recordButton.isEnabled = !isRecording // to enable the button
        recordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
    }
    @IBAction func recordAudio(_ sender: Any) {
        
       setRecordingState(true)

        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        setRecordingState(false)

        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
        
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        
        } else {
         
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
            
        }
        
      
    }
    
}

