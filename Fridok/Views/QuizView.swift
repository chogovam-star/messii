import SwiftUI

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

extension QuizQuestion {
    static let allQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "Which planet is the largest in our Solar System?",
            options: ["Saturn", "Jupiter", "Neptune", "Uranus"],
            correctAnswer: 1,
            explanation: "Jupiter is the largest planet, with a mass 2.5 times all other planets combined!"
        ),
        QuizQuestion(
            question: "How long does light take to reach Earth from the Sun?",
            options: ["8 seconds", "8 minutes", "8 hours", "8 days"],
            correctAnswer: 1,
            explanation: "Light travels at 299,792 km/s and takes about 8 minutes to reach us."
        ),
        QuizQuestion(
            question: "Which planet rotates in the opposite direction?",
            options: ["Mars", "Venus", "Mercury", "Neptune"],
            correctAnswer: 1,
            explanation: "Venus rotates clockwise (retrograde), opposite to most planets!"
        ),
        QuizQuestion(
            question: "What is the hottest planet in our Solar System?",
            options: ["Mercury", "Venus", "Mars", "Jupiter"],
            correctAnswer: 1,
            explanation: "Venus is hottest at 465°C due to its thick atmosphere and greenhouse effect."
        ),
        QuizQuestion(
            question: "How many moons does Mars have?",
            options: ["0", "1", "2", "4"],
            correctAnswer: 2,
            explanation: "Mars has two small moons: Phobos and Deimos."
        ),
        QuizQuestion(
            question: "Which star is closest to our Sun?",
            options: ["Sirius", "Betelgeuse", "Proxima Centauri", "Vega"],
            correctAnswer: 2,
            explanation: "Proxima Centauri is only 4.24 light-years away from us."
        ),
        QuizQuestion(
            question: "What gives Mars its red color?",
            options: ["Copper", "Iron oxide", "Sulfur", "Magma"],
            correctAnswer: 1,
            explanation: "Iron oxide (rust) on the surface gives Mars its distinctive red color."
        ),
        QuizQuestion(
            question: "Which planet has the most moons?",
            options: ["Jupiter", "Saturn", "Uranus", "Neptune"],
            correctAnswer: 1,
            explanation: "Saturn has 146 known moons, the most of any planet!"
        ),
        QuizQuestion(
            question: "What is the Great Red Spot on Jupiter?",
            options: ["A volcano", "A storm", "A crater", "An ocean"],
            correctAnswer: 1,
            explanation: "It's a giant storm that has been raging for at least 400 years!"
        ),
        QuizQuestion(
            question: "Which planet could float on water?",
            options: ["Jupiter", "Uranus", "Saturn", "Neptune"],
            correctAnswer: 2,
            explanation: "Saturn's density is less than water, so it would float!"
        ),
        QuizQuestion(
            question: "How old is our Solar System?",
            options: ["1 billion years", "4.6 billion years", "10 billion years", "100 million years"],
            correctAnswer: 1,
            explanation: "Our Solar System formed about 4.6 billion years ago."
        ),
        QuizQuestion(
            question: "Which planet has the strongest winds?",
            options: ["Jupiter", "Saturn", "Uranus", "Neptune"],
            correctAnswer: 3,
            explanation: "Neptune has winds up to 2,100 km/h - the fastest in the Solar System!"
        )
    ]
}

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showResult = false
    @State private var isQuizComplete = false
    @State private var questions: [QuizQuestion] = []
    @State private var showExplanation = false
    
    let questionsPerGame = 5
    
    var body: some View {
        ZStack {
            StarFieldView(starCount: 100, showNebula: true)
            
            if isQuizComplete {
                quizCompleteView
            } else if questions.isEmpty {
                startView
            } else {
                questionView
            }
        }
    }
    
    private var startView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "FFD700").opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 30,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            
            VStack(spacing: 12) {
                Text("SPACE QUIZ")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(4)
                
                Text("Test your cosmic knowledge!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack(spacing: 8) {
                Text("\(questionsPerGame) Questions")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                
                Text("Earn points for correct answers")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: startQuiz) {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                    Text("Start Quiz")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "FFD700"))
                )
            }
            .padding(.horizontal, 40)
            
            Button(action: { dismiss() }) {
                Text("Back")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.bottom, 40)
        }
    }
    
    private var questionView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(0..<questionsPerGame, id: \.self) { i in
                        Circle()
                            .fill(i < currentQuestion ? Color(hex: "4CAF50") : (i == currentQuestion ? Color(hex: "FFD700") : Color.white.opacity(0.2)))
                            .frame(width: 10, height: 10)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(hex: "FFD700"))
                    Text("\(score)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.white.opacity(0.1)))
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            
            Spacer()
            
            VStack(spacing: 30) {
                Text("Question \(currentQuestion + 1)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "FFD700"))
                
                Text(questions[currentQuestion].question)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                ForEach(0..<questions[currentQuestion].options.count, id: \.self) { index in
                    AnswerButton(
                        text: questions[currentQuestion].options[index],
                        index: index,
                        selectedAnswer: selectedAnswer,
                        correctAnswer: showResult ? questions[currentQuestion].correctAnswer : nil,
                        action: { selectAnswer(index) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .disabled(showResult)
            
            if showExplanation {
                Text(questions[currentQuestion].explanation)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
            Spacer()
            
            if showResult {
                Button(action: nextQuestion) {
                    HStack {
                        Text(currentQuestion < questionsPerGame - 1 ? "Next Question" : "See Results")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "4CAF50"))
                    )
                }
                .padding(.horizontal, 20)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
            Spacer()
                .frame(height: 40)
        }
    }
    
    private var quizCompleteView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [resultColor.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 30,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: resultIcon)
                    .font(.system(size: 80))
                    .foregroundColor(resultColor)
            }
            
            VStack(spacing: 12) {
                Text(resultTitle)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text(resultMessage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 8) {
                Text("\(score)")
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundColor(resultColor)
                
                Text("out of \(questionsPerGame) correct")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: restartQuiz) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Play Again")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(resultColor)
                    )
                }
                
                Button(action: { dismiss() }) {
                    Text("Back to Home")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private var resultColor: Color {
        let percentage = Double(score) / Double(questionsPerGame)
        if percentage >= 0.8 { return Color(hex: "4CAF50") }
        if percentage >= 0.6 { return Color(hex: "FFD700") }
        return Color(hex: "FF6B6B")
    }
    
    private var resultIcon: String {
        let percentage = Double(score) / Double(questionsPerGame)
        if percentage >= 0.8 { return "star.fill" }
        if percentage >= 0.6 { return "hand.thumbsup.fill" }
        return "arrow.counterclockwise"
    }
    
    private var resultTitle: String {
        let percentage = Double(score) / Double(questionsPerGame)
        if percentage >= 0.8 { return "Excellent!" }
        if percentage >= 0.6 { return "Good Job!" }
        return "Keep Learning!"
    }
    
    private var resultMessage: String {
        let percentage = Double(score) / Double(questionsPerGame)
        if percentage >= 0.8 { return "You're a true space expert!" }
        if percentage >= 0.6 { return "You know your cosmos!" }
        return "Practice makes perfect!"
    }
    
    private func startQuiz() {
        AppSettings.shared.mediumHaptic()
        questions = Array(QuizQuestion.allQuestions.shuffled().prefix(questionsPerGame))
        currentQuestion = 0
        score = 0
        selectedAnswer = nil
        showResult = false
        isQuizComplete = false
    }
    
    private func selectAnswer(_ index: Int) {
        withAnimation(.spring(response: 0.3)) {
            selectedAnswer = index
            showResult = true
            
            if index == questions[currentQuestion].correctAnswer {
                score += 1
                AppSettings.shared.successHaptic()
            } else {
                AppSettings.shared.errorHaptic()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showExplanation = true
                }
            }
        }
    }
    
    private func nextQuestion() {
        withAnimation {
            showExplanation = false
        }
        
        if currentQuestion < questionsPerGame - 1 {
            withAnimation(.spring(response: 0.4)) {
                currentQuestion += 1
                selectedAnswer = nil
                showResult = false
            }
        } else {
            withAnimation(.spring(response: 0.5)) {
                isQuizComplete = true
            }
        }
    }
    
    private func restartQuiz() {
        withAnimation {
            isQuizComplete = false
            questions = []
        }
    }
}

struct AnswerButton: View {
    let text: String
    let index: Int
    let selectedAnswer: Int?
    let correctAnswer: Int?
    let action: () -> Void
    
    private var backgroundColor: Color {
        guard let correct = correctAnswer else {
            return selectedAnswer == index ? Color.white.opacity(0.2) : Color.white.opacity(0.08)
        }
        
        if index == correct {
            return Color(hex: "4CAF50").opacity(0.3)
        } else if selectedAnswer == index {
            return Color(hex: "FF6B6B").opacity(0.3)
        }
        return Color.white.opacity(0.05)
    }
    
    private var borderColor: Color {
        guard let correct = correctAnswer else {
            return selectedAnswer == index ? Color.white.opacity(0.4) : Color.white.opacity(0.1)
        }
        
        if index == correct {
            return Color(hex: "4CAF50")
        } else if selectedAnswer == index {
            return Color(hex: "FF6B6B")
        }
        return Color.white.opacity(0.1)
    }
    
    private var icon: String? {
        guard let correct = correctAnswer else { return nil }
        if index == correct { return "checkmark.circle.fill" }
        if selectedAnswer == index { return "xmark.circle.fill" }
        return nil
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(index == correctAnswer ? Color(hex: "4CAF50") : Color(hex: "FF6B6B"))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(borderColor, lineWidth: 1.5)
                    )
            )
        }
    }
}

#Preview {
    QuizView()
}
