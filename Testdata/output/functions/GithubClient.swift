//
// WARNING: THIS FILE IS AUTOGENERATED
//          BY ChickGen 🐥
// MORE INFO: github: cpageler93/ChickGen
//
//
//  GithubClient.swift
//  Github Client
//
//  Created by Christoph Pageler on 19. May 2017, 23:09:12
//
//

import Foundation
import Quack

public class GithubClient: QuackClient {


   public func repositories(owner: String) -> QuackResult<[GithubRepository]> {

       return respondWithArray(method: .get,
                               path: "/users/\(owner)/repos",
                               model: GithubRepository.self)
   }

   public func repositories(owner: String, completion completionBlock: @escaping (QuackResult<[GithubRepository]>) -> (Void))  {

       return respondWithArrayAsync(method: .get,
                                    path: "/users/\(owner)/repos",
                                    model: GithubRepository.self,
                                    completion: completionBlock)
   }


}
