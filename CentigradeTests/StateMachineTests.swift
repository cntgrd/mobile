//
//  StateMachineTests.swift
//  CentigradeTests
//
//  Created by Paul Herz on 2017-12-19.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import XCTest

//enum MyStates: States { case A, B, C }
//func test() {
//	let sm = StateMachine(state: MyStates.A)
//	sm.connect(.A, to: .B)
//}

class StateMachineTests: XCTestCase {
	
	enum DaysOfTheWeek: States {
		case monday, tuesday, wednesday, thursday, friday, saturday, sunday
		static let allItems: [DaysOfTheWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
	}
	
	static func makeEdgeStateMachine() -> StateMachine<DaysOfTheWeek> {
		let stateMachine = StateMachine<DaysOfTheWeek>(state: .monday)
		
		// Not off-by-one. Goes until the index of the penultimate item
		// so we can iterate in pairs. Registers all legal state
		// transitions: .monday -> .tuesday etc.
		let len = DaysOfTheWeek.allItems.count
		for i in 0..<len {
			let fromState = DaysOfTheWeek.allItems[i]
			let toState = DaysOfTheWeek.allItems[(i+1) % len]
			stateMachine.connect(fromState, to: toState) {
				print("Transition \(fromState) -> \(toState)")
			}
		}
		return stateMachine
	}
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
		// StateMachine(state: .someState) should initialize the state to .someState.
		let stateMachine = StateMachineTests.makeEdgeStateMachine()
		XCTAssertEqual(stateMachine.state, .monday, "The StateMachine was given an initial state, but the .state property was not set as expected.")
    }
	
	func testValidTransitions() {
		// iterate tuesday...sunday,monday (assuming initial state is monday)
		let stateMachine = StateMachineTests.makeEdgeStateMachine()
		
		for i in 1..<DaysOfTheWeek.allItems.count {
			let oldState = stateMachine.state
			let newState = DaysOfTheWeek.allItems[i]
			
			// Make sure legal state transitions do not throw
			do {
				try stateMachine.transition(to: newState)
			} catch {
				XCTFail("The StateMachine threw an error while making a legal transition between states: \(oldState) -> \(newState).")
			}
			
			// Make sure the StateMachine.state property is updated.
			XCTAssertEqual(stateMachine.state, newState, "Transition \(oldState) to \(newState) did not actually change the .state property at all.")
		}
	}
	
	func testInvalidTransitions() {
		let stateMachine = StateMachineTests.makeEdgeStateMachine()
		XCTAssertThrowsError(
			try stateMachine.transition(to: .friday),
			"The StateMachine allowed an illegal transition .monday to .friday."
		) { error in
			print(error)
		}
	}
	
	func testGraphViz() {
		let stateMachine = StateMachineTests.makeEdgeStateMachine()
		let output = stateMachine.toGraphViz()
		print(output)
		XCTAssertNotEqual(output, "")
	}
    
}
