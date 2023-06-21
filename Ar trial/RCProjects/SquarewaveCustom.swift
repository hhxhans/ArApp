//
//  SquarewaveCustom.swift
//  Ar trial
//
//  Created by 何海心 on 2023/6/20.
//

import Foundation
import RealityKit
import simd
import Combine

@available(iOS 13.0, macOS 10.15, *)
public enum SquarewaveCustom {

    public enum LoadRealityFileError: Error {
        case fileNotFound(String)
    }

    private static var streams = [Combine.AnyCancellable]()

    public static func loadBox() throws -> SquarewaveCustom.Box {
        guard let realityFileURL = Foundation.Bundle(for: SquarewaveCustom.Box.self).url(forResource: "Squarewave", withExtension: "reality") else {
            throw SquarewaveCustom.LoadRealityFileError.fileNotFound("Squarewave.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
        let anchorEntity = try SquarewaveCustom.Box.loadAnchor(contentsOf: realityFileSceneURL)
        return createBox(from: anchorEntity)
    }

    public static func loadBoxAsync(completion: @escaping (Swift.Result<SquarewaveCustom.Box, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: SquarewaveCustom.Box.self).url(forResource: "Squarewave", withExtension: "reality") else {
            completion(.failure(SquarewaveCustom.LoadRealityFileError.fileNotFound("Squarewave.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
        let loadRequest = SquarewaveCustom.Box.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(SquarewaveCustom.createBox(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createBox(from anchorEntity: RealityKit.AnchorEntity) -> SquarewaveCustom.Box {
        let box = SquarewaveCustom.Box()
        box.anchoring = anchorEntity.anchoring
        box.addChild(anchorEntity)
        return box
    }

    public class Box: RealityKit.Entity, RealityKit.HasAnchoring {

        public var generatorboard: RealityKit.Entity? {
            return self.findEntity(named: "generatorboard")
        }



    }

}
