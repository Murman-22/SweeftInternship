//
//  SweeftTask.swift
//  
//
//  Created by Muncho Mamardashvili on 3/16/23.
//

import Foundation

//  1. გვაქვს 1,5,10,20 და 50 თეთრიანი მონეტები. დაწერეთ ფუნქცია, რომელსაც გადაეცემა თანხა (თეთრებში) და აბრუნებს მონეტების
//      მინიმალურ რაოდენობას, რომლითაც შეგვიძლია ეს თანხა დავახურდაოთ.

func minSplit(amount: Int, usingCoins coins: Set<Int> = [1, 5, 10, 20, 50]) -> Int {
    // return 50
    // ვრწმუნდებით, რომ მოთხოვნილი თანხა ვალიდურია
    guard amount > 0 else { return 0 }
    
    var coinsCount = 0
    
    // იტერაციების რაოდენობის დაზოგვის მიზნით ვშლით გამოუყენებად და არავალიდურ მონეტებს
    let relevantCoins = coins.filter { $0 <= amount && $0 > 0 }
    guard relevantCoins.isEmpty == false else { return 0 } // nil აჯობებდა
    
    // cache მონეტების კომბინირებისას დუბლირებული ნაშთების პრევენციისთვის
    var duplicationPreventionCache: Set<Int> = [amount]
    var coinMinuends: Set<Int> = [amount]
    
    // infinite loop რეკურსიული ფუნქციის ალტერნატივად :)
    while true {
        coinsCount += 1
        // საკლები მოცულობების set-ი, რომელშიც შეგვყავს მხოლოდ ნატურალი რიცხვები
        var newMinuends: Set<Int> = []
        
        for minuend in coinMinuends {
            for coin in relevantCoins {
                let updatedMinuend = minuend - coin
                if updatedMinuend > 0 {
                    let (isNewMinuend, _) = duplicationPreventionCache.insert(updatedMinuend)
                    // თუ ნაშთი ახალია, ვინახავთ შემდეგი იტერაციისთვის
                    if isNewMinuend {
                        newMinuends.insert(updatedMinuend)
                    }
                } else if updatedMinuend == 0 {
                    // ვაბრუნებთ მონეტების მინიმალურ რაოდენობას
                    return coinsCount
                }
            }
        }
        
        // newMinuends ცარიელია, როდესაც წინამდებარე იტერაციის შედეგად ვერ მივიღეთ უნიკალური დადებითი ნაშთ(ებ)ი
        if newMinuends.isEmpty {
            return 0
        } else {
            coinMinuends = newMinuends
        }
    }
    
    return coinsCount
}
/// დავალების მაგალითებში მოცემულ სინტაქსთან თავსებადობა
func minSplit(_ amount: Int) -> Int {
    minSplit(amount: amount)
}





//  2. დაწერეთ ფუნქცია რომელიც დააჯამებს ციფრებს ორ რიცსხვს შორის.
//      მაგალითად გადმოგვეცემა 19 და 22. მათ შორის ციფრების ჯამი იქნება :
//      // 19, 20, 21, 22
//      // (1 + 9) + (2 + 0) + (2 + 1) + (2 + 2) = 19

extension Int {
    var digitsSum: Int {
        var quotient = abs(self)
        var sum = 0
        while quotient > 0 {
            sum += quotient % 10
            quotient = quotient / 10
        }
        return sum
    }
}
func sumOfDigits(start: Int,  end: Int) -> Int {
    guard start < end else { return 0 }
    let numbersRange = start...end
    let rangeElementsDigitsSum = numbersRange.reduce(into: 0) {
        $0 += $1.digitsSum
    }
    return rangeElementsDigitsSum
}
/// დავალების მაგალითებში მოცემულ სინტაქსთან თავსებადობა
func sumOfDigits(_ start: Int, _ end: Int) -> Int {
    sumOfDigits(start: start, end: end)
}





// 3. მოცემულია String რომელიც შედგება „(" და „)" ელემენტებისგან. დაწერეთ ფუნქცია რომელიც აბრუნებს ფრჩხილები არის თუ არა მათემატიკურად სწორად დასმული.
func isProperly(sequence: String) -> Bool {
    var openedBracesCount = 0
    
    for char in sequence {
        if char == "(" {
            openedBracesCount += 1
        } else if char == ")" {
            if openedBracesCount > 0 {
                openedBracesCount -= 1
            } else {
                return false
            }
        }
    }
    return openedBracesCount == 0
}





//  4. გვაქვს N ფიცრისგან შემდგარი ხიდი. სიძველის გამო ზოგიერთი ფიცარი ჩატეხილია. ზურიკოს შეუძლია გადავიდეს შემდეგ ფიცარზე ან გადაახტეს ერთ ფიცარს. (რათქმაუნდა ჩატეხილ   ფიცარზე ვერ გადავა)
//      ჩვენი ამოცანაა დავითვალოთ რამდენი განსხვავებული კომბინაციით შეუძლია ზურიკოს ხიდის გადალახვა. გადმოგვეცემა ხიდის სიგრძე და ინფორმაცია ჩატეხილ ფიცრებზე. 0 აღნიშნავს ჩატეხილ ფიცარს 1_ანი კი მთელს. დასაწყისისთვის ზურიკო დგას ხიდის ერთ მხარეს (არა პირველ ფიცარზე) და გადალახვად ჩათვლება ხიდის მეორე მხარე (ბოლო ფიცრის შემდეგი ნაბიჯი)

func countWays(n: Int, steps: [Int]) -> Int {
    guard steps.count == n, n > 0 else {
        return 0
    }
    
    enum Move { case step, jump }
    var movesHistory: [Move] = [.step]
    
    for step in steps {
        var newMoves: [Move] = []
        
        let isBroken = step == 0
        
        if isBroken {
            for move in movesHistory where move == .step {
                newMoves.append(.jump)
            }
        } else {
            for move in movesHistory {
                newMoves.append(.step)
                if move == .step {
                    newMoves.append(.jump)
                }
            }
        }
        
        if newMoves.isEmpty { return 0 }
        movesHistory = newMoves
    }
    
    return movesHistory.count
}





//  5. გადმოგეცემათ მთელი რიცხვი N. დაწერეთ ფუნქცია რომელიც დაითვლის რამდენი 0ით ბოლოვდება N! (ფაქტორიალი)
//      შენიშვნა 1000! შედგება 2568 სიმბოლოსაგან.

func zeros(N: Int) -> Int {
    var zerosCount = 0
    var powersOfFive = 5
    
    while N / powersOfFive > 0 {
        zerosCount += N / powersOfFive
        powersOfFive *= 5
    }
    return zerosCount
}
