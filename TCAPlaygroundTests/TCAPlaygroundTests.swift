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
      environment: AppEnvironment(uuid: UUID.init)
    )
    
    store.assert(
      .send(.todo(index: .zero, action: .checkboxTapped)) {
        $0.todos[.zero].isComplete = true
      }
    )
    
    store.assert(
      .send(.todo(index: .zero, action: .checkboxTapped)) {
        $0.todos[.zero].isComplete = false
      }
    )
  }
  
  func testAddTodo() {
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(uuid: { UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")! })
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
    
    store.assert(
      .send(.todo(index: 0, action: .checkboxTapped)) {
        $0.todos[0].isComplete = true
        $0.todos = [
          $0.todos[1],
          $0.todos[0],
        ]
      }
    )
    
    //    store.assert(
    //      .send(.todo(index: 0, action: .checkboxTapped)) {
    //        $0.todos[0].isComplete = true
    //        $0.swapAt(0, 1)
    //      }
    //    )
  }
}
