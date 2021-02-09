//
//  PracticingBookApp.swift
//  PracticingBook
//
//  Created by Diana  on 12/30/20.
//

import SwiftUI

@main
struct ReadMeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Library())
        }
    }
}
