//
//  TextRecognizer.swift
//  TextRecognizer
//
//  Created by Pepe Becker on 2023/01/30.
//

import AppKit
import Vision

public struct TextRecognizer {

  public static func supportedLanguages() throws -> [String] {
    return try VNRecognizeTextRequest().supportedRecognitionLanguages()
  }

  public static func recognize(cgImage: CGImage, languages: [String], done: @escaping ([String]?, Error?) -> Void) {
    var results = [String]()
    let request = VNRecognizeTextRequest { (request, error) in
      for observation in request.results as! [VNRecognizedTextObservation] {
        for candiate in observation.topCandidates(1) {
          results.append(candiate.string)
        }
      }
      done(results, nil)
    }
    request.recognitionLanguages = languages
    request.recognitionLevel = .accurate
    let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    do {
      try imageRequestHandler.perform([request])
    } catch {
      done(nil, error)
    }
  }

  public static func recognize(image: NSImage, languages: [String], done: @escaping ([String]?, Error?) -> Void) {
    guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
      done(nil, NSError(domain: "TextRecognizer", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert NSImage to CGImage"]))
      return
    }
    recognize(cgImage: cgImage, languages: languages, done: done)
  }

  public static func recognize(cgImage: CGImage, languages: [String]) throws -> [String] {
    let semaphore = DispatchSemaphore(value: 0)
    var results = [String]()
    var error: Error?
    recognize(cgImage: cgImage, languages: languages) { res, err in
      error = error
      results = res ?? []
      semaphore.signal()
    }
    semaphore.wait()
    if let error = error {
      throw error
    }
    return results
  }

  public static func recognize(image: NSImage, languages: [String]) throws -> [String] {
    if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
      return try recognize(cgImage: cgImage, languages: languages)
    }
    throw NSError(domain: "TextRecognizer", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert NSImage to CGImage"])
  }

}
