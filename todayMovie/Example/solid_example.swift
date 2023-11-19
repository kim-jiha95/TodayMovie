//
//  solid_example.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/09.
//

import Foundation

// 1. srp
class Employee {
    var name: String
    var salary: Double
    
    init(name: String, salary: Double) {
        self.name = name
        self.salary = salary
    }
}

class PayrollSystem {
    func calculatePay(employee: Employee) -> Double {
        // 급여 계산 로직
        return employee.salary
    }
}

class TaxCalculator {
    func calculateTax(employee: Employee) -> Double {
        return employee.salary * 0.2
    }
}

// 2.ocp
protocol Shape {
    func area() -> Double
}

class Rectangle: Shape {
    var width: Double
    var height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    func area() -> Double {
        return width * height
    }
}

class Circle: Shape {
    var radius: Double
    
    init(radius: Double) {
        self.radius = radius
    }
    
    func area() -> Double {
        return Double.pi * radius * radius
    }
}

func calculateArea(shape: Shape) -> Double {
    return shape.area()
}

// 3. Lsp
class Bird {
    func fly() {

    }
}

class Ostrich: Bird {
    override func fly() {
        
    }
}

// 4. ISP
protocol Worker {
    func work()
    func eat()
}

class Robot: Worker {
    func work() {
        
    }
    
    func eat() {
        
    }
}

class Human: Worker {
    func work() {
        
    }
    
    func eat() {
        
    }
}

// 5. DIP
protocol Switchable {
    func turnOn()
    func turnOff()
}

class Light: Switchable {
    func turnOn() {
        
    }
    
    func turnOff() {

    }
}

class Fan: Switchable {
    func turnOn() {
        
    }
    
    func turnOff() {
        
    }
}

class Switch {
    var device: Switchable
    
    init(device: Switchable) {
        self.device = device
    }
    
    func turnOn() {
        device.turnOn()
    }
    
    func turnOff() {
        device.turnOff()
    }
}

