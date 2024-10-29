//
//  Grammar.swift
//  RHCount
//
//  Created by Lunasol on 10/28/24.
//

//SwiftUI 2-4
import Foundation
import UIKit

let littleLabel: UILabel = {
    let littleLabel = UILabel()
    littleLabel.text = "lunasol"
    return littleLabel
}() //调用 这个括号 这个就是没有参数的closure 只有return value


//1 左边和右边只有一个地方写类型就行 一般左边写更好
//let todo: () -> String = {()-> String in "lunasol"}
//todo()
//2
//let todo: () -> String = {()-> String in "lunasol"}() // type is string not closure

//swift closure和class 是引用类型 其他全都是值类型

//闭包可以是没有名字的函数 但是一旦给了一个变量  就跟正常定义的函数一样

// 作为别的函数的参数的closure 叫回调函数 （callback） 先调用外层getJob才调用这个staticTodo的
// 回调函数的3种： 回调函数的变量传进去；直接传回调函数的函数体；直接给函数名

//overload 函数参数名 返回值 or个数不一样 就是可以重载的



//闭包作为返回值 没讲



//尾随闭包 在最后只剩下一个参数的时候。 前几个都是正常参数 最后一个是闭包
