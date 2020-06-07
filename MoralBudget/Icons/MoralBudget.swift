//
//  MoralBudget.swift
//
//  !!! AUTO-GENERATED FILE !!!!
//  !!! DO NOT EDIT DIRECTLY !!!
//  !!! generate_icon_font.py !!
//

import KTDIconFont

public enum MoralBudget: unichar, IconFont {
    case notFound = 0x0
    
    case publicworks = 0xe907
    case health = 0xe902
    case legal = 0xe903
    case work = 0xe904
    case social = 0xe905
    case debt = 0xe906
    case housing = 0xe900
    case planning = 0xe901
    case fire = 0xe90d
    case infrastructure = 0xe913
    case books = 0xe914
    case policeman = 0xe915
    case park = 0xe918
    
    public static var fontFileName: String {
        return "MoralBudget"
    }
}

extension UIImageView: IconAppearance {
    public typealias AssociatedIcon = MoralBudget
}

extension UIButton: IconAppearance {
    public typealias AssociatedIcon = MoralBudget
}

extension UIBarItem: IconAppearance {
    public typealias AssociatedIcon = MoralBudget
}
