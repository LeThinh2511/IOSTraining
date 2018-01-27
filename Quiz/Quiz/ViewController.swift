//
//  ViewController.swift
//  Quiz
//
//  Created by ThinhLe on 1/26/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = [
    "what is 7 + 7?",
    "what is your name?",
    "how old are you?"
    ]
    let answers: [String] = [
    "14",
    "My name is Thinh.",
    "I'm 21"
    ]
    var currentQuestionIndex = 0
    
    @IBAction func showNextQuestion(_ sender: UIButton)
    {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count
        {
            currentQuestionIndex = 0
        }
        let question: String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "?????"
    }
    
    @IBAction func showAnswer(_ sender: UIButton)
    {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
}
//UIWindows -> UIView
