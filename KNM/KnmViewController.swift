//
//  ViewController.swift
//  KNM
//
//  Created by Mohammad Namvar on 22/01/2019.
//  Copyright © 2019 Mohammad Namvar. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class KnmViewController: UIViewController {
    
    var deck = [FlashCards]()
    var index = -1
    var divisor: CGFloat!
    var category: Category? = Category.nederland
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 36)
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 20
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 20
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let frontTapHelpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = true
        label.text = "Tap to flip and swipe to see next card"
        return label
    }()
    
    let backTapHelpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = true
        label.text = "Tap to flip"
        return label
    }()
    
    let frontView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        view.isHidden = false
        view.layer.cornerRadius = 20.0
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.7
        return view
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.isHidden = true
        view.layer.cornerRadius = 20.0
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.7
        return view
    }()
    
    let counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.layer.cornerRadius = label.frame.width/2
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.isHidden = true
        return label
    }()
    
    lazy var voiceImageView: UIImageView = {
        let iv = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sayQuestion))
        tap.numberOfTapsRequired = 1
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled  = true
//        iv.backgroundColor = .yellow
        iv.image = UIImage(named: "icons8-voice-filled-500")
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divisor = (view.frame.width / 2) / 0.61
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // view
        view.addSubview(frontView)
        view.addConstraintsWithFormat(format: "H:|-32-[v0]-32-|", views: frontView)
        view.addConstraintsWithFormat(format: "V:|-100-[v0]-100-|", views: frontView)
        
        view.addSubview(backView)
        view.addConstraintsWithFormat(format: "H:|-32-[v0]-32-|", views: backView)
        view.addConstraintsWithFormat(format: "V:|-100-[v0]-100-|", views: backView)
        
        view.addSubview(counterLabel)
        view.addConstraintsWithFormat(format: "H:|-32-[v0]-32-|", views: counterLabel)
        view.addConstraintsWithFormat(format: "V:|-48-[v0]-24-[v1]-100-|", views: counterLabel, frontView)
        
        // front view
        frontView.addSubview(questionLabel)
        frontView.addSubview(frontTapHelpLabel)
        frontView.addSubview(voiceImageView)
        frontView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: questionLabel)
        frontView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: frontTapHelpLabel)
        frontView.addConstraintsWithFormat(format: "H:|-8-[v0(36)]", views: voiceImageView)
        frontView.addConstraintsWithFormat(format: "V:|-8-[v0(36)]-4-[v1]-16-[v2(44)]-16-|", views: voiceImageView, questionLabel, frontTapHelpLabel)
        
        // back view
        backView.addSubview(answerLabel)
        backView.addSubview(backTapHelpLabel)
        backView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: answerLabel)
        backView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: backTapHelpLabel)
        backView.addConstraintsWithFormat(format: "V:|-16-[v0]-16-[v1(44)]-16-|", views: answerLabel, backTapHelpLabel)
        
//        perform(#selector(flip), with: nil, afterDelay: 2)
        
        loadCards(category: category)
        deck.shuffle()
        nextQuestion()
        
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(close))
        tapClose.numberOfTapsRequired = 3
        view.addGestureRecognizer(tapClose)
        
        // Question
        let tapQuestion = UITapGestureRecognizer(target: self, action: #selector(flip))
        tapQuestion.numberOfTapsRequired = 1
        frontView.addGestureRecognizer(tapQuestion)
        
        let panQuestion = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        frontView.addGestureRecognizer(panQuestion)
        
       
        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler))
