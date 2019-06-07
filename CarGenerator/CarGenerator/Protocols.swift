//
//  Protocols.swift
//  CarGenerator
//
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation

protocol MainView: class {
    //var presenter: MainPresenter! { get set }
    func showData(array:[Car])
}

