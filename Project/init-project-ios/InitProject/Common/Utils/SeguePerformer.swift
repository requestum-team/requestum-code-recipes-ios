//
//  SeguePerformer.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation
import Rswift

protocol SeguePerformer {
    
    func performSegue<Segue, Source, Destination>(
        withIdentifier segueIdentifier: StoryboardSegueIdentifier<Segue, Source, Destination>,
        configuration: ((_ sourceViewController: Source, _ destinationViewController: Destination) -> Void)?
    )
}


extension SeguePerformer where Self: UIViewController {
    
    func performSegue<Segue, Source, Destination>(
        withIdentifier segueIdentifier: StoryboardSegueIdentifier<Segue, Source, Destination>,
        configuration: ((_ sourceViewController: Source, _ destinationViewController: Destination) -> Void)? = nil) {
        
        let segueInfo = SegueInfo()
        segueInfo.segueIdentifier = segueIdentifier.identifier
        segueInfo.configurationBlock = { sourceViewController, destinationViewController in
            
            if let source = sourceViewController as? Source, let destination = destinationViewController as? Destination {
                configuration?(source, destination)
            }
        }
        
        performSegue(withIdentifier: segueIdentifier.identifier, sender: segueInfo)
    }
}


final class SegueInfo {
    
    var segueIdentifier: String!
    var configurationBlock: ((_ sourceViewController: UIViewController, _ destinationViewController: UIViewController) -> Void)?
}
