//
//  BaseViewModel.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/02.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
protocol  BaseViewModel {
    associatedtype Input
    associatedtype Output
    associatedtype State

    func transform(input: Input) -> Output
}
