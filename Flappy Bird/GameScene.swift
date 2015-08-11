//
//  GameScene.swift
//  Flappy Bird
//
//  Created by guitarrkurt on 09/08/15.
//  Copyright (c) 2015 guitarrkurt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var labelHolder = SKSpriteNode()
    
    let birdGroup: UInt32 = 1
    let objectGroup: UInt32 = 2
    let gapGroup: UInt32 = 0 << 3
    
    var gameOver = 0
    var movingObjects = SKNode()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
        
        self.addChild(movingObjects)

        makeBackGround()
        
        self.addChild(labelHolder)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        
        let birdTexture = SKTexture(imageNamed: "img/bird-01.png")
        let birdTexture2 = SKTexture(imageNamed: "img/bird-03.png")
        
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        bird.size.height = 50
        bird.size.width = 60
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdGroup
        bird.physicsBody?.contactTestBitMask = objectGroup
        bird.physicsBody?.collisionBitMask = gapGroup
        bird.zPosition = 10
        self.addChild(bird)
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.categoryBitMask = objectGroup
        self.addChild(ground)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if gameOver == 0 {
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        } else {
            score = 0
            scoreLabel.text = "0"
            
            movingObjects.removeAllChildren()
            makeBackGround()
            
            bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            
            labelHolder.removeAllChildren()
            
            gameOver = 0
            
            movingObjects.speed = 1
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func makeBackGround(){
        let bgTexture = SKTexture(imageNamed: "img/city.jpeg")
        let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let movebgforever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        for var i: CGFloat = 0; i < 3; ++i{
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            
            bg.runAction(movebgforever)
            movingObjects.addChild(bg)
            
        
        }
    }
    
    func makePipes(){
        if gameOver == 0{
            println("Entra a makePipes")
            
            let gapheight = bird.size.height * 4
            let movementAmount = arc4random() % UInt32(self.frame.height/2)
            let pipeoffset = CGFloat(movementAmount) - self.frame.size.height/4
            let movepipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
            
            let removepipes = SKAction.removeFromParent()
            let moveandremovepipes = SKAction.sequence([movepipes, removepipes])
            var tunnel1 = SKSpriteNode()
            var tunnel2 = SKSpriteNode()

            let pipetexture = SKTexture(imageNamed: "img/PipeUp.png")
            let pipe2texture = SKTexture(imageNamed: "img/PipeDown.png")
            //tunnel1.color = UIColor.greenColor()
            //tunnel2.color = UIColor.greenColor()
            
            
            tunnel1.runAction(moveandremovepipes)
            tunnel1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + tunnel1.size.height/2 + gapheight/2 + pipeoffset)
            tunnel1.physicsBody = SKPhysicsBody(rectangleOfSize: tunnel1.size)
            tunnel1.physicsBody?.dynamic = false
            tunnel1.physicsBody?.allowsRotation = false
            tunnel1.physicsBody?.categoryBitMask = objectGroup
            movingObjects.addChild(tunnel1)
            
            tunnel2.runAction(moveandremovepipes)
            tunnel2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + tunnel2.size.height/2 + gapheight/2 + pipeoffset)
            tunnel2.physicsBody = SKPhysicsBody(rectangleOfSize: tunnel2.size)
            tunnel2.physicsBody?.dynamic = false
            tunnel2.physicsBody?.allowsRotation = false
            tunnel2.physicsBody?.categoryBitMask = objectGroup
            movingObjects.addChild(tunnel2)
            
            let gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeoffset)
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(tunnel1.size.width, gapheight))
            gap.runAction(moveandremovepipes)
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.allowsRotation = false
            gap.physicsBody?.categoryBitMask = gapGroup
            gap.physicsBody?.collisionBitMask = gapGroup
            gap.physicsBody?.contactTestBitMask = birdGroup
            movingObjects.addChild(gap)
            
        }
    
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup {
            score++
            scoreLabel.text = "\(score)"
        } else {
            if gameOver == 0{
                gameOver = 1
                movingObjects.speed = 0
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.text = "¡Toca pantalla para intentar de nuevo!"
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelHolder.addChild(gameOverLabel)
                
                
            }
        }
    }
}
