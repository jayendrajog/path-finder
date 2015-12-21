//
//  GameScene.swift
//  path finder
//
//  Created by Jayendra Ashutosh Jog on 12/20/15.
//  Copyright (c) 2015 Jayendra. All rights reserved.
//

import SpriteKit
import Darwin

class GameScene: SKScene {
 
    
    //gain access to parent controller to manipulate the score
    weak var parentController: GameViewController?
    
    var Ball = SKSpriteNode(imageNamed: "red_ball")
    
    //indent corresponds to how much of a horizontal offset each brick has from the halfway point
    //indent goes up to 120
    var cur_indent:CGFloat = 0
    
    var left_brick_sprites:[SKSpriteNode?] = []
    var right_brick_sprites:[SKSpriteNode?] = []

    var cur_score = 0
    
    var valid_position_for_ball = true
    
    var Timer = NSTimer()
    
    //Initialization
    override func didMoveToView(view: SKView)
    {
        let width = self.size.width
        let height = self.size.height
        Ball.position = CGPointMake( width/2, height/10)
        Ball.zPosition = -1
       
        //initialize the bricks
        for var y_value:CGFloat = 10; y_value <= height; y_value += 122
        {
            var left_brick = SKSpriteNode(imageNamed: "brick")
            left_brick.position = CGPointMake(width/2 - 220 + cur_indent, y_value)
            left_brick_sprites.append(left_brick)
            
            var right_brick = SKSpriteNode(imageNamed: "brick")
            right_brick.position = CGPointMake(left_brick.position.x + 440, y_value)
            right_brick_sprites.append(right_brick)
            
            self.addChild(left_brick)
            self.addChild(right_brick)
        }
    
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("SpawnWalls"), userInfo: nil, repeats: true)

        self.addChild(Ball)

    }
    
    func SpawnWalls()
    {
        if(Ball.position.x <= (right_brick_sprites[1]!.position.x - 264) || Ball.position.x + 50 >= right_brick_sprites[1]!.position.x)
        {
            Timer.invalidate()
        }
        println("\(Ball.position.x) and \(right_brick_sprites[1]!.position.x - 264 )")
        println("\(Ball.position.x + 50) and \(right_brick_sprites[1]!.position.x)")
        cur_score += 1
        parentController?.set_score(cur_score)
        let num_bricks = left_brick_sprites.count
        let decrement = self.size.height/10
        for i in 0 ... num_bricks-2
        {
            left_brick_sprites[i]!.position.x = left_brick_sprites[i+1]!.position.x
            right_brick_sprites[i]!.position.x = right_brick_sprites[i+1]!.position.x
        }
        shift_indent()
        let left_pos = self.size.width/2 - 220 + cur_indent
        left_brick_sprites[num_bricks-1]!.position.x = left_pos
        right_brick_sprites[num_bricks-1]!.position.x = left_pos + 440
    }
    
    func shift_indent()
    {
        //determine if the top brick should move to the left or right compared to the previous brick
        let direction = arc4random_uniform(2)
        
        //go right
        if direction == 1 && cur_indent <= 120
        {
            cur_indent += 25
        }
            //go left
        else if cur_indent >= -120
        {
            cur_indent -= 25
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let action = SKAction.moveToX(location.x, duration: 0.3)
            Ball.runAction(action)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>)
        {
            let location = touch.locationInNode(self)
            Ball.position.x = location.x
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
