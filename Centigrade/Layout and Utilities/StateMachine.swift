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
	case unhandledEventError
}

public protocol States: Hashable {}
public protocol Events: Hashable {}

public enum NoEvents: Events {
	public var hashValue: Int {
		return 0
	}
}

public func ==(lhs: NoEvents, rhs: NoEvents) -> Bool {
	return true
}

typealias StateMachine<S: States> = EventStateMachine<S, NoEvents>

public class EventStateMachine<S: States, E: Events> {
	
	private var _state: S
	
	public var state: S {
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
	public typealias StateEdge = HashablePair<S,S>
	
	public typealias Handler = () -> ()
	
	// To get the handler for the transition A -> B,
	// it's edgeHandlers[StateEdge(A,B)]
	private var edgeHandlers = [StateEdge: Handler?]()
	
	// To get handler for an event E,
	// it's eventHandlers[E].
	// If there's no handlers, it's not a problem
	// (unlike edgeHandlers)
	private var eventHandlers = [E: Handler]()
	
	// Which transitions to make when an event is triggered.
	private var eventTransitions = [E: [S: S]]()
	
	public init(state initialState: S) {
		self._state = initialState
	}
	
	public func connect(_ fromState: S, to toState: S, handler: Handler? = nil) {
		let edge = StateEdge(fromState, toState)
		edgeHandlers[edge] = handler
	}
	
	public func on(event: E, handler: @escaping Handler) {
		eventHandlers[event] = handler
	}
	
	public func on(event: E, transitions: [S: S]) {
		if eventTransitions[event] == nil {
			eventTransitions[event] = [:]
		}
		for (fromState, toState) in transitions {
			eventTransitions[event]?[fromState] = toState
		}
	}
	
	// Event-based transitioning:
	//
	// given an event E, checks eventHandlers for a key == E,
	// then checks the value dictionary [S:S] for a valid state
	// pair.
	//
	// If the event is not in the eventHandlers dictionary,
	// this will throw an error.
	//
	// The event key has a corresponding transitions dictionary [S: S]
	// representing routes to be taken (the value) given a current state
	// (the key). If the current state is not in that dictionary,
	// this will throw an error.
	public func trigger(event: E) throws {
		guard let transitions = eventTransitions[event] else {
			throw StateMachineError.unhandledEventError
		}
		guard let nextState = transitions[self.state] else {
			throw StateMachineError.unhandledEventError
		}
		
		// State set BEFORE handlers to prevent races.
		// We set _state directly to avoid valid edge checking, because
		// a defined route for an event overrides defined valid edges.
		_state = nextState
		
		// Call edge handler if it exists but otherwise do nothing
		let edge = StateEdge(state, nextState)
		if let edgeHandler: Handler? = edgeHandlers[edge] {
			edgeHandler?()
		}
		
		// Call event handler if it exists but otherwise do nothing
		// (unlike edgeHandlers, whose entries prove a valid edge,
		// eventHandlers exist in *addition* to valid event routes,
		// so entries are never nil if the key exists.)
		if let eventHandler: Handler = eventHandlers[event] {
			eventHandler()
		}
	}
	
	// State-based transitioning:
	//
	// checks edgeHandlers for a key == StatePair(oldState, newState)
	// to validate the transition.
	// Whether the value is nil or a handler is entirely irrelevant
	// to the validity of the transition, but if it exists, it will be called.
	public func transition(to newState: S) throws {
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
		
		guard let handler: Handler? = edgeHandlers[currentEdge] else {
			throw StateMachineError.illegalTransitionError
		}
		
		// It's okay for the handler to be nil as long as it's there
		// If it's actually a defined function, call it now.
		if let nonNilHandler = handler {
			nonNilHandler()
		}
		
		self._state = newState
	}
	
	public func toGraphViz() -> String {
		// Generates markup that can be parsed
		// by GraphViz `neato` etc. (`brew install graphviz`)
		// (Or use https://dreampuf.github.io/GraphvizOnline/)
		var result = "digraph StateMachine {\n"
		for connection in edgeHandlers.keys {
			result += "\t\"\(connection.first)\" -> \"\(connection.second)\";\n"
		}
		result += "}\n"
		return result
	}
}
