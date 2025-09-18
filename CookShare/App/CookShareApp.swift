//
//  CookShareApp.swift
//  CookShare
//
//  Created by Olga Dragon on 21.08.2025.
//

import SwiftUI

@main
struct CookShareApp: App {
    
    private let deps: AppDependencies
    private let listVM: RecipeListViewModel
    
    init(){
        let deps = AppDependencies(api: APIClient())
        self.deps = deps
        self.listVM = RecipeListViewModel(api: deps.api)
    }
    var body: some Scene {
        WindowGroup {
            RootView(deps: deps)
                .environmentObject(listVM)
        }
    }
}
