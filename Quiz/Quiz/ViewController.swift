import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet weak var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextQuestionLabel: UILabel!
    @IBOutlet weak var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var showAnswerButton: UIButton!
    
    let questions: [String] =
    [
        "7 + 7?",
        "Capital of Vermont?",
        "Cognac made from?"
    ]
    
    let answers: [String] =
    [
        "14",
        "Montpelier",
        "Grapes"
    ]
    
    var currentQuestionIndex: Int = 0
    
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        let question: String = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentQuestionLabel.text = questions[currentQuestionIndex]
        
        updateOffScreenLabel()
    }
    
    func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenWidth
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the label's initial alpha
        nextQuestionLabel.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func animateLabelTransitions() {
        
        // Force any outstanding layout changes to occur
        view.layoutIfNeeded()
        
        // Disable next question button
        nextQuestionButton.isEnabled = false
        
        // Animate the alpha
        // and the center X constraints
        let screenWidth = view.frame.width
        self.nextQuestionLabelCenterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.75,
                               animations: {
            self.currentQuestionLabel.alpha = 0
            self.nextQuestionLabel.alpha = 1
            
            self.view.layoutIfNeeded()
        })
        
        animator.addCompletion { _ in
            swap(&self.currentQuestionLabel,
                 &self.nextQuestionLabel)
            swap(&self.currentQuestionLabelCenterXConstraint,
                 &self.nextQuestionLabelCenterXConstraint)
            
            self.updateOffScreenLabel()
            
            // Reenable next question button
            self.nextQuestionButton.isEnabled = true
        }
        
        animator.startAnimation()
        
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: 0.5,
//            delay: 0,
//            options: [.curveLinear],
//            animations: {
//
//                self.currentQuestionLabel.alpha = 0
//                self.nextQuestionLabel.alpha = 1
//
//                self.view.layoutIfNeeded()
//        }) { _ in
//            swap(&self.currentQuestionLabel,
//                 &self.nextQuestionLabel)
//            swap(&self.currentQuestionLabelCenterXConstraint,
//                 &self.nextQuestionLabelCenterXConstraint)
//
//            self.updateOffScreenLabel()
//
//            // Reenable next question button
//            self.nextQuestionButton.isEnabled = true
//        }
    }
}

