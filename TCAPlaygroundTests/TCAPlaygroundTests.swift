//
//  TCAPlaygroundTests.swift
//  TCAPlaygroundTests
//
//  Created by Junsang Ryu on 2022/05/02.
//

import ComposableArchitecture
import XCTest

@testable import TCAPlayground

class TodosTests: XCTestCase {
  let scheduler = DispatchQueue.test
    
  func testCompletingTodo() {
    let store = TestStore(
      initialState: AppState(
        todos: [
          Todo(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            description: "Milk",
            isComplete: false
          )
        ]
      ),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler(),
        uuid: UUID.init
      )
    )
    
//    store.assert(
//      .send(.todo(index: .zero, action: .checkboxTapped)) {
//        $0.todos[.zero].isComplete = true
//      }
//    )
//
//    store.assert(
//      .send(.todo(index: .zero, action: .checkboxTapped)) {
//        $0.todos[.zero].isComplete = false
//      }
//    )
    
    store.assert(
      .send(.todo(index: 0, action: .checkboxTapped)) {
        $0.todos[0].isComplete = true
      },
      .do {
        self.scheduler.advance(by: 1)
      },
      .receive(.todoDelayCompleted)
    )
  }
  
  func testAddTodo() {
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler(),
        uuid: { UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")! }
      )
    )
    
    store.assert(
      .send(.addButtonTapped) {
        $0.todos = [
          Todo(
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!,
            description: "",
            isComplete: false
          )
        ]
      }
    )
  }
  
  func testTodoSorting() {
    let store = TestStore(
      initialState: AppState(
        todos: [
          Todo(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            description: "Milk",
            isComplete: false
          ),
          Todo(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            description: "Eggs",
            isComplete: false
          )
        ]
      ),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler(),
        uuid: { fatalError("unimplemented") }
      )
    )
    
    //    store.assert(
    //      .send(.todo(index: 0, action: .checkboxTapped)) {
    //        $0.todos[0].isComplete = true
    //        $0.todos = $0.todos
    //          .enumerated()
    //          .sorted(by: { lhs, rhs in
    //            (rhs.element.isComplete && !lhs.element.isComplete) || lhs.offset < rhs.offset
    //          })
    //          .map(\.element)
    //      }
    //    )
    
//    store.assert(
//      .send(.todo(index: 0, action: .checkboxTapped)) {
//        $0.todos[0].isComplete = true
//        $0.todos = [
//          $0.todos[1],
//          $0.todos[0],
//        ]
//      }
//    )
    
    //    store.assert(
    //      .send(.todo(index: 0, action: .checkboxTapped)) {
    //        $0.todos[0].isComplete = true
    //        $0.swapAt(0, 1)
    //      }
    //    )
    
//    store.assert(
//      .send(.todo(index: 0, action: .checkboxTapped)) {
//        $0.todos[0].isComplete = true
//      },
//      .do {
//        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
//      },
//      .receive(.todoDelayCompleted) {
//        $0.todos.swapAt(0, 1)
//      }
//    )
    
    store.assert(
      .send(.todo(index: 0, action: .checkboxTapped)) {
        $0.todos[0].isComplete = true
      },
      .do {
        self.scheduler.advance(by: 1)
      },
      .receive(.todoDelayCompleted) {
        $0.todos.swapAt(0, 1)
      }
    )
  }
  
  func testTodoSorting_Cancellation() {
    let todos = [
      Todo(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        description: "Milk",
        isComplete: false
      ),
      Todo(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        description: "Eggs",
        isComplete: false
      )
    ]

    let store = TestStore(
      initialState: AppState(todos: todos),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler(),
        uuid: UUID.init
      )
    )

//    store.assert(
//      .send(.todo(index: 0, action: .checkboxTapped)) {
//        $0.todos[0].isComplete = true
//      },
//      .do {
//        self.scheduler.advance(by: 1)
//      },
//      .receive(.todoDelayCompleted) {
//        $0.todos.swapAt(0, 1)
//      }
//    )
    
//    store.assert(
//      .send(.todo(index: 0, action: .checkboxTapped)) {
//        $0.todos[0].isComplete = true
//      },
//      .do {
//        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
//      },
//      .send(.todo(index: 0, action: .checkboxTapped)) {
//        $0.todos[0].isComplete = false
//      },
//      .do {
//        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
//      },
//      .receive(.todoDelayCompleted)
//    )
    
    store.assert(
      .send(.todo(index: 0, action: .checkboxTapped)) {
        $0.todos[0].isComplete = true
      },
      .do {
        self.scheduler.advance(by: 0.5)
      },
      .send(.todo(index: 0, action: .checkboxTapped)) {
        $0.todos[0].isComplete = false
      },
      .do {
        self.scheduler.advance(by: 1)
      },
      .receive(.todoDelayCompleted)
    )
  }
}
