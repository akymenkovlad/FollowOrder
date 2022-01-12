//
//  Game.swift
//  FollowTheOrder
//
//  Created by Valados on 12.12.2021.
//

import Foundation

class Game {
    
    var level:Int
    var playlist = [Int]()
    var numberOfTaps = 0
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
    
    func createPlaylist() {
        playlist = Array(0..<elements)
        playlist.shuffle()
    }
}

struct Wish:Codable {
    var fortune:String?
}

enum Emoji: String,CaseIterable {
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
