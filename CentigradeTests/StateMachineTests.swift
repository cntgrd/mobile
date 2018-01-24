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
	
	var notificationCenter: NotificationCenter = NotificationCenter()
	
	static let edgeHandlerNotfication = Notification.Name("me.cntgrd.CentigradeTests.StateMachineTests.edgeHandlerNotification")
	static let eventHandlerNotification = Notification.Name("me.cntgrd.CentigradeTests.StateMachineTests.eventHandlerNotification")
	
	enum DaysOfTheWeek: States {
		case monday, tuesday, wednesday, thursday, friday, saturday, sunday
		static let allItems: [DaysOfTheWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
	}
	
	enum DaysOfTheWeekEvents: Events {
		case next
		case dummyEvent
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
				NotificationCenter.default.post(name: StateMachineTests.edgeHandlerNotfication, object: self)
			}
		}
		return stateMachine
	}
	
	static func makeEventStateMachine() -> EventStateMachine<DaysOfTheWeek, DaysOfTheWeekEvents> {
		let stateMachine = EventStateMachine<DaysOfTheWeek, DaysOfTheWeekEvents>(state: .monday)
		stateMachine.on(event: .next, transitions: [
			.monday:    .tuesday,
			.tuesday:   .wednesday,
			.wednesday: .thursday,
			.thursday:  .friday,
			.friday:    .saturday,
			.saturday:  .sunday,
			.sunday:    .monday
		])
		return stateMachine
	}
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEdgeInitialization() {
		// StateMachine(state: .someState) should initialize the state to .someState.
		let stateMachine = StateMachineTests.makeEdgeStateMachine()
		XCTAssertEqual(stateMachine.state, .monday, "The edge-based StateMachine was given an initial state, but the .state property was not set as expected.")
    }
	
	func testEventInitialization() {
		let stateMachine = StateMachineTests.makeEventStateMachine()
		XCTAssertEqual(stateMachine.state, .monday, "The event-based StateMachine was given an initial state, but the .state property was not set as expected.")
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
	
	/*func testEdgeHandlers() {
		let expectation = XCTNSNotificationExpectation(
			name: StateMachineTests.edgeHandlerNotfication,
			object: self,
			notificationCenter: notificationCenter
		)
		
		let stateMachine = StateMachineTests.makeEdgeStateMachine()
		
		for i in 1..<DaysOfTheWeek.allItems.count {
			let oldState = stateMachine.state
			let newState = DaysOfTheWeek.allItems[i]
			print("Attempting \(oldState) -> \(newState)")
			// Make sure legal state transitions do not throw
			do {
				wait(for: [expectation], timeout: 0)
				try stateMachine.transition(to: newState)
			} catch {
				XCTFail("The StateMachine threw an error while making a legal transition between states: \(oldState) -> \(newState).")
			}
		}
	}*/
	
	func testValidEvents() {
		let stateMachine = StateMachineTests.makeEventStateMachine()
		for _ in 0..<7 {
			do {
				try stateMachine.trigger(event: .next)
			} catch {
				XCTFail("The StateMachine threw an error while processing a legal event (.next)")
			}
		}
	}
	
	func testInvalidEvents() {
		let stateMachine = StateMachineTests.makeEventStateMachine()
		XCTAssertThrowsError(
			try stateMachine.trigger(event: .dummyEvent),
			"The StateMachine allowed an unregistered event (.dummyEvent)."
		) { error in
			print(error)
		}
	}
	
	func testEventHandlers() {
		let expectation = XCTNSNotificationExpectation(
			name: StateMachineTests.eventHandlerNotification,
			object: self,
			notificationCenter: notificationCenter
		)
		
		let stateMachine = StateMachineTests.makeEventStateMachine()
		stateMachine.on(event: .next) {
			self.notificationCenter.post(
				name: StateMachineTests.eventHandlerNotification,
				object: self
			)
		}
		
		// monday -> tuesday, sunday -> monday
		for _ in 0..<7 {
			try! stateMachine.trigger(event: .next)
			wait(for: [expectation], timeout: 0)
		}
	}
	
	func testGraphViz() {
		let stateMachine = StateMachineTests.makeEdgeStateMachine()
		let output = stateMachine.toGraphViz()
		print(output)
		XCTAssertNotEqual(output, "")
	}
    
}
