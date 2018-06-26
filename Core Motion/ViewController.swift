//
//  AppDelegate.swift
//  CoreMotionExample
//
//  Created by Lucas Claude on 3/15/18.
//  Copyright © 2016 Lucas Claude. All rights reserved.
//

import UIKit
import CoreMotion
import MessageUI
import AudioToolbox.AudioServices

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    //hello
    //Hides the status bar
    func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func InfoButton(sender: Any) {
        
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    @IBOutlet weak var MailButton: UIButton!
    @IBAction func BackButton(_ sender: Any) {
        HiddenView.isHidden = true;
        MailButton.isHidden = false;
        self.countdownLabel.text = "READY"
        
    }
    @IBOutlet weak var InfoButton: UIButton!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var Text: UITextField!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var Info: UIView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var HiddenView: UIView!
    //Label for the peak length
    @IBOutlet var peakLengthBox: UILabel!
    
    //Label for the peak length info.
    @IBOutlet var peakLengthInfo: UILabel!
    
    //Label for the path length info
    @IBOutlet var pathLengthInfo: UILabel!
    
    //Label for the countdown. Label text will change each second.
    @IBOutlet var countdownLabel: UILabel!
    
    //Total Path Length for the first ten seconds
    @IBOutlet var totalPathLengthFirstTenSeconds: UILabel!
    
    //Total path length will be displayed at the end of the timer.
    @IBOutlet var totalPathLength: UILabel!
    
    //Creating an instance of motion manager. Only ONE should be created.
    var motionManager: CMMotionManager!
    
    //Variables to store data of accelerometers: previous and current to calculate distance between them.
    
    var currentX:  Double = 0.0
    var currentY:  Double = 0.0
    var currentZ:  Double = 0.0
    var firstX:  Double = 0.0
    var firstY:  Double = 0.0
    var firstZ:  Double = 0.0
    var newX:  Double = 0.0
    var newY:  Double = 0.0
    var newZ:  Double = 0.0
    var first: Int = 1
    var previousX: Double = 0.0
    var previousY: Double = 0.0
    var previousZ: Double = 0.0
    var totalPath: Double = 0.0
    
    var totalPathFirstTenSecondsVal: Double = 0.0
    
    //Variable to store data
    var data: String = " "
    var dataFirst: String = " "
//    var data: String = " "
//    var dataFirst: String = " "
    
    //Variables for the X-Y graph plotting
    
    //First Quadrant Variables
    var highestXFirstQuad: Double = 0.0
    var highestYFirstQuad: Double = 0.0
    var highestZFirstQuad: Double = 0.0
    //Second Quadrant Variables
    var highestXSecondQuad: Double = 0.0
    var highestYSecondQuad: Double = 0.0
    var highestZSecondQuad: Double = 0.0
    //Third Quadrant Variables
    var highestXThirdQuad: Double = 0.0
    var highestYThirdQuad: Double = 0.0
    var highestZThirdQuad: Double = 0.0
    //Fourth Quadrant Variables
    var highestXFourthQuad: Double = 0.0
    var highestYFourthQuad: Double = 0.0
    var highestZFourthQuad: Double = 0.0
    //First Quadrant Variables
    var highestXFifthQuad: Double = 0.0
    var highestYFifthQuad: Double = 0.0
    var highestZFifthQuad: Double = 0.0
    //First Quadrant Variables
    var highestXSixthQuad: Double = 0.0
    var highestYSixthQuad: Double = 0.0
    var highestZSixthQuad: Double = 0.0
    //First Quadrant Variables
    var highestXSeventhQuad: Double = 0.0
    var highestYSeventhQuad: Double = 0.0
    var highestZSeventhQuad: Double = 0.0
    //First Quadrant Variables
    var highestXEigthQuad: Double = 0.0
    var highestYEigthQuad: Double = 0.0
    var highestZEigthQuad: Double = 0.0
    //Variables to store the distance between quadrants.
    var maxLength1: Double = 0.0
    var maxLength2: Double = 0.0
    var maxLength3: Double = 0.0
    var maxLength4: Double = 0.0
    var maxLength5: Double = 0.0
    var maxLength6: Double = 0.0
    var maxLength7: Double = 0.0
    var maxLength8: Double = 0.0
    var yes: Int = 1

    
    //The farthest distance from a point to a point in any other quadrant.
    var finalMaxLength: Double = 0.0
    
    //Variables for the timer
    var seconds = 24
    var wait = 3
    var timer = Timer()
    var counting = true;
    
    
    //View load method
    override func viewDidLoad() {
        super.viewDidLoad()
        MailButton.isHidden = true;
        //Creating instance of Motion Manager
        motionManager = CMMotionManager()
        
        //Setting interval for data update to 0.2 seconds.
        motionManager.accelerometerUpdateInterval = 0.2
        
//        ImageView.setGradientBackground(colorOne: Colors.red, colorTwo: Colors.white)
//        view.setGradientBackground(colorOne: Colors.red, colorTwo: Colors.white)
//        Info.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.white)
    ImageView.setGradientBackground(colorOne: Colors.red, colorTwo: Colors.maroon)
    ImageView.layer.cornerRadius = 30;
     ImageView.clipsToBounds = true
        
        let date = DateFormatter()
    
        date.dateStyle = .medium

         self.date.text = date.string(from: Date())
        
      
    }
    
    //Method that is going to be executed when user clicks on the start button
    @IBAction func startTimer(sender: UIButton) {
        resetValues()
         self.Text.text = "RESTART"
        
        
        //Clearing out previous time.
        timer.invalidate()
        
        //Calling to reset values
        resetValues()
        
        //Start Recording Data
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(ViewController.countdown),
            //selector: Selector("countdown"),
            userInfo: nil,
            repeats: true)
        
        //Calling the countdown() method
        countdown()
        //Repeating the method using the NSTimer.
    }
    
    //Method that is going to be executed to reset values in accelerometer and other custom variables
    func resetValues() {
        currentX = 0.0
        currentY = 0.0
        currentZ = 0.0
        previousX = 0.0
        previousY = 0.0
        previousZ = 0.0
        totalPath = 0.0
        firstX = 0.0
        firstY = 0.0
        firstZ = 0.0
        newX = 0.0
        newY = 0.0
        newZ = 0.0
        yes = 1
        
        totalPathFirstTenSecondsVal = 0.0
        seconds = 21;
        wait = 3;
        counting = true;
        data = ""
        dataFirst = ""
        self.totalPathLength.text = " "
        self.peakLengthBox.text = " "
        self.totalPathLengthFirstTenSeconds.text = " "
    }
    
    func reset() {
        counting = false;
        currentX = 0.0
        currentY = 0.0
        currentZ = 0.0
        previousX = 0.0
        previousY = 0.0
        previousZ = 0.0
        totalPath = 0.0
         totalPathFirstTenSecondsVal = 0.0
        finalMaxLength = 0.0
        firstX = 0.0
        firstY = 0.0
        firstZ = 0.0
        newX = 0.0
        newY = 0.0
        newZ = 0.0
        first = 1
        yes = 1
//        self.totalPathLength.text = " "
//        self.peakLengthBox.text = " "
         counting = true;
       
    }
    
    //Countdwon function that handles the timer
    @objc func countdown(){
       // self.countdownLabel.text = "\(seconds--)"
        if(seconds < 1) {
            counting = false;
            self.countdownLabel.text = "0"
            self.totalPathLength.text = "\(totalPath)"
            self.totalPathLengthFirstTenSeconds.text = "\(totalPathFirstTenSecondsVal)"
            self.peakLengthBox.text = "\(finalMaxLength)"
            motionManager.stopAccelerometerUpdates()
//            performSegue(withIdentifier: "Two", sender: self)
            HiddenView.isHidden = false;
            MailButton.isHidden = false;
            
            for _ in 1...2 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
            seconds = 25
            counting = false;
            wait = 4
            
        }

        else if (seconds < 22 && wait < 1){
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {
                (accelerometerData: CMAccelerometerData?, NSError) -> Void in
                self.processData(accelerometer: accelerometerData!.acceleration)
                if(NSError != nil) { print("\(String(describing: NSError))") }
            }
            
            if(wait > 0){
                reset()
            }
                seconds -= 1
            self.countdownLabel.text = "\(seconds)"
        }
        //countdown wait time
        if (wait < 4){
            wait -= 1
            
            if (wait == 2){
                self.countdownLabel.text = "SET"
              
                for _ in 1...1 {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    //vibrate on set
                }
            }
            if (wait == 1){
                self.countdownLabel.text = "GO"
                for _ in 1...1 {
                    //vibrate on go
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }
        }
        else if (wait == 4){
            reset()
        }
    }
    
    //Function that is going to process data from accelerometer.
    func processData (accelerometer: CMAcceleration) {
    
        if (counting){
            //Updating the variable to rounded number to 3 decimal places
         
            
            
            currentX = Double(round(accelerometer.x * 1000000)/1000)
            currentY = Double(round(accelerometer.y * 1000000)/1000)
            currentZ = Double(round(accelerometer.z * 1000000)/1000)
            
            if(first == 1) {
            firstX = currentX
            firstY = currentY
            firstZ = currentZ
                
               
                print(firstX)
                print(firstY)
                print(firstZ)
                first = 2
            }
            
            firstX = (firstX-0)
            firstY = (firstY-0)
            firstZ = (firstZ-0)
            
            if (yes == 1){
            if(firstX < 0.0){
                firstX = (firstX - (2*firstX))
            }
            
           else if(firstX >= 0.0){
                firstX = (firstX - (2*firstX))
            }
            }
         
            
            if (yes == 1){
            if(firstY < 0.0){
                firstY = (firstY - (2*firstY))
            }
            
            else if(firstY >= 0.0){
                firstY = (firstY - (2*firstY))
            }
            }
            
            
            if (yes == 1){
            if(firstZ < 0.0){
                firstZ = (firstZ - (2*firstZ))
            }
            
            else if(firstZ >= 0.0){
                firstZ = (firstZ - (2*firstZ))
            }
                
            }
        
         //   Converting into a string to write to a file.
            
            first = 2
            yes = 2
            newX = (currentX+firstX)
            newY = (currentY+firstY)
            newZ = (currentZ+firstZ)
            
            
            
            let tempX = "\(currentX+firstX)"
            
            let tempY = "\(currentY+firstY)"
            
            let  tempZ = "\(currentZ+firstZ)"
         
          
            
           
            
           
            //Adding elements to a string
            data += " " + tempX + " " + tempY + " " + tempZ + "\n"
            
            if(seconds >= 11){
                dataFirst += " " + tempX + " " + tempY + " " + tempZ + "\n"
                totalPathFirstTenSecondsVal += pointDistance(x1: previousX, x2: currentX, y1: previousY, y2: currentY, z1: previousZ, z2: currentZ)
            }
            
            //Adding the x and y values according to their quadrants.
            if(newX > 0 && newY > 0 && newZ > 0){
                //1st quadrant
                if(newX > highestXFirstQuad) {
                    highestXFirstQuad = newX
                }
                if(newY > highestYFirstQuad){
                    highestYFirstQuad = newY
                }
                if(newZ > highestZFirstQuad){
                    highestZFirstQuad = newZ
                }
            }else if (newX < 0 && newY > 0 && newZ > 0){
                //2nd quadrant
                if(newX < highestXSecondQuad) {
                    highestXSecondQuad = newX
                }
                if(newY > highestYSecondQuad){
                    highestYSecondQuad = newY
                }
                if(newZ > highestZSecondQuad){
                    highestZSecondQuad = newZ
                }
            }else if(newX < 0 && newY < 0 && newZ > 0){
                //3rd quadrant
                if(newX < highestXThirdQuad) {
                    highestXThirdQuad = newX
                }
                if(newY < highestYThirdQuad){
                    highestYThirdQuad = newY
                }
                if(newZ > highestZThirdQuad){
                    highestZThirdQuad = newZ
                }
            }else if(newX > 0 && newY < 0 && newZ > 0){
                //4th quadrant
                if(newX > highestXFourthQuad) {
                    highestXFourthQuad = newX
                }
                if(newY < highestYFourthQuad){
                    highestYFourthQuad = newY
                }
                if(newZ > highestXFourthQuad) {
                    highestZFourthQuad = newZ
                }
            }
            else if(newX > 0 && newY > 0 && newZ < 0){
                //5th quadrant
                if(newX > highestXFifthQuad) {
                    highestXFifthQuad = newX
                }
                if(newY > highestYFifthQuad){
                    highestYFifthQuad = newY
                }
                if(newZ < highestXFifthQuad) {
                    highestZFifthQuad = newZ
                }
            }
                else if(newX < 0 && newY > 0 && newZ < 0){
                    //6th quadrant
                    if(newX < highestXSixthQuad) {
                        highestXSixthQuad = newX
                    }
                    if(newY > highestYSixthQuad){
                        highestYSixthQuad = newY
                    }
                    if(newZ < highestXSixthQuad) {
                        highestZSixthQuad = newZ
                    }
            }
            else if(newX < 0 && newY < 0 && newZ < 0){
                //7th quadrant
                if(newX < highestXSeventhQuad) {
                    highestXSeventhQuad = newX
                }
                if(newY < highestYSeventhQuad){
                    highestYSeventhQuad = newY
                }
                if(newZ < highestXSeventhQuad) {
                    highestZSeventhQuad = newZ
                }
            }
            else {
                //8th quadrant
                if(newX > highestXEigthQuad) {
                    highestXEigthQuad = newX
                }
                if(newY < highestYEigthQuad){
                    highestYEigthQuad = newY
                }
                if(newZ < highestXEigthQuad) {
                    highestZEigthQuad = newZ
                }
                
                
            }
            
            
            //Calculating the total path length
            //totalPath += Double(round(sqrt(pow(previousX - currentX, 2) + pow (previousY - currentY, 2)) * 100) / 100)
            totalPath += pointDistance(x1: previousX, x2: currentX, y1: previousY, y2: currentY, z1: previousZ, z2: currentZ)
            
            //Calculating the distance between one point in a quadrant to other quadrants' highest point.
            maxLength1 = pointDistance(x1: highestXFirstQuad, x2: highestXSecondQuad, y1: highestYFirstQuad, y2: highestYSecondQuad, z1: highestZFirstQuad, z2: highestZSecondQuad)
            maxLength2 = pointDistance(x1: highestXFirstQuad, x2: highestXThirdQuad, y1: highestYFirstQuad, y2: highestYThirdQuad, z1: highestZFirstQuad, z2: highestZThirdQuad)
            maxLength3 = pointDistance(x1: highestXFirstQuad, x2: highestXFourthQuad, y1: highestYFirstQuad, y2: highestYFourthQuad, z1: highestZFirstQuad, z2: highestZFourthQuad)
            maxLength4 = pointDistance(x1: highestXFirstQuad, x2: highestXFifthQuad, y1: highestYFirstQuad, y2: highestYFifthQuad, z1: highestZFirstQuad, z2: highestZFifthQuad)
            maxLength5 = pointDistance(x1: highestXFirstQuad, x2: highestXSixthQuad, y1: highestYFirstQuad, y2: highestYSixthQuad, z1: highestZFirstQuad, z2: highestZSixthQuad)
            maxLength6 = pointDistance(x1: highestXFirstQuad, x2: highestXSeventhQuad, y1: highestYFirstQuad, y2: highestYSeventhQuad, z1: highestZFirstQuad, z2: highestZSeventhQuad)
            maxLength7 = pointDistance(x1: highestXFirstQuad, x2: highestXEigthQuad, y1: highestYFirstQuad, y2: highestYEigthQuad, z1: highestZFirstQuad, z2: highestZEigthQuad)
            
            
            //FinalMaxLength is the farthest distance from one quadrant to other seven quadrants.
//            finalMaxLength = max(max(max(max(max(max(maxLength1, maxLength2), maxLength3), maxLength4), maxLength5), maxLength6), maxLength7)
            
        }
        previousX = Double(round(accelerometer.x * 1000000)/1000)
        previousY = Double(round(accelerometer.y * 1000000)/1000)
        previousZ = Double(round(accelerometer.z * 1000000)/1000)
    }
    
    //Function to calculate the distance between two points
    func pointDistance(x1:Double, x2:Double, y1:Double, y2:Double, z1:Double, z2:Double)->Double {
        
        let distance = Double(round(sqrt(pow(x1 - x2, 2) + pow (y1 - y2, 2) + pow (z1 - z2, 2)) * 100) / 100)
    
        return distance
        
       
//         + pow (z1 - z2, 2)
    }
    
    //this is the file. we will write to and read from it
    let fileName = "data.txt"
    let firstFileName = "data10.txt"
    let directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    //Function to create a test  that contains data from the accelerometer.
    func createTestFile(data: String) {
        
        //Variables for the location where the files are going to be saved.
        guard let directory = directories.first else { return }
        let fileSaveLocation = NSURL(fileURLWithPath: fileName , relativeTo: directory)
        let fileSaveLocation1 = NSURL(fileURLWithPath: firstFileName , relativeTo: directory)
        
        do {
            //writing the data to the different text files.
            try data.write(to: fileSaveLocation as URL, atomically: true, encoding: String.Encoding.utf8)
            try dataFirst.write(to: fileSaveLocation1 as URL, atomically: true, encoding: String.Encoding.utf8)
        }catch {}
        //print("*** file saved to path: \(fileSaveLocation)")
        
    }
    
    //Method that is going to be executed when user clicks on the mail button
    @IBAction func sendMail(sender: UIButton) {
        let mailComposeViewController = configureMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated:true, completion: nil)
        }
    }
    
    //Setting up the email.
    func configureMailComposeViewController() -> MFMailComposeViewController{
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        //Constants for the email.
        let receipient = "researchmicklynch@gmail.com"
        let subject = "Data file for  and  ";
        //let message = data + "\n\nTotal Path Length" + "\(totalPathLength)" + "\n\nTotal Path length first 10: " + "\(totalPathLengthFirstTenSeconds)" + "Peak Length: " + "\(finalMaxLength)"
        
        //Setting the constants in the email.
        mailComposer.setToRecipients([receipient])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(data, isHTML: false)
        
        createTestFile(data: data)
        
        let directory = directories.first
        
        //File Location for the text file that contains data for the entire 20 seconds.
        let fileLocationForLoad = NSURL(fileURLWithPath: fileName, relativeTo: directory)
        let urlString: String = fileLocationForLoad.path!
        
        //File location for the text file that contains data for the first 10 seconds.
        let fileLocationForLoad1 = NSURL(fileURLWithPath: firstFileName, relativeTo: directory)
        let urlString1: String = fileLocationForLoad1.path!
        
        
        //Adding the attachment/data file to the email.
        if let fileData = NSData(contentsOfFile: urlString){
            mailComposer.addAttachmentData(fileData as Data, mimeType: "text/plain", fileName: fileName)
        }
        
        if let fileData1 = NSData(contentsOfFile: urlString1){
            mailComposer.addAttachmentData(fileData1 as Data, mimeType: "text/plain", fileName: firstFileName)
        }
        
        //Priting variables for testing purposes
        //These will not update to current results, they need to be reset for each test somewhere in the code
        print(highestXFirstQuad)
        print("\n\n\n")
        print(highestYFirstQuad)
        print("\n\n\n")
        print(highestZFirstQuad)
        print("\n\n\n")
        print(highestXSecondQuad)
        print("\n\n\n")
        print(highestYSecondQuad)
        print("\n\n\n")
        print(highestZSecondQuad)
        print("\n\n\n")
        print(highestXThirdQuad)
        print("\n\n\n")
        print(highestYThirdQuad)
        print("\n\n\n")
        print(highestZThirdQuad)
        print("\n\n\n")
        print(highestXFourthQuad)
        print("\n\n\n")
        print(highestYFourthQuad)
        print("\n\n\n")
        print(highestZFourthQuad)
        print("\n\n\n")
        print(highestXFifthQuad)
        print("\n\n\n")
        print(highestYFifthQuad)
        print("\n\n\n")
        print(highestZFifthQuad)
        print("\n\n\n")
        print(highestXSixthQuad)
        print("\n\n\n")
        print(highestYSixthQuad)
        print("\n\n\n")
        print(highestZSixthQuad)
        print("\n\n\n")
        print(highestXSeventhQuad)
        print("\n\n\n")
        print(highestYSeventhQuad)
        print("\n\n\n")
        print(highestZSeventhQuad)
        print("\n\n\n")
        print(highestXEigthQuad)
        print("\n\n\n")
        print(highestYEigthQuad)
        print("\n\n\n")
        print(highestZEigthQuad)
        print("\n\n\n")
        print(maxLength1)
        print("\n\n\n")
        print(maxLength2)
        print("\n\n\n")
        print(maxLength3)
        print("\n\n\n")
        print(maxLength4)
        print("\n\n\n")
        print(maxLength5)
        print("\n\n\n")
        print(maxLength6)
        print("\n\n\n")
        print("MaxLength7:",maxLength7)
        print("\n\n\n")
        print(maxLength8)
        print("\n\n\n")
        print(finalMaxLength)
        
        return mailComposer
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
       
            let secondController = segue.destination as! InfoView
        
  
   
    }
 
    
    
}