//        swipeLeft.direction = .left
//        frontView.addGestureRecognizer(swipeLeft)
//
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler))
//        swipeRight.direction = .right
//        frontView.addGestureRecognizer(swipeRight)
//
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler))
//        swipeUp.direction = .up
//        frontView.addGestureRecognizer(swipeUp)
//
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(gestureHandler))
//        swipeDown.direction = .down
//        frontView.addGestureRecognizer(swipeDown)
        
        
        //Answer
        let tapAnswer = UITapGestureRecognizer(target: self, action: #selector(flip))
        tapAnswer.numberOfTapsRequired = 1
        backView.addGestureRecognizer(tapAnswer)
        
        let panAnswer = UIPanGestureRecognizer(target: self, action: #selector(answerPanHandler))
        backView.addGestureRecognizer(panAnswer)
        
    }
    
    @objc func answerPanHandler(_ sender: UIPanGestureRecognizer) {
//        self.frontView.isHidden = !self.frontView.isHidden
//        self.backView.isHidden = !self.backView.isHidden
//        panHandler(sender)
    }
    
    @objc func panHandler(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let scale = min(100/abs(xFromCenter), 1)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/self.divisor).scaledBy(x: scale, y: scale)
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 150 {
                // move to the left off
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                    self.nextQuestion()
                })
                return
            } else if card.center.x > (view.frame.width - 150) {
                // move to the right off
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                    self.previousQuestion()
                })
                return
            }
            
            resetToCenter()
        }
        
    }
    
    func resetToCenter(){
        UIView.animate(withDuration: 0.2, animations: {
            self.frontView.center = self.view.center
            self.frontView.alpha = 1
            self.frontView.transform = .identity
        })
    }
    
    @objc func gestureHandler(gesture: UISwipeGestureRecognizer) -> Void {
    
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            print("Swipe Right")
            disolve()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            print("Swipe Left")
            disolve()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            print("Swipe Up")
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            print("Swipe Down")
        }
    }
    
    @objc func setRandomQuestion() -> Void {
        if self.deck.count == 0 {
            questionLabel.text = "The deck is empty"
            answerLabel.text = "Het kaartspel is leeg"
            return
        }
        
        let number = Int.random(in: 0 ..< self.deck.count)
        if index == number {
            setRandomQuestion()
        } else {
            index = number
        }
        
        setCard(index: index)
        
    }
    
    @objc func previousQuestion() -> Void {
        if isDeckEmpty() {
            return
        }
        
        if index <= 0 {
            resetToCenter()
            return
        } else {
            index = index - 1
        }
        
        setCard(index: index)
    }
    
    @objc func nextQuestion() -> Void {
        if isDeckEmpty() {
            return
        }
        
        if index == deck.count - 1 {
            resetToCenter()
            return
        } else {
            index = index + 1
        }
        
        setCard(index: index)
        
    }

    func isDeckEmpty() -> Bool{
        if deck.count == 0 {
            questionLabel.text = "The deck is empty"
            answerLabel.text = "Het kaartspel is leeg"
            return true
        } else {
            return false
        }
    }

    func setCard(index: Int) {
        if deck.isEmpty {
            print("Deck is empty")
            return
        }
        
        questionLabel.text = deck[index].question
        answerLabel.text = deck[index].answer
        counterLabel.text = "\(index + 1)/\(deck.count)"
        setupTitle(text: "\(index + 1)/\(deck.count)")
        frontView.backgroundColor = Category(rawValue: deck[index].category)?.getColor()
        
        self.frontView.isHidden = false
        self.backView.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.frontView.center = CGPoint(x: self.frontView.center.x, y: self.frontView.center.y)
            self.frontView.alpha = 1
            self.frontView.transform = .identity
        })
        
    }
    
    func setupTitle(text: String){
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        navigationItem.titleView = titleLabel
    }
    
    @objc func close() {
//        dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func sayQuestion(){
        if deck.isEmpty {
            speak(text: questionLabel.text)
            return
        }
        speak(text: deck[index].question)
    }
    
    func speak(text: String?){
        guard let text = text else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl_NL")
        utterance.rate = 0.4
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @objc func flip() {
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: frontView, duration: 0.5, options: transitionOptions, animations: {
            self.frontView.isHidden = !self.frontView.isHidden
        })

        UIView.transition(with: backView, duration: 0.5, options: transitionOptions, animations: {
            self.backView.isHidden = !self.backView.isHidden
        })
        
    }
    
    @objc func disolve() {
        
        setRandomQuestion()
        
        let transitionOptions: UIView.AnimationOptions = [.transitionCrossDissolve, .showHideTransitionViews]
        
        UIView.transition(with: frontView, duration: 0.5, options: transitionOptions, animations: {
            self.frontView.isHidden = false
        })
        
        UIView.transition(with: backView, duration: 0.5, options: transitionOptions, animations: {
            self.backView.isHidden = true
        })
    }
    
    
    func loadCards(category: Category?) {
        if let category = category {
            do {
                let request: NSFetchRequest<FlashCards> = FlashCards.fetchRequest()
                request.predicate = NSPredicate(format: "category == %d", category.rawValue)
                deck = try FlashCardsService.context.fetch(request)
                for card in deck {
                    if let text = card.question {
                        spelChecker(text: text)
                    }
                    if let text = card.answer {
                        spelChecker(text: text)
                    }
                }
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    func spelChecker(text: String) {
        let words = text.split{$0 == " "}.map(String.init)
        for word in words {
            let checker = UITextChecker()
            let language = "nl_NL"
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: language)
            
            if misspelledRange.location != NSNotFound, let guess = checker.guesses(forWordRange: misspelledRange, in: word, language: language) {
                print("Misspelled: \(word), Guess:\(guess)")
            }
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}




extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func kalatagColor() -> UIColor {
        // Green
        //        button.backgroundColor = UIColor.rgb(red: 127, green: 170, blue: 104)
        return UIColor.rgb(red: 0, green: 170, blue: 228)
    }
    
    static func kalatagGreen() -> UIColor {
        // Green
        return UIColor.rgb(red: 108, green: 180, blue: 91)
    }
    
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
}
