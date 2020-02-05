//
//  Hiscores.swift
//  UIViewInvaders
//
//  Created by Jonathan French on 18/01/2020.
//  Copyright © 2020 Jaypeeff. All rights reserved.
//

import Foundation
import UIKit
import CoreData
#if TVOS
import UIAlphaNumericTV
#else
import UIAlphaNumeric
#endif
var coreDataStack = CoreDataStack(modelName: "HighScores")


public class UIHighScores {
    
    public var titleString = "HiScores"
    public var titleFCol = UIColor.blue {
        didSet {
            //title.
        }
    }
    public var titleBCol = UIColor.yellow
    public var scoreFCol = UIColor.red
    public var scoreBCol = UIColor.white
    
    public var newTitleString = "New Hi Score"
    public var newTitleFCol = UIColor.orange
    public var newTitleBCol = UIColor.green
    
    public var newSubTitleString = "Enter your initials"
    public var newSubTitleFCol = UIColor.blue
    public var newSubTitleBCol = UIColor.yellow

    public var newInitialFCol = UIColor.orange
    public var newInitialBCol = UIColor.clear

    public var newInitialHilightCol = UIColor.red.cgColor

    public var textPadding:Int = 2
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var coreDataStack = CoreDataStack(modelName: "HighScores")
        return CoreDataStack.moc
    }()

    var hiScores:[HighScores] = []
    var startPos:CGFloat = 0.0
    public var highScoreView:UIView = UIView()
    public var newHighScoreView:UIView = UIView()
    var alphaStringView:[StringView] = [StringView(),StringView(),StringView()]
    var alphaChar:[Int] = [10,10,10]
    public var alphaPos:Int = 0
    var viewWidth:CGFloat = 0
    //var coreDataStack:CoreDataStack?
    
    var title = UIView()
 
    var headHeight:Int = 0
    var scoreHeight:Int = 0

    public init(){
        getScores()
    }
    
    
    public init(xPos:CGFloat,yPos:CGFloat,width:CGFloat,height:CGFloat) {
        startPos = xPos + width
        viewWidth = width
        headHeight = Int((height / 100) * 20)
        scoreHeight = Int(((height / 100) * 80) / 10)
        highScoreView = UIView.init(frame: CGRect(x: startPos, y: yPos, width: width, height: height))
        highScoreView.backgroundColor = .clear
//        drawScores()
//        let alpha:UIAlphaNumeric = UIAlphaNumeric()
//        let w = Int(width)
//        getScores()
//        title = UIView(frame: CGRect(x: 20, y: 0, width: w - 40, height: headHeight))
//        title.addSubview(alpha.get(string: titleString, size: (title.frame.size), fcol: titleFCol, bcol:
//            titleBCol ))
//        title.backgroundColor = .clear
//        startPos = highScoreView.center.x
//        highScoreView.addSubview(title)
//        for (index,h) in hiScores.enumerated() {
//            let hscore = UIView(frame: CGRect(x: 40, y: headHeight + textPadding + (index * scoreHeight), width: w - 80, height: scoreHeight - textPadding))
//            hscore.addSubview(alpha.get(string: "\(h.initials!) \(String(format: "%06d", h.score))", size: (hscore.frame.size), fcol: scoreFCol, bcol:scoreBCol))
//            hscore.backgroundColor = .clear
//            highScoreView.addSubview(hscore)
//        }
        
    }
    
    public func drawScoreView(){
               let alpha:UIAlphaNumeric = UIAlphaNumeric()
               let w = Int(viewWidth)
               getScores()
               title = UIView(frame: CGRect(x: 20, y: 0, width: w - 40, height: headHeight))
               title.addSubview(alpha.get(string: titleString, size: (title.frame.size), fcol: titleFCol, bcol:
                   titleBCol ))
               title.backgroundColor = .clear
               startPos = highScoreView.center.x
               highScoreView.addSubview(title)
               for (index,h) in hiScores.enumerated() {
                   let hscore = UIView(frame: CGRect(x: 40, y: headHeight + textPadding + (index * scoreHeight), width: w - 80, height: scoreHeight - textPadding))
                   hscore.addSubview(alpha.get(string: "\(h.initials!) \(String(format: "%06d", h.score))", size: (hscore.frame.size), fcol: scoreFCol, bcol:scoreBCol))
                   hscore.backgroundColor = .clear
                   highScoreView.addSubview(hscore)
               }
        
    }
    
    public func getScores(){
        
        let fetchRequest: NSFetchRequest<HighScores> = HighScores.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: HighScores.sortByScoreKey,
                                                         ascending: false)]
        fetchRequest.fetchLimit = 10
        do {
            hiScores = try managedObjectContext.fetch(fetchRequest)

        } catch {
            fatalError("Data Fetch Error")
        }

    }
    
    public func addScores(score:Int){
        
    let newHighScore:HighScores = HighScores.init(entity: NSEntityDescription.entity(forEntityName: "HighScores", in:managedObjectContext)!, insertInto: managedObjectContext)
       newHighScore.initials = getInitialsString()
        newHighScore.score = Int32(score)
        self.managedObjectContext.insert(newHighScore)
        do {
            try self.managedObjectContext.save()
        }
        catch {
            print("Error saving new score")
        }
    }
    
    public func removeScores(){
        
    }
    
    public func isNewHiScore(score:Int) -> Bool {
        for s in hiScores {
            if s.score < Int16(score) {
            return true
            }
        }
        return false
    }
    
    public func showNewHiScore(frame:CGRect) {
        newHighScoreView = UIView.init(frame: frame)
        newHighScoreView.backgroundColor = .clear
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        let w = Int(frame.width)
        let title = UIView(frame: CGRect(x: 0, y: 20, width: w, height: 60))
        title.addSubview(alpha.get(string: newTitleString, size: (title.frame.size), fcol: newTitleFCol, bcol:newTitleBCol ))
        title.backgroundColor = .clear
        newHighScoreView.addSubview(title)
        let subtitle = UIView(frame: CGRect(x: 0, y: 90, width: w, height: 40))
        subtitle.addSubview(alpha.get(string: newSubTitleString, size: (title.frame.size), fcol: newSubTitleFCol, bcol:newSubTitleBCol ))
        subtitle.backgroundColor = .clear
        newHighScoreView.addSubview(subtitle)

        let xPositions = xPositionsForSprites(spriteWidth: 60, offSet: 90, numberOfSprites: 3)
        for (index,i) in alphaChar.enumerated() {
            //let xPositions = [90 - 30,(w / 2) - 30 ,w - 90 - 30] //((w / 3) * index) + 60,
            let charView = UIView(frame: CGRect(x: xPositions[index], y: 180 , width: 60, height: 60))

            alphaStringView[index] = (alpha.getCharView(char: alpha.getCharacter(pos:i),size: (charView.frame.size), fcol: newInitialFCol, bcol:newInitialBCol ))
            charView.addSubview(alphaStringView[index].charView!)
            newHighScoreView.addSubview(charView)
        }
        hilightChar()
    }
    
    public func hilightChar() {
        guard alphaPos < alphaStringView.count else {
            print("oops \(alphaPos)")
            return
        }
        for i in alphaStringView {
            i.charView?.layer.borderWidth = 2.0
            i.charView?.layer.borderColor = UIColor.clear.cgColor
        }
        alphaStringView[alphaPos].charView?.layer.borderColor = newInitialHilightCol
    }
    
    public func charUp(){
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        alphaChar[alphaPos] = alpha.nextChar(pos:alphaChar[alphaPos] )
        alpha.updateChar(char: alpha.getCharacter(pos:alphaChar[alphaPos]), viewArray: alphaStringView[alphaPos].charViewArray, fcol: newInitialFCol, bcol: newInitialBCol)

        
    }
    
    public func charDown(){
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        alphaChar[alphaPos] = alpha.prevChar(pos:alphaChar[alphaPos] )
        alpha.updateChar(char: alpha.getCharacter(pos:alphaChar[alphaPos]), viewArray: alphaStringView[alphaPos].charViewArray, fcol: newInitialFCol, bcol: newInitialBCol)
    }
    
    public func getInitialsString() -> String {
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        return alphaChar.map({String(alpha.getCharacter(pos:$0))}).joined()
    }
    
    public func animateIn(){
        UIView.animate(withDuration: 2.0, delay: 2.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            if let superview = self.highScoreView.superview {
                self.highScoreView.center.x = superview.center.x
            }
        },completion:{finished in self.animateOut()})
    }
    
    public func animateOut(){
        UIView.animate(withDuration: 2.0, delay: 2.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            if let superview = self.highScoreView.superview {
                self.highScoreView.center.x = -superview.bounds.width
            }
        },completion:{finished in
            self.highScoreView.center.x = self.startPos
            self.animateIn()})
    }
    
    public func removeHighscore(){
        highScoreView.removeFromSuperview()
    }
    
    public func xPositionsForSprites(spriteWidth:Int,offSet:Int,numberOfSprites:Int ) -> [Int] {
        var intArray:[Int] = []
        let actualWidth = Int(viewWidth) - (offSet * 2)
        let step = (actualWidth) / (numberOfSprites - 1)
        intArray.append(offSet) // first will always be
        print("Offset \(offSet)")
        if numberOfSprites > 2 {
        for i in 1...numberOfSprites-2 {
            let x = (step * (i)) + (spriteWidth)
            intArray.append(x)
            }
        }
        intArray.append(actualWidth + (spriteWidth / 2))//last will always be frame we want to use - sprite width
        print("screen width \(viewWidth) step \(step) actual width \(actualWidth) int array \(intArray)")
        return intArray
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HighScores")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
