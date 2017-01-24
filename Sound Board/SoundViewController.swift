//
//  SoundViewController.swift
//  Sound Board
//
//  Created by ziad adra on 1/23/17.
//  Copyright © 2017 ziad adra. All rights reserved.
//

import UIKit
import AVFoundation


class SoundViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
  
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    //make audiourl a property
    var audioURL : URL?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
        
        
    }
    
    func setupRecorder() {
        do {
            //create an audio sesison
            let session = AVAudioSession.sharedInstance()
            
            try  session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try   session.setActive(true)
            // create url for the audio file (sandbox)
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            
            let pathComponents = [basePath,"Audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
         //   print("############")
           // print(audioUrl!)
            
            
            // create settings for the audio recoder
            
            var settings : [String:AnyObject] = [:]
            
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //create audiorecorder object
            
             audioRecorder = try AVAudioRecorder(url: audioURL!, settings:  settings )
            audioRecorder!.prepareToRecord()
            // ! that we know that it exist
        } catch let error as NSError {
            print (error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            //stop the recording
            audioRecorder?.stop()
            
            //change the  buttom title to record
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        } else {
            //start the recording
            audioRecorder?.record()
            
            
            //change the buttom title to stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
        //1 - setup the audio player
        try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch {}
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text
        
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
        
        
    }
    
}
