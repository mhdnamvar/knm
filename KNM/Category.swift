//
//  Category.swift
//  KNM
//
//  Created by Mohammad Namvar on 24/02/2019.
//  Copyright © 2019 Mohammad Namvar. All rights reserved.
//

import UIKit

enum Category: Int16 {
    
    case nederland, mensen, gezondheid, wonen, dienstverlening,
        opvoedingEnOnderwijs, werken, samenLeven, geschiedenis, politiek, unknown
    
    func getColor() -> UIColor {
        switch self {
            case .nederland: return UIColor.rgb(red: 3, green: 61, blue: 245)
            case .mensen: return UIColor.rgb(red: 136, green: 38, blue: 80)
            case .gezondheid: return UIColor.rgb(red: 63, green: 140, blue: 39)
            case .wonen: return UIColor.rgb(red: 146, green: 146, blue: 146)
            case .dienstverlening: return UIColor.rgb(red: 235, green: 64, blue: 37)
            case .opvoedingEnOnderwijs: return UIColor.rgb(red: 31, green: 84, blue: 142)
            case .werken: return UIColor.rgb(red: 62, green: 150, blue: 247)
            case .samenLeven: return UIColor.rgb(red: 239, green: 133, blue: 125)
            case .geschiedenis: return .orange
            case .politiek: return UIColor.rgb(red: 140, green: 85, blue: 27)
            case .unknown: return .red
        }
    }
    
    func getText() -> String {
        switch self {
            case .nederland: return "Het land"
            case .mensen: return "De mensen"
            case .gezondheid: return "Gezondheid"
            case .wonen: return "Wonen"
            case .dienstverlening: return "Dienstverlening"
            case .opvoedingEnOnderwijs: return "Opvoeding en Onderwijs"
            case .werken: return "Werken"
            case .samenLeven: return "Samenleven"
            case .geschiedenis: return "Geschidenis"
            case .politiek: return "Politiek"
            case .unknown: return "Unknown"
        }
    }
    
    static func from(text: String) -> Category {
        switch text {
            case "Het land": return .nederland
            case "De mensen": return .mensen
            case "Gezondheid": return .gezondheid
            case "Wonen": return .wonen
            case "Dienstverlening": return .dienstverlening
            case "Opvoeding en Onderwijs" : return .opvoedingEnOnderwijs
            case "Werken": return .werken
            case "Samenleven": return .samenLeven
            case "Geschidenis": return .geschiedenis
            case "Politiek": return .politiek
            default: return .unknown
        }
    }
}
