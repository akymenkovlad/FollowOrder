//
//  Game.swift
//  FollowTheOrder
//
//  Created by Valados on 12.12.2021.
//

import Foundation
import RealmSwift


class Game {
    var level:Int
    
    var playlist = [Int]()
    var currentItem = 0
    var numberOfTaps = 0
    var readyForUser:Bool = false
    var elements:Int
    
    init() {
        level = 1
        elements = 2
        createPlaylist()
    }
    init(level:Int) {
        elements = 1+level
        self.level = level
        createPlaylist()
    }
    func createPlaylist(){
        for _ in 0..<elements{
            var randomNumber = Int(arc4random_uniform(UInt32(elements))+1)
            
            while (playlist.contains(randomNumber)){
                randomNumber = Int(arc4random_uniform(UInt32(elements))+1)
            }
            print(randomNumber)
            playlist.append(randomNumber)

        }
    }
}

struct Wish:Codable{
    var fortune:String?
}

enum Emoji: String,CaseIterable{
    case anger = "anger_emoji"
    case love = "love_emoji"
    case sad = "sad_emoji"
    case laughter = "laughter_emoji"
    case cool = "cool_emoji"
    case sick = "sick_emoji"
    case shocked = "shocked_emoji"
    case tease = "tease_emoji"
    case hug = "hug_emoji"
    case cry = "cry_emoji"
    case angel = "angel_emoji"
}
class Level: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var level: Int = 0
    convenience init(level: Int) {
            self.init()
            self.level = level
        }
}