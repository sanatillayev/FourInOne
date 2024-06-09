//
//  NewsBuilder.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI

public final class NewsBuilder {
    public static func createNewsScene(
        presentationType: Binding<Bool>
    ) -> NewsView {
        let coordinator = NewsCoordinator(presentationType: presentationType)
        let worker = NewsWorker()
        let viewModel = NewsViewModel(worker: worker)
        let view = NewsView(viewModel: viewModel, coordinator: coordinator)
        return view
    }
}

