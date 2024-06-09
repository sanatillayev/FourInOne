//
//  MovieBuilder.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI

public final class MovieBuilder {
    public static func createMovieScene(
        presentationType: Binding<Bool>
    ) -> MovieView {
        let coordinator = MovieCoordinator(presentationType: presentationType)
        let worker = MovieWorker()
        let viewModel = MovieViewModel(worker: worker)
        let view = MovieView(viewModel: viewModel, coordinator: coordinator)
        return view
    }
}

