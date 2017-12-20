//
//  StateMachine.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-12-19.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import Foundation

enum StateMachineError: Error {
	case illegalTransitionError
}

protocol States: Hashable {}

class StateMachine<S: States> {
	
	private var _state: S
	
	var state: S {
		set(newState) {
			try! transition(to: newState)
		}
		get {
			return _state
		}
	}
	
	// The edge of a state machine,
	// between two states. Represented
	// as a pair of states.
	typealias StateEdge = HashablePair<S,S>
	
	// To get the handler for the transition A -> B,
	// it's handlers[StateEdge(A,B)]
	private var handlers = [StateEdge: (()->())?]()
	
	init(state initialState: S) {
		self._state = initialState
	}
	
	func connect(_ fromState: S, to toState: S, handler: (()->())? = nil) {
		let edge = StateEdge(fromState,toState)
		handlers[edge] = handler
	}
	
	func transition(to newState: S) throws {
		// when someone uses connect(A,to: B) to register an edge,
		// an entry is created in handlers. The value can either be
		// a callback or `nil`.
		//
		// This test allows for either case, and only triggers an error
		// if the key is unset. This is counterintuitive because you
		// would think `== nil` would catch the nil callbacks, but
		// a swift dictionary Dictionary<Key,Value> yields subscripts as follows:
		//
		// let myDict: [String: Int?] = ["a": 1, "b": nil]
		// myDict["a"]
		// >> .some(.some(1)): Int??
		// myDict["b"]
		// >> .some(.none): Int?? Optional<Int>(nil)
		// myDict["c"]
		// >> .none
		
		let currentEdge = StateEdge(_state, newState)
		
		guard let handler: (()->())? = handlers[currentEdge] else {
			throw StateMachineError.illegalTransitionError
		}
		
		// It's okay for the handler to be nil as long as it's there
		// If it's actually a defined function, call it now.
		if let nonNilHandler = handler {
			nonNilHandler()
		}
		
		self._state = newState
	}
	
	func toGraphViz() -> String {
		// Generates markup that can be parsed
		// by GraphViz `neato` etc. (`brew install graphviz`)
		// (Or use https://dreampuf.github.io/GraphvizOnline/)
		var result = "digraph StateMachine {\n"
		for connection in handlers.keys {
			result += "\t\"\(connection.first)\" -> \"\(connection.second)\";\n"
		}
		result += "}\n"
		return result
	}
}
