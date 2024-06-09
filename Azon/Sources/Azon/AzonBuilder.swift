//
//  AzonBuilder.swift
//
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI

public final class AzonBuilder {
    public static func createAzonScene(
        presentationType: Binding<Bool>
    ) -> AzonView {
        let coordinator = AzonCoordinator(presentationType: presentationType)
        let worker = AzonWorker()
        let viewModel = AzonViewModel(worker: worker)
        let view = AzonView(viewModel: viewModel, coordinator: coordinator)
        return view
    }
}
